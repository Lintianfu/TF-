//
//  BaseDAO.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/12.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "BaseDAO.h"

@implementation BaseDAO
-(id)init
{
    self=[super init];
    if(self)
    {
        [DBHelper initDB];
    }
    return self;
}
-(BOOL)openDB
{
       const char* dbFilePath = [DBHelper applicationDocumentsDirectoryFile:DB_FILE_NAME];
       if (sqlite3_open(dbFilePath, &db) != SQLITE_OK) {
           sqlite3_close(db);
           NSLog(@"数据库打开失败。");
           return FALSE;
       }
       NSLog(@"%s",dbFilePath);
       return TRUE;
}
@end
