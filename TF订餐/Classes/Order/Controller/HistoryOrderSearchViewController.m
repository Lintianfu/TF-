//
//  HistoryOrderSearchViewController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/15.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "HistoryOrderSearchViewController.h"
#import <ActionSheetDatePicker.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UserDAO.h"
#import "HttpClient.h"
@interface HistoryOrderSearchViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *findBtn;
@property (weak, nonatomic) IBOutlet UILabel *breakfastLabel;
@property (weak, nonatomic) IBOutlet UILabel *launchLabel;
@property (weak, nonatomic) IBOutlet UILabel *dinnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *snakeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totaLabel;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation HistoryOrderSearchViewController
-(NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetupView];
    // Do any additional setup after loading the view from its nib.
}
-(void)SetupView
{
       self.navigationItem.title = @"历史统计查询";
       self.startTextField.delegate = self;
       self.endTextField.delegate = self;
       NSDate *now = [NSDate new];
       self.startDate = now;
       self.endDate = now;
       UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startClick)];
       [self.startTextField addGestureRecognizer:tapRecognizer];
       
       UITapGestureRecognizer *endTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endClick)];
       [self.endTextField addGestureRecognizer:endTapRecognizer];
}
-(void)startClick{
    [ActionSheetDatePicker showPickerWithTitle:@"请选择起始时间" datePickerMode:UIDatePickerModeDate selectedDate:self.startDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
        self.startDate = selectedDate;
        self.startTextField.text = [self.formatter stringFromDate:selectedDate];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.view];
}
-(void)endClick{
    [ActionSheetDatePicker showPickerWithTitle:@"请选择终止时间" datePickerMode:UIDatePickerModeDate selectedDate:self.endDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
        self.endDate = selectedDate;
        self.endTextField.text = [self.formatter stringFromDate:selectedDate];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
    } origin:self.view];
}
- (IBAction)resetBtnClick:(id)sender {
    self.startTextField.text = nil;
    self.endTextField.text = nil;
}
- (IBAction)findBtnClick:(id)sender {
    NSString *startTime = self.startTextField.text;
    NSString *endTime = self.endTextField.text;
    if (startTime.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择起始时间"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    if (endTime.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择终止时间"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    NSDate *start = [_formatter dateFromString:startTime];
    NSDate *end = [_formatter dateFromString:endTime];
    if ([start compare:end] == NSOrderedDescending) {
         [SVProgressHUD showErrorWithStatus:@"时间先后顺序错误"];
         [SVProgressHUD dismissWithDelay:1];
        return;
    }
    UserDAO *dao=[UserDAO sharedInstance];
    User *user=[dao findUser];
    NSString *token =user.token;
    NSMutableDictionary *param =  [NSMutableDictionary dictionaryWithDictionary:@{ @"token":token,@"OPT":@"12", @"startTime":startTime,@"endTime":endTime}];
    [[HttpClient sharedClient] postWithParams:param success:^(id responseObj) {
        NSArray *info = responseObj[@"info"];
        if ([info isKindOfClass:[NSNull class]]) {
        }else{
            NSDictionary *res = info[0];
            self.breakfastLabel.text = [NSString stringWithFormat:@"%@次",res[@"breakfast"]];
            self.launchLabel.text = [NSString stringWithFormat:@"%@次",res[@"lunch"]];
            self.dinnerLabel.text = [NSString stringWithFormat:@"%@次",res[@"dinner"]];
            self.snakeLabel.text = [NSString stringWithFormat:@"%@次",res[@"xiaoye"]];
            self.totaLabel.text = [NSString stringWithFormat:@"共计:%.2f元",[res[@"sumPrice"] floatValue]];
        }
    } faliture:^(NSError *error) {
        NSLog(@"%@",error);
    } autoShowError:NO ];
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
