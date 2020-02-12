//
//  NavigationController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/6.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation NavigationController
+(void)initialize
{
    UINavigationBar *navigationBarappearance=[UINavigationBar appearance];
    NSDictionary *textAttributes=nil;
    [navigationBarappearance setTintColor:[UIColor blackColor]];//返回按钮的箭头颜色
    textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightThin],NSForegroundColorAttributeName:[UIColor blackColor]};
    [navigationBarappearance setTitleTextAttributes:textAttributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate=self;
    
    // Do any additional setup after loading the view.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.childViewControllers.count>=1)//如果view控制器不是最早push进来的子控制器
    {
        viewController.hidesBottomBarWhenPushed=YES;
        UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        backButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        backButton.frame=CGRectMake(0, 0, 20, 20);
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    }
    [super pushViewController:viewController animated:YES];
}
-(void)back
{
    NSLog(@"点击了back按钮");
    [self popViewControllerAnimated:YES];
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //如果子控制器是1的时候如果手势有效的话，有个bug，下次push不进去
    //手势何时有效：当导航控制器的子控制器的个数 > 1有效
    return self.childViewControllers.count > 1;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    UIStatusBarStyle style = self.topViewController.preferredStatusBarStyle;
    return style;
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
