//
//  TabBarViewController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/6.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "TabBarViewController.h"
#import "UIImage+TF.h"
#import "NavigationController.h"
#import "HomeViewController.h"
#import "HistoryOrdersViewController.h"
#import "SettingViewController.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabbar];
    [self addChildViewControllers];

    
    // Do any additional setup after loading the view.
}
-(void)initTabbar
{
    UITabBar *tabBar=[[UITabBar alloc]init];
    [self setValue:tabBar forKey:@"tabBar"];
    
    UITabBarItem *tabBaritemapperance=[UITabBarItem appearance];
    [tabBaritemapperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:239/255.0 green:92/255.0 blue:83/255.0 alpha:1.0]} forState:UIControlStateSelected];
}
-(void)addChildViewControllers
{
    //添加首页控制器
    HomeViewController *home=[[HomeViewController alloc]init];
    [self addOneChildVC:home title:@"首页" imageName:@"home" selectedImageName:@"home_select"];
    
    
    //添加历史订单控制器
    HistoryOrdersViewController *history=[[HistoryOrdersViewController alloc]init];
    [self addOneChildVC:history title:@"历史订单" imageName:@"History" selectedImageName:@"history_select"];
    
    //添加设置控制器
    SettingViewController *setting=[[SettingViewController alloc]init];
    [self addOneChildVC:setting title:@"我的" imageName:@"My" selectedImageName:@"My_select"];
}
-(void)addOneChildVC:(UIViewController*)viewController title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
       //设置标题
       viewController.tabBarItem.title = title;
       
       //设置图标
       UIImage *image = [UIImage imageNamed:imageName];
       image = [image TF_scaleToFillSize:CGSizeMake(25, 25)];
       viewController.tabBarItem.image = image;
    
       UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
       selectedImage = [selectedImage TF_scaleToFillSize:CGSizeMake(25, 25)];
       
       selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       viewController.tabBarItem.selectedImage = selectedImage;
    
    
       NavigationController *nav=[[NavigationController alloc]initWithRootViewController:viewController];
       [self addChildViewController:nav];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
