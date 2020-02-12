//
//  BaseDAO.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/12.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHelper.h"
#import "sqlite3.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseDAO : NSObject
{
    sqlite3 *db;
}
-(BOOL)openDB;
@end

NS_ASSUME_NONNULL_END
