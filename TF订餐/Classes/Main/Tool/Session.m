//
//  Session.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/9.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "Session.h"
#import "HttpClient.h"
#import "NSString+TF.h"
#import "UserDAO.h"
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "TabBarViewController.h"


@implementation Session
static Session *_shareSession=nil;
+ (instancetype)sharedSession {  //单例模式
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shareSession = [[Session alloc] init];
        
    });
    return _shareSession;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dao=[UserDAO sharedInstance];
        _user = [self loadUser];
        if (_user) {
            _userStatus = SessionUserStatusLogined;
        }
    }
    return self;
}
-(void)userLogin:(NSString *)username pwd:(NSString *)pwd  result:(void(^)(NSError *error))result{
    
    NSString *psw_encrypt = [NSString encrypt3DES:pwd key:BLDESkey];
    NSDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"OPT":@"1",
                                                                          @"pwd":psw_encrypt,
                                                                          @"empNo":username}];
    [[HttpClient sharedClient]postWithParams:param success:^(id  _Nonnull responseObj) {
        User *user_login=[User mj_objectWithKeyValues:responseObj];
        [self loginSuccess:user_login];
        NSLog(@"%@",user_login);
        if (result) {
            result(nil);
        }
    } faliture:^(NSError * _Nonnull error) {
        if (result) {
            result(error);
        }
    } autoShowError:NO];
}
+ (BOOL)isLogin // 判断是否登录
{
    return [[Session sharedSession] user]!=nil;
}
-(void)loginSuccess:(User *)user //登录成功
{
    [self willChangeValueForKey:@"user"];
    _user=user;
    [self didChangeValueForKey:@"user"];
    [self saveUser:_user];
    [self updateUserStatus:SessionUserStatusLogined];

}
-(User *)loadUser //加载缓存的用户
{
    User *user_db=[self.dao findUser];
    return user_db;
}
-(void)saveUser:(User *)user //保存用户
{
    if(user!=nil)
    {
        [self.dao create:user];
    }
}
-(void)updateUser:(User *)user //更新用户信息
{
    [self willChangeValueForKey:@"user"];
    _user=user;
    [self didChangeValueForKey:@"user"];
    [self saveUser:_user];
}
- (void)updateUserStatus:(SessionUserStatus)status //更新用户状态
{
    [self willChangeValueForKey:@"userStatus"];
    _userStatus = status;
    [self didChangeValueForKey:@"userStatus"];
}

-(void)removeUser:(User *)user //移除缓存的用户
{
    if(user)
    {
        [self.dao remove:user];
    }
}
- (void)userLogout:(User *)user_out
{
    [self removeUser:user_out];
    [self willChangeValueForKey:@"user"];
    _user=nil;
    [self didChangeValueForKey:@"user"];
    [self updateUserStatus:SessionUserStatusLogout];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
       NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
       [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
       }];
}
-(void)modifyPasswordWithOriginalPsw:(NSString *)originalPsw newPsw:(NSString *)newPsw newPswAgain:(NSString *)newPswAgain result:(void(^)(NSError *error))result
{
    
    UserDAO *dao=[UserDAO sharedInstance];
    User *user_1=[dao findUser];
    NSString *token=user_1.token;
    NSString *OPT = @"5";
    NSString *originPwd = [NSString encrypt3DES:originalPsw key:BLDESkey];
    NSString *newPwd = [NSString encrypt3DES:newPsw key:BLDESkey];
    NSString *newPwdAgain = [NSString encrypt3DES:newPswAgain key:BLDESkey];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"token":token,
                                                                                 @"OPT":OPT,
                                                                                 @"originPwd":originPwd,
                                                                                 @"newPwd":newPwd,
                                                                                 @"newPwdAgain":newPwdAgain}];
    [[HttpClient sharedClient] postWithParams:param success:^(id json) {
        if (result) {
            result(nil);
        }
        
    } faliture:^(NSError *error) {
        if (result) {
            result(error);
        }
    } autoShowError:YES];

}
@end
