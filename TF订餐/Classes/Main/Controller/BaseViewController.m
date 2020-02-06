//
//  BaseViewController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/6.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "BaseViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
@interface BaseViewController ()
@property(nonatomic,strong)IQKeyboardReturnKeyHandler *returnKeyHandler;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.returnKeyHandler=[[IQKeyboardReturnKeyHandler alloc]initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType=UIReturnKeyDone;
    
    // Do any additional setup after loading the view.
}
-(void)dismissVC
{
     [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    self.returnKeyHandler = nil;
    NSLog(@"%@--dealloc",[self class]);
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
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
