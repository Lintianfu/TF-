//
//  AppDelegate.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/6.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "Session.h"
#import "User.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UserDAO.h"


#define BLDESkey  @"ASDHOjhudhaos23asdihoh80"
#define BLMD5key   @"IAASIDuioponuYBIUNLIK123ikoIO"
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self initIndexController];
    [self registerThirdService:launchOptions];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)initIndexController
{
   UserDAO *dao=[UserDAO sharedInstance];
   User *user=[dao findUser];
    if(user==nil)
    {
        self.window.rootViewController=[[LoginViewController alloc]init];
    }
    else
    {
        TabBarViewController *tab=[[TabBarViewController alloc]init];
        self.window.rootViewController=tab;
    }
}
-(void)registerThirdService:(NSDictionary *)launchOptions {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = NO;//隐藏键盘上方toolBar
    keyboardManager.shouldResignOnTouchOutside = YES;//点击textField/textView外收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
}



#pragma mark - UISceneSession lifecycle


/*- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}*/


@end
