//
//  DBHelper.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/12.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

#define DB_FILE_NAME @"TF_order.db"

static sqlite3 * _Nonnull db;
NS_ASSUME_NONNULL_BEGIN

@interface DBHelper : NSObject
//获得沙箱document目录下全路径
+(const char *)applicationDocumentsDirectoryFile:(NSString *)fileName;
//初始化并加载数据
+(void)initDB;
@end

NS_ASSUME_NONNULL_END
