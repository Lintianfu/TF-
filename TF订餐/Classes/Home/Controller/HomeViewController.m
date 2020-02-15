//
//  HomeViewController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/7.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "HomeViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/SDWebImage.h>
#import "HttpClient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FoodOrderInfo.h"
#import "NSDate+TF.h"
#import "NSError+TF.h"
#import "SelectedFoodViewController.h"
#define cellHeight 44.0f
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *hometableView;
@property (strong , nonatomic) NSArray *ordersArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;//时间格式
@property (weak , nonatomic) UIView *footerView;
@property (weak , nonatomic) UIImageView *iconImageView;//用户头像
@end

@implementation HomeViewController
-(NSDateFormatter *)dateFormatter{ //懒加载时间格式
    if (!_dateFormatter) {
         NSLocale * locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        _dateFormatter = [[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat=@"yyyy-MM-dd";
       [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        _dateFormatter.locale = locale;
    }
    return _dateFormatter;
}
-(NSArray *)ordersArray
{
    if(_ordersArray==nil)
    {
        _ordersArray=[NSArray array];
    }
    return _ordersArray;
}
-(UITableView *)hometableView
{
    if(_hometableView==nil)
    {
        _hometableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _hometableView.dataSource = self;
        _hometableView.delegate = self;
        [_hometableView setSeparatorColor:[UIColor colorWithRed:245/255 green:245/255 blue:245/255 alpha:0.1]];
        [_hometableView setSeparatorInset:UIEdgeInsetsZero];
    }
    return _hometableView;
}
-(UIView *)footerView{
    if (_footerView == nil) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 80.0)];
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:footerView.bounds];
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.textColor = [UIColor grayColor];
        footerLabel.font = [UIFont systemFontOfSize:14.0];
        footerLabel.text = @"-- 没有更多可预约 --";
        [footerView addSubview:footerLabel];
        _footerView = footerView;
        return _footerView;
    }
    return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"this is home");
    [self setupView];
    [self requestData];
    [self setRefreshHeader];
    [self initWithNotification];
    // Do any additional setup after loading the view.
}
-(void)initWithNotification
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"HomeDidRefreshNotification" object:nil];
}

