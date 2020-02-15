//
//  HistoryOrdersViewController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/7.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "HistoryOrdersViewController.h"
#import "HistoryOrderSearchViewController.h"
#import "HistoryDetailViewController.h"
#import "HttpClient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "NSDate+TF.h"
#import "NSError+TF.h"
@interface HistoryOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak , nonatomic) UITableView *historyOrdersTableView;
@property (strong , nonatomic) NSMutableArray *ordersArray;
@property (assign , nonatomic) NSInteger currentPage;
@property (assign,nonatomic) Boolean isLoading;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation HistoryOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self requestDataWithHUD];
    [self setRefreshHeaderAndFooter];
    // Do any additional setup after loading the view.
}
-(NSDateFormatter *)dateFormatter{
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
    //获取订单数据
    if (_ordersArray == nil) {
        _ordersArray = [NSMutableArray array];
    }
    return  _ordersArray;
}
-(void)setupSubViews
{
    UserDAO *dao=[UserDAO sharedInstance];
    self.user=[dao findUser];
    //2.设置导航栏title,leftBarButtonItem
    UILabel *label =[[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"历史订单";
    self.navigationItem.title = label.text;
    
    UITableView *historyOrdersTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    historyOrdersTableView.dataSource = self;
    historyOrdersTableView.delegate = self;
    //设置tableView分割线占据屏幕的宽度
    [historyOrdersTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [historyOrdersTableView setSeparatorColor:[UIColor colorWithRed:245/255 green:245/255 blue:245/255 alpha:0.1]];
    self.historyOrdersTableView = historyOrdersTableView;
    [self.view addSubview:historyOrdersTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history_search"] style:UIBarButtonItemStyleDone target:self action:@selector(gotoSearch)];
}
-(void)RequestData:(BOOL)refresh
{
    //获取数据
    NSString *token = self.user.token;
    NSString *OPT = @"6";
    NSString *pageNo = [NSString stringWithFormat:@"%zd",_currentPage];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"token":token,@"OPT":OPT,@"pageNo":pageNo}];
    [[HttpClient sharedClient] postWithParams:param success:^(id json) {
        //获取json数据
        NSDictionary *orderJson = [json valueForKey:@"pagination"];
        NSArray *orderArray = [orderJson valueForKey:@"list"];
        NSInteger totalCount = [[orderJson valueForKey:@"totalCount"] integerValue];
        
        NSMutableArray *orders = [NSMutableArray array];
        for (NSDictionary *dict in orderArray) {
            HistoryOrder *order = [[HistoryOrder alloc]initOrderAllDayWithDict:dict];
            [orders addObject:order];
        }
        if (refresh) {
            self.ordersArray = orders;
        }else{
            [self.ordersArray addObjectsFromArray:orders];
        }
        if (self.ordersArray.count < totalCount) {
            self.historyOrdersTableView.mj_footer.hidden = NO;
        }else{
            self.historyOrdersTableView.mj_footer.hidden = YES;
        }
        //得到数据，刷新表格
        [self.historyOrdersTableView reloadData];
        
        [self.historyOrdersTableView.mj_header endRefreshing];
        [self.historyOrdersTableView.mj_footer endRefreshing];
        
    } faliture:^(NSError *error) {
        self->_currentPage = self->_currentPage - 1;
        [self.historyOrdersTableView.mj_header endRefreshing];
        [self.historyOrdersTableView.mj_footer endRefreshing];
    } autoShowError:NO];
}
-(void)requestDataWithHUD//下拉刷新调用此方法
{
    _currentPage = 1;
    [self RequestData:YES];
}

-(void)loadMoreData//上拉加载
{
    _currentPage = _currentPage + 1;
    [self RequestData:false];
}
-(void)setRefreshHeaderAndFooter{
    //刷新头部
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDataWithHUD)];
    [header setTitle:@"释放以刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.historyOrdersTableView.mj_header = header;
    
    //刷新尾部
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    self.historyOrdersTableView.mj_footer = footer;
    self.historyOrdersTableView.mj_footer.hidden = YES;
}
-(void)gotoSearch{
    HistoryOrderSearchViewController *vc = [[HistoryOrderSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableView DataSource
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
    //设置头部cell_ID
    NSString *const historyHeaderCell_ID = @"DLHistoryHeaderCell";
    //设置子项cell_ID
    NSString *const historyItemCell_ID = @"DLHistoryItemCell";
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {//头部cell
        cell = [tableView dequeueReusableCellWithIdentifier:historyHeaderCell_ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyHeaderCell_ID];
        }
        //设置cell的显示方式，将cell的textLabel填充cell
        cell.textLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.userInteractionEnabled = NO;//设置为不可点击
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{//子项cell
        cell = [tableView dequeueReusableCellWithIdentifier:historyItemCell_ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:historyItemCell_ID];
        }
        //设置cell样式
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可点击
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    HistoryOrder *order = self.ordersArray[indexPath.section];
    cell.detailTextLabel.text = @"未订餐";
    cell.detailTextLabel.textColor = [UIColor grayColor];
    //获取数据
    switch (indexPath.row) {
        case 0:
        {
            NSString *selTime = [order.selTime substringWithRange:NSMakeRange(0, 10)];
            NSDate *selDate = [self.dateFormatter dateFromString:selTime];
            cell.textLabel.text =[NSDate compareDate:selDate];
        }
            break;
        case 1://早餐
            cell.imageView.image = [UIImage imageNamed:@"breadfast"];
            switch (order.breadfast.integerValue) {
                case 1:
                    cell.detailTextLabel.text = @"待消费";
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255 green:184/255 blue:139/255 alpha:1];
                    break;
                case 2:
                    cell.detailTextLabel.text = @"待评价";
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255 green:184/255 blue:139/255 alpha:1];
                    break;
                case 3:
                    cell.detailTextLabel.text = @"已评价";
                   cell.detailTextLabel.textColor = [UIColor colorWithRed:239/255 green:92/255 blue:83/255 alpha:1];
                    break;
                default:
                    break;
            }
            cell.textLabel.text = @"早餐";
            break;
        case 2://午餐
            cell.imageView.image = [UIImage imageNamed:@"lunch"];
            switch (order.lunch.integerValue) {
                case 1:
                    cell.detailTextLabel.text = @"待消费";
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255 green:184/255 blue:139/255 alpha:1];
                    break;
                case 2:
                    cell.detailTextLabel.text = @"待评价";
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255 green:184/255 blue:139/255 alpha:1];
                    break;
                case 3:
                    cell.detailTextLabel.text = @"已评价";
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:239/255 green:92/255 blue:83/255 alpha:1];
                    break;
                default:
                    break;
            }
            cell.textLabel.text = @"午餐";
            break;
        case 3://晚餐
            cell.imageView.image = [UIImage imageNamed:@"dinner"];
            switch (order.dinner.integerValue) {
                case 1:
                    cell.detailTextLabel.text = @"待消费";
                   cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255 green:184/255 blue:139/255 alpha:1];
                    break;
                case 2:
                    cell.detailTextLabel.text = @"待评价";
                   cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255 green:184/255 blue:139/255 alpha:1];
                    break;
                case 3:
                    cell.detailTextLabel.text = @"已评价";
                   cell.detailTextLabel.textColor = [UIColor colorWithRed:239/255 green:92/255 blue:83/255 alpha:1];
                    break;
                default:
                    break;
            }
            cell.textLabel.text = @"晚餐";
            break;
            
        case 4://宵夜
            cell.imageView.image = [UIImage imageNamed:@"NightSnack"];
            switch (order.xiaoye.integerValue) {
                case 1:
                    cell.detailTextLabel.text = @"待消费";
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255 green:184/255 blue:139/255 alpha:1];
                    break;
                case 2:
                    cell.detailTextLabel.text = @"待评价";
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255 green:184/255 blue:139/255 alpha:1];
                    break;
                case 3:
                    cell.detailTextLabel.text = @"已评价";
                   cell.detailTextLabel.textColor = [UIColor colorWithRed:239/255 green:92/255 blue:83/255 alpha:1];
                    break;
                default:
                    break;
            }
            cell.textLabel.text = @"宵夜";
            break;
        default:
            break;
    }

    return cell;
}
#pragma mark - UITableView Delegate
/**
 用户点击cell处理在此方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isLoading) return;
    HistoryOrder *order = self.ordersArray[indexPath.section];
    NSString *time = [order.selTime substringWithRange:NSMakeRange(0, 10)];
    NSString *detailTitle;
    NSString *mealStatus = nil;//判断用户用餐状态：已订餐/已消费
    switch (indexPath.row) {
        case 1:
            mealStatus = order.breadfast;
            detailTitle = [NSString stringWithFormat:@"%@(早餐)",time];
            break;
        case 2:
            mealStatus = order.lunch;
             detailTitle = [NSString stringWithFormat:@"%@(午餐)",time];
            break;
        case 3:
            mealStatus = order.dinner;
             detailTitle = [NSString stringWithFormat:@"%@(晚餐)",time];
            break;
        case 4:
            mealStatus = order.xiaoye;
            detailTitle = [NSString stringWithFormat:@"%@(宵夜)",time];
        default:
            break;
    }
    
    if (mealStatus.integerValue != 0) {
        
        
        NSString *period = [NSString stringWithFormat:@"%ld",indexPath.row - 1];
        NSString *token = self.user.token;
        NSString *OPT = @"7";
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"token":token,@"OPT":OPT,@"period":period,@"time":time}];
        [SVProgressHUD showWithStatus:@"加载中..."];
        _isLoading = YES;
        [[HttpClient sharedClient] postWithParams:param success:^(id json) {
           HistoryDetailViewController *detailViewController = [[HistoryDetailViewController alloc] init];
            detailViewController.navigationItem.title = detailTitle;
            detailViewController.json = json;
            detailViewController.period = [NSString stringWithFormat:@"%ld",indexPath.row - 1];
            detailViewController.time = [order.selTime substringWithRange:NSMakeRange(0, 10)];
            detailViewController.isEvaluate = [NSString stringWithFormat:@"%@",[json valueForKey:@"isEvaluate"]];//获取评价所用
            detailViewController.unEvaluate = [NSString stringWithFormat:@"%@",[json valueForKey:@"unEvaluate"]];//发表评价所用
            detailViewController.status = [NSString stringWithFormat:@"%@",[json valueForKey:@"status"]]; //是否消费
            detailViewController.evaluate = [NSString stringWithFormat:@"%@",[json valueForKey:@"evaluate"]];//是否评价
            [self.navigationController pushViewController:detailViewController animated:YES];
            self->_isLoading = NO;
        } faliture:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error dl_errorInfo]];
            self->_isLoading = NO;
            NSLog(@"%@",error);
        } autoShowError:NO];
    }else{
        [SVProgressHUD showWithStatus:@"在该时段您没有订餐"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView* )tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.self.ordersArray.count - 1) {
        return 20;
    }
    return 1;
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
