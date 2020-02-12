//
//  UserDAO.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/12.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "BaseDAO.h"
NS_ASSUME_NONNULL_BEGIN
@interface UserDAO :BaseDAO

+ (UserDAO *)sharedInstance;
//插入user方法
- (int)create:(User *)model;
//删除user方法
- (int)remove:(User *)model;
//查询user方法
- (User *)findUser;
@end

NS_ASSUME_NONNULL_END
