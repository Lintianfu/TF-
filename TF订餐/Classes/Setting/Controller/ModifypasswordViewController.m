//
//  ModifypasswordViewController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/12.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "ModifypasswordViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Session.h"
#import "NSError+TF.h"
@interface ModifypasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *origin_password;
@property (weak, nonatomic) IBOutlet UITextField *password_new;
@property (weak, nonatomic) IBOutlet UITextField *password_sure;
@property (weak, nonatomic) IBOutlet UIButton *modifybtn;

@end

@implementation ModifypasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}
-(void)setupView
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"修改密码";
    //设置原始密码的左侧图标
    UIImageView *leftView_origin=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftView_origin.image=[UIImage imageNamed:@"psw"];
    self.origin_password.leftView=leftView_origin;
    leftView_origin.contentMode=UIViewContentModeScaleAspectFit;
    self.origin_password.leftViewMode=UITextFieldViewModeAlways;
    
    
    //设置新密码的左侧图标
    UIImageView *leftView_new_psw=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"psw"]];
    leftView_new_psw.frame=CGRectMake(0, 0, 20, 20);
    leftView_new_psw.contentMode=UIViewContentModeScaleAspectFit;
    self.password_new.leftView=leftView_new_psw;
    self.password_new.leftViewMode=UITextFieldViewModeAlways;
    
    //设置确认新密码的左侧图标
    UIImageView *leftView_sure_psw=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"psw"]];
    leftView_sure_psw.frame=CGRectMake(0, 0, 20, 20);
    leftView_sure_psw.contentMode=UIViewContentModeScaleAspectFit;
    self.password_sure.leftView=leftView_sure_psw;
    self.password_sure.leftViewMode=UITextFieldViewModeAlways;
    self.modifybtn.layer.masksToBounds = YES;
}
- (IBAction)modifyPassword:(id)sender {
    NSString *originPwd = self.origin_password.text;
    NSString *newPwd = self.password_new.text;
    NSString *newPwdAgain = self.password_sure.text;
    
    if (originPwd.length == 0) {
        [self showProgressHUB:@"请输入原密码"];
    }else if(newPwd.length == 0){
         [self showProgressHUB:@"请输入新密码"];
    }else if (newPwdAgain.length == 0){
         [self showProgressHUB:@"请确认新密码"];
    }else if(![newPwd isEqualToString:newPwdAgain]){
         [self showProgressHUB:@"新旧密码输入不一致"];
    }else{
        
        [SVProgressHUD showWithStatus:@"修改中..."];
        
        [[Session sharedSession] modifyPasswordWithOriginalPsw:originPwd newPsw:newPwd newPswAgain:newPwdAgain result:^(NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:[error dl_errorInfo]];
            }else{
                [SVProgressHUD showWithStatus:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];//返回到上层控制器
            }
        }];
         
    }
}
-(void)showProgressHUB:(NSString *)content
{
    [SVProgressHUD showErrorWithStatus:content];
    [SVProgressHUD dismissWithDelay:1];
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
