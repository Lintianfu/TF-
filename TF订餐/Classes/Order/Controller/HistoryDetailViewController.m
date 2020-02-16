//
//  HistoryDetailViewController.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/16.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "HistoryDetailOrder.h"
#import "HistoryDetailViewCell.h"
#import "UserDAO.h"
#import "HttpClient.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface HistoryDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *historyDetailTableView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UITextView *commentText;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong , nonatomic) NSArray *historyOrdersArray;
@property(nonatomic,assign) double  money;
@end

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewTableview];
    [self rquestData];
    // Do any additional setup after loading the view from its nib.
}
-(NSArray *)historyOrdersArray
{
    if (_historyOrdersArray == nil) {
        _historyOrdersArray = [NSArray array];
    }
    return  _historyOrdersArray;
}
-(void)rquestData
{

    NSArray *orderArray = [self.json valueForKey:@"lists"];
    
    NSMutableArray *orders = [NSMutableArray array];
    for (NSDictionary *dict in orderArray) {

        HistoryDetailOrder *detailOrder = [[HistoryDetailOrder alloc]initHistoryDetailOrderWithDict:dict];
        [orders addObject:detailOrder];
        _money = _money + [detailOrder.foodPrice doubleValue];
    }
    self.historyOrdersArray = orders;
    //得到数据，刷新表格
    [self.historyDetailTableView reloadData];
}

- (IBAction)CommentClick:(id)sender {
    UserDAO *dao=[UserDAO sharedInstance];
    User *user=[dao findUser];
    NSString *OPT = @"9";
    NSString *token = user.token;
    NSString *record = self.unEvaluate;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"OPT":OPT,@"token":token,@"star":@"4",@"record":record,@"content":self.commentText.text}];
    //提交评论
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpClient sharedClient] postWithParams:param success:^(id json) {
        
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[[NSNotificationCenter defaultCenter] postNotificationName:DLHistoryOrdersRefreshNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } faliture:^(NSError *error) {
       // [DLProgressHUD showErrorWithStatus:[error dl_errorInfo] dismissTime:1.5];
    } autoShowError:NO];
}
-(void)initViewTableview
{
    self.historyDetailTableView.delegate=self;
    self.historyDetailTableView.dataSource=self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.historyOrdersArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建
    HistoryDetailViewCell *cell = [[HistoryDetailViewCell alloc]initWithTableView:tableView indexPath:indexPath];;
    //设置数据
    cell.historyDetailOrder = self.historyOrdersArray[indexPath.section];
    //返回
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.historyOrdersArray.count - 1) {
        return 240;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 44;
    else
        return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 )
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 44)];
        titleLabel.text = [NSString stringWithFormat:@"您点餐如下:(共%.2f元)",_money];
        titleLabel.font = [UIFont systemFontOfSize:17.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        return titleLabel;
    }else
        return nil;
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
