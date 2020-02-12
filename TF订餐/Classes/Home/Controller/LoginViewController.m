//
//  LoginViewController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/7.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "LoginViewController.h"
#import "Session.h"
#import "NSError+TF.h"
#import "NSString+TF.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "TabBarViewController.h"
//app端传输 key
#define BLMD5key   @"IAASIDuioponuYBIUNLIK123ikoIO"
// 加密 key
#define BLDESkey  @"ASDHOjhudhaos23asdihoh80"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *jobNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
-(void)setupView
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    //设置工号的左侧图标
    UIImageView *leftView_user=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftView_user.image=[UIImage imageNamed:@"user"];
    self.jobNumberTextField.leftView=leftView_user;
    leftView_user.contentMode=UIViewContentModeScaleAspectFit;
    self.jobNumberTextField.leftViewMode=UITextFieldViewModeAlways;
    
    
    //设置密码的左侧图标
    UIImageView *leftView_psw=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"psw"]];
    leftView_psw.frame=CGRectMake(0, 0, 20, 20);
    leftView_psw.contentMode=UIViewContentModeScaleAspectFit;
    
    self.pswTextField.leftView=leftView_psw;
    self.pswTextField.leftViewMode=UITextFieldViewModeAlways;
    self.loginBtn.layer.masksToBounds = YES;
}
- (IBAction)login:(id)sender {
   //获取用户输入工号、密码
    NSString *jobNumber = self.jobNumberTextField.text;
    NSString *psw = self.pswTextField.text;
    if ([jobNumber isEmpty]) {
           [SVProgressHUD showErrorWithStatus:@"请输入工号"];
           [SVProgressHUD dismissWithDelay:1];
           return;
       }else if([psw isEmpty]){
           [SVProgressHUD showErrorWithStatus:@"请输入密码"];
           [SVProgressHUD dismissWithDelay:1];
           return;
       }
    [self.view endEditing:YES];
    if (![jobNumber isEmpty] && ![psw isEmpty]) {
        [SVProgressHUD showWithStatus:@"登录中..."];
        [[Session sharedSession] userLogin:jobNumber pwd:psw result:^(NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:[error dl_errorInfo]];
            }else{
               [SVProgressHUD dismiss];
               [UIApplication sharedApplication].windows[0].rootViewController = [[TabBarViewController alloc] init];
            }
        }];
        
    }
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
