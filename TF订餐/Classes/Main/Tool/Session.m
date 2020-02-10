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
        _user.uid = [self loadUser];
        if (_user.uid) {
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
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].windows[0].rootViewController = [[TabBarViewController alloc] init];
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
-(NSString *)loadUser //加载缓存的用户
{
    NSString *user_uid=[[NSUserDefaults standardUserDefaults] objectForKey:BLDUserKey];
    //NSLog(@"读取出来的uid%@",user_uid);
    return user_uid;
}
-(void)saveUser:(User *)user //保存用户
{
    if(user==nil)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:BLDUserKey];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:user.uid forKey:BLDUserKey];
        //NSLog(@"用户保存的uid%@",user.uid);
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:BLDUserKey];
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
@end