-(void)setupView
{
    UserDAO *dao=[UserDAO sharedInstance];
    self.user=[dao findUser];
    self.navigationItem.title=[NSString stringWithFormat:@"%@,您好",self.user.username];
    
    CGFloat iconHeight  = 38;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iconHeight, iconHeight)];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconHeight, iconHeight)];
    iconImageView.layer.cornerRadius = iconHeight * 0.5;
    iconImageView.layer.masksToBounds = YES;
    [iconImageView setContentMode:UIViewContentModeScaleAspectFill];
    [leftView addSubview:iconImageView];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftView];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar]placeholderImage:[UIImage imageNamed:@"userIcon"]];
    
    [self.view addSubview:self.hometableView];
}
-(void)setRefreshHeader{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [header setTitle:@"释放以刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.hometableView.mj_header = header;
}
-(void)requestData
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"token":self.user.token,@"OPT":@"2"}];
    [[HttpClient sharedClient]postWithParams:param success:^(id  _Nonnull responseObj) {
        [SVProgressHUD dismiss];
        NSArray *arr = [responseObj valueForKey:@"entities"];
        NSMutableArray *orderArr = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            FoodOrderInfo *allday=[[FoodOrderInfo alloc]initOrderAllDayWithDict:dict];
            [orderArr addObject:allday];
    }
        self.ordersArray=orderArr;
        [self.hometableView reloadData];
        [self.hometableView.mj_header endRefreshing];
    } faliture:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [SVProgressHUD dismissWithDelay:1];
        [self.hometableView.mj_header endRefreshing];
    } autoShowError:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.ordersArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const homeCellID = @"TimeCell";//时间cell
    NSString *const homeDetailCellID = @"HomeDetailCell";//时段cell_ID
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {//时间cell
        cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeCellID];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.textLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cellHeight);
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{//时段cell
        cell = [tableView dequeueReusableCellWithIdentifier:homeDetailCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:homeDetailCellID];
            //设置cell样式
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //设置字体
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
    }
     FoodOrderInfo *order = self.ordersArray[indexPath.section]; 
      if (indexPath.row == 0) {//设置头部cell数据(时间)
    NSString *providerTime = [order.providerTime substringWithRange:NSMakeRange(0, 10)];
    NSDate *providerDate = [self.dateFormatter dateFromString:providerTime];
    cell.textLabel.text =[NSDate compareDate:providerDate];
      }
          else{//设置子项cell数据
              cell.detailTextLabel.text = @"未订餐";
              cell.detailTextLabel.textColor = [UIColor grayColor];
              switch (indexPath.row) {
                  case 1:
                      cell.imageView.image = [UIImage imageNamed:@"breadfast"];
                      cell.textLabel.text = @"早餐";
                      if (order.breakfast){
                          cell.detailTextLabel.text = @"已订餐";
                          cell.detailTextLabel.textColor = [UIColor grayColor];
                      }
                      break;
                  case 2:
                      cell.imageView.image = [UIImage imageNamed:@"lunch"];
                      cell.textLabel.text = @"午餐";
                      if (order.lunch){
                          cell.detailTextLabel.text = @"已订餐";
                          cell.detailTextLabel.textColor = [UIColor grayColor];
                      }
                      break;
                  case 3:
                      cell.imageView.image = [UIImage imageNamed:@"dinner"];
                      cell.textLabel.text = @"晚餐";
                      if (order.dinner){
                          cell.detailTextLabel.text = @"已订餐";
                          cell.detailTextLabel.textColor = [UIColor grayColor];
                      }
                      break;
                  case 4:
                      cell.imageView.image = [UIImage imageNamed:@"NightSnack"];
                      cell.textLabel.text = @"宵夜";
                      if (order.xiaoye){
                          cell.detailTextLabel.text = @"已订餐";
                          cell.detailTextLabel.textColor = [UIColor grayColor];
                      }
                      break;
                  default:
                      break;
              }
              
          }
          return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     FoodOrderInfo *order = self.ordersArray[indexPath.section];
     NSString *token = self.user.token;
     NSString *period = [NSString stringWithFormat:@"%ld",indexPath.row-1];
     NSString *providerId = [NSString stringWithFormat:@"%@",order.providerId];
     NSString *OPT = @"3";
     NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"token":token,@"OPT":OPT,@"period":period,@"providerId":providerId}];
     [SVProgressHUD showWithStatus:@"加载中..."];
     [[HttpClient sharedClient] postWithParams:param success:^(id json) {
            [SVProgressHUD dismiss];
            NSString *providerTime = [order.providerTime substringWithRange:NSMakeRange(0, 10)];
            NSDate *providerDate = [self.dateFormatter dateFromString:providerTime];
            NSString *pushTitle;
            switch (indexPath.row) {
                case 1:
                    pushTitle = [NSString stringWithFormat:@"%@:早餐",[NSDate compareDate:providerDate]];
                    break;
                case 2:
                     pushTitle = [NSString stringWithFormat:@"%@:午餐",[NSDate compareDate:providerDate]];
                    break;
                case 3:
                     pushTitle = [NSString stringWithFormat:@"%@:晚餐",[NSDate compareDate:providerDate]];
                    break;
                case 4:
                     pushTitle = [NSString stringWithFormat:@"%@:宵夜",[NSDate compareDate:providerDate]];
                    break;
                default:
                    break;
            }
            //创建控制器并为属性赋值
            SelectedFoodViewController *selectFoodsVC = [[SelectedFoodViewController alloc] init];
            selectFoodsVC.title = pushTitle;
            selectFoodsVC.json = json;
            selectFoodsVC.period = [NSString stringWithFormat:@"%ld",indexPath.row - 1];
            selectFoodsVC.providerId = order.providerId;
            //设置用户点餐状态
            switch (indexPath.row) {
                case 1:
                    selectFoodsVC.isSelectFood = order.breakfast;
                    break;
                case 2:
                    selectFoodsVC.isSelectFood = order.lunch;
                    break;
                case 3:
                    selectFoodsVC.isSelectFood = order.dinner;
                    break;
                case 4:
                    selectFoodsVC.isSelectFood = order.xiaoye;
                    break;
                default:
                    break;
            }
            [self.navigationController pushViewController:selectFoodsVC animated:YES];
            
        } faliture:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error dl_errorInfo]];
            [SVProgressHUD dismissWithDelay:1];
        } autoShowError:YES];
    }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView* )tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.self.ordersArray.count - 1) {
        return 100;
    }
    return 0.1;
}
//返回footerView
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == self.ordersArray.count - 1) {
        
        return  self.footerView;
    }
    return nil;
}

@end
