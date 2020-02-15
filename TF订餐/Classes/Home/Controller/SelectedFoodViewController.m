//
//  SelectedFoodViewController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "SelectedFoodViewController.h"
#import "SelectFoodTableViewCell.h"
#import "CommitView.h"
#import "FoodList.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UserDAO.h"
#import "HttpClient.h"
#import "NSError+TF.h"
@interface SelectedFoodViewController ()<UITableViewDelegate,UITableViewDataSource,CommitViewDelegate,SelectFoodCellDelegate>
@property(nonatomic,strong)UITableView *selectFoodTableView;
@property (strong , nonatomic) FoodList *foodList;
@property (strong , nonatomic) CommitView *commitView;
@property (strong , nonatomic) NSMutableArray *foodUidsArray;
@property (strong , nonatomic) NSMutableArray *foodNameArray;
@property (strong , nonatomic) NSArray *foodsArray;
@property(nonatomic,assign) double  money;
@property(nonatomic,strong)User *user;

@end

@implementation SelectedFoodViewController
-(NSArray *)foodsArray//懒加载
{
    if(_foodsArray == nil)
    {
        _foodsArray = [NSArray array];
    }
    return _foodsArray;
}

-(NSMutableArray *)foodUidsArray
{
    if (!_foodUidsArray) {
        _foodUidsArray = [NSMutableArray array];
    }
    return  _foodUidsArray;
}

-(NSMutableArray *)foodNameArray
{
    if (!_foodNameArray) {
        _foodNameArray = [NSMutableArray array];
    }
    return  _foodNameArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self requestData];
    // Do any additional setup after loading the view.
}
-(void)setupSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectFoodTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.selectFoodTableView.dataSource = self;
    self.selectFoodTableView.delegate = self;
    [self.view addSubview:self.selectFoodTableView];
    if (!self.isSelectFood) {
        self.commitView = [[CommitView alloc] init];
        self.commitView.delegate = self;
        [self.view addSubview:self.commitView];
        [self.commitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.height.equalTo(@64);
        }];
    }
    UserDAO *dao=[UserDAO sharedInstance];
    self.user=[dao findUser];
}
-(void)requestData
{
    //加载数据
    FoodList *foodList = [[FoodList alloc]initWithDict:self.json foodSelected:self.isSelectFood];
    self.foodsArray = foodList.foodsList;
    self.foodList = foodList;
    [self.selectFoodTableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.foodsArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectFoodTableViewCell *cell = [[SelectFoodTableViewCell alloc]initWithTableView:tableView indexPath:indexPath selected:self.isSelectFood];
    cell.delegate = self;
    if (_isSelectFood) {
        cell.userInteractionEnabled = NO;
    }
    cell.food = _foodsArray[indexPath.section];
    //返回
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 44;
    else
        return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.foodsArray.count - 1) {
        return 60;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        if (self.isSelectFood) {
            titleLabel.text = @"您点餐如下";
        }else{
            titleLabel.text = [NSString stringWithFormat:@"请选择%@-%@个菜",self.foodList.limit,self.foodList.maxLimit];
        }
        titleLabel.font = [UIFont systemFontOfSize:17.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        return titleLabel;
    }else
        return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Food *food = self.foodsArray[indexPath.section];
    [self didSelectFood:food selectButton:nil];
}
-(void)didSelectFood:(Food *)food selectButton:(UIButton *)button{
    [self.foodUidsArray addObject:food.foodUid];
    [self.foodNameArray addObject:food.foodName];
    _money = _money + [[food foodPrice] doubleValue];
}
-(void)cancleSelectFood:(Food *)food{
    for (int i = 0; i < self.foodUidsArray.count; i ++) {
        if (self.foodUidsArray[i] == food.self.foodUid) {
            [self.foodUidsArray removeObject:food.self.foodUid];
            _money = _money - [food.foodPrice doubleValue];
        }
        if ([self.foodNameArray[i] isEqualToString:food.foodName]) {
            [self.foodNameArray removeObject:food.foodName];
        }
    }
}
-(void)didClickCommitButton:(UIButton *)commitBtn
{
    if (self.foodUidsArray.count == 0) {//未选择食物
        [SVProgressHUD showErrorWithStatus:@"请选择食物"];
        
    }else if(self.foodUidsArray.count < self.foodList.limit.integerValue){//未选满食物
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请至少选%@种食物",self.foodList.limit]];
        
    }else if(self.foodUidsArray.count > self.foodList.maxLimit.integerValue){//选多食物
         [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请至多选%@种食物",self.foodList.maxLimit]];
    }else{//选满食物
        
        NSString *title = @"您的点餐如下，请确认";
        NSString *subTitle = @"";
        for (int index = 0;index < self.foodNameArray.count; index ++) {
            subTitle = [subTitle stringByAppendingString:[NSString stringWithFormat:@"%d.%@\n",index+1,self.foodNameArray[index]]];
        }
        if (subTitle.length >= 2) {
            subTitle = [subTitle substringToIndex:subTitle.length -1];
        }
        subTitle = [subTitle stringByAppendingString:[NSString stringWithFormat:@"\n 总金额:%.2f元", _money]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:subTitle preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        UIAlertAction *enter = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showWithStatus:@"点餐中..."];
            NSString *ids = @"[";
            for (int i = 0; i < self.foodUidsArray.count; i ++) {
                ids = [ids stringByAppendingString:self.foodUidsArray[i]];
                if (i != self.foodUidsArray.count - 1) {
                    ids = [ids stringByAppendingString:@","];
                }
            }
            ids = [ids stringByAppendingString:@"]"];
            
            NSString *token = self.user.token;
            NSString *OPT = @"4";
            NSString *period = self.period;
            NSString *providerId = self.providerId;
            NSString *phone =@"IOS-iphone-8";
            NSDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"token":token,
                                                                                  @"OPT":OPT,
                                                                                  @"period":period,
                                                                                  @"providerId":providerId,
                                                                                  @"ids":ids,
                                                                                  @"phone":phone}];
            [[HttpClient sharedClient] postWithParams:param success:^(id json) {
                
                [SVProgressHUD showWithStatus:@"点餐成功"];
                //通知home控制器刷新界面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeDidRefreshNotification" object:nil];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } faliture:^(NSError *error) {
                [SVProgressHUD showWithStatus:[error dl_errorInfo]];
            } autoShowError:YES];
        }];
        
        [alert addAction:cancle];
        [alert addAction:enter];
        [self presentViewController:alert animated:YES completion:nil];

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
