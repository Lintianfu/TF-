//
//  Session.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/9.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
NS_ASSUME_NONNULL_BEGIN
//app端传输 key
#define BLMD5key   @"IAASIDuioponuYBIUNLIK123ikoIO"
// 加密 key
#define BLDESkey  @"ASDHOjhudhaos23asdihoh80"

//键值-存储key
#define BLDUserKey @"BLDUserKey"


typedef NS_ENUM(NSUInteger,SessionUserStatus){
    /**
     *  默认未登录
     */
    SessionUserStatusDefault,
    /**
     *  已经登录
     */
    SessionUserStatusLogined,
    /**
     *  退出登录
     */
    SessionUserStatusLogout
} ;

@interface Session : NSObject
@property(nonatomic,strong)User *user;
@property(nonatomic,assign)SessionUserStatus userStatus;



+ (instancetype)sharedSession;
+ (BOOL)isLogin;//是否已经登录
- (void)userLogout:(User *)user_out;//退出登录
- (void)loginSuccess:(User *)user;//登录成功

- (void)saveUser:(User *)user;//保存用户
- (NSString *)loadUser;//加载缓存的用户
-(void)removeUser:(User *)user; //移除缓存的用户

- (void)updateUserStatus:(SessionUserStatus)status;//更新用户状态
-(void)updateUser:(User *)user; //更新用户信息

/*
 用户登录接口
 *
 *  @param username 用户名
 *  @param pwd      密码
 *  @param result   返回值
 */
-(void)userLogin:(NSString *)username pwd:(NSString *)pwd  result:(void(^)(NSError *error))result;
@end

NS_ASSUME_NONNULL_END
