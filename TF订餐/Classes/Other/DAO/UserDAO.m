//
//  UserDAO.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/12.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "UserDAO.h"
@implementation UserDAO

static UserDAO *sharedSingleton = nil;

+(UserDAO *)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{

        sharedSingleton = [[super alloc] init];

    });
    return sharedSingleton;
}

-(int)create:(User *)model
{
    if([self openDB])
    {
        NSString *sqlStr=@"insert or replace into User(username,uid,token,avatar)VALUES(?,?,?,?)";
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL)==SQLITE_OK)
        {
            const char *cusername=[model.username UTF8String];
            const char *cuid=[model.uid UTF8String];
            const char *ctoken=[model.token UTF8String];
            const char *cavatar=[model.avatar UTF8String];
        
            
            sqlite3_bind_text(statement, 1, cusername, -1, NULL);
            sqlite3_bind_text(statement, 2, cuid, -1, NULL);
            sqlite3_bind_text(statement, 3, ctoken, -1, NULL);
            sqlite3_bind_text(statement, 4, cavatar, -1, NULL);
        
            if(sqlite3_step(statement)!=SQLITE_DONE)
            {
                NSLog(@"插入数据User失败");
            }else
            {
                NSLog(@"数据插入成功");
            }
            
        }
        sqlite3_finalize(statement);
    }
     sqlite3_close(db);
    return 0;
}
- (int)remove:(User *)model {
    if ([self openDB]) {
        NSString *sqlStr = @"delete from User where uid=?";
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //绑定参数开始
             const char *cuid=[model.uid UTF8String];
             sqlite3_bind_text(statement, 1, cuid, -1, NULL);
            //执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"删除数据失败%s",sqlite3_errmsg(db));
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(db);
    return 0;
}
-(User *)findUser
{
    if ([self openDB]) {
        NSString *qsql = @"SELECT username,uid,token,avatar FROM User";
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                User *user=[[User alloc]init];
                char *cusername = (char *) sqlite3_column_text(statement, 0);
                char *cuid = (char *) sqlite3_column_text(statement, 1);
                char *ctoken = (char *) sqlite3_column_text(statement,2);
                char *cavatar = (char *) sqlite3_column_text(statement, 3);
                user.username = [[NSString alloc] initWithUTF8String:cusername];
                user.token = [[NSString alloc] initWithUTF8String:ctoken];
                user.uid = [[NSString alloc] initWithUTF8String:cuid];
                user.avatar = [[NSString alloc] initWithUTF8String:cavatar];
                sqlite3_finalize(statement);
                sqlite3_close(db);
                return user;
            }
        }
         sqlite3_finalize(statement);
    }
    sqlite3_close(db);
    return nil;
}

@end
