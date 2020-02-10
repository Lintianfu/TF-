//
//  SettingViewController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/7.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "Session.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(0, 0, 100, 30);
    [button addTarget:self action:@selector(log_out) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];*/
    NSLog(@"this is setting");
    // Do any additional setup after loading the view.
}
-(void)log_out
{
    UIAlertController *alterController=[UIAlertController alertControllerWithTitle:@"确认退出?" message:@"即将进行退出登录操作" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[Session sharedSession] userLogout:[Session sharedSession].user];
       [UIApplication sharedApplication].windows[0].rootViewController = [[LoginViewController alloc] init];
        
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alterController addAction:sure];
    [alterController addAction:cancel];
    [self presentViewController:alterController animated:YES completion:nil];
    
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
