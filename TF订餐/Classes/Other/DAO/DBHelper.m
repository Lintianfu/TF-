//
//  DBHelper.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/12.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper
+(const char *)applicationDocumentsDirectoryFile:(NSString *)fileName
{
    NSString *documentDirectory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    NSString *path=[documentDirectory stringByAppendingPathComponent:fileName];
    const char *cpath=[path UTF8String];
    return cpath;

}
+(void)initDB
{
    const char *dbFilePath = [DBHelper applicationDocumentsDirectoryFile:DB_FILE_NAME];
    if(sqlite3_open(dbFilePath, &db) == SQLITE_OK)
    {
        NSString *sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS User(username text PRIMARY KEY ,uid text,token text,avatar text);"];
        const char *csql=[sql UTF8String];
        if(sqlite3_exec(db, csql, NULL, NULL, NULL)!=SQLITE_OK)
        {
            NSLog(@"建表失败");
        }
        else{
            NSLog(@"建表成功");
        }
    }
    else{
        NSLog(@"数据库打开失败");
    }
    sqlite3_close(db);
}
@end
