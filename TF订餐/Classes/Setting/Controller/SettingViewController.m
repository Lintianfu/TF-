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
#import <SDWebImage/SDWebImage.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "ModifypasswordViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *settingTableView;
@property(copy,nonatomic)NSString *totalCache;
@property(copy,nonatomic)NSString *APP_version;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    [self initWithData];
    
    NSLog(@"this is setting %@",self.totalCache);
    
    // Do any additional setup after loading the view.
}
-(UITableView *)settingTableView//懒加载
{
    if(_settingTableView==nil)
    {
        _settingTableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _settingTableView.delegate=self;
        _settingTableView.dataSource=self;
    }
    return _settingTableView;
}
-(void)initWithView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    [self.view addSubview:self.settingTableView];
}

-(void)initWithData
{
    self.dao=[UserDAO sharedInstance];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.APP_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.totalCache=[self getCacheSize];
    self.user=[self.dao findUser];
    
}


#pragma mark - UITableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"姓名";
                    cell.detailTextLabel.text=self.user.username;
                    break;
                case 1:
                    cell.textLabel.text=@"工号";
                    cell.detailTextLabel.text=self.user.uid;
                    break;
                case 2:
                    cell.textLabel.text=@"修改密码";
                    break;
                case 3:
                    cell.textLabel.text=@"清除缓存";
                    cell.detailTextLabel.text=self.totalCache;
                    break;
                case 4:
                    cell.textLabel.text=@"当前版本";
                    cell.detailTextLabel.text=self.APP_version;
                    break;
                default:
                    break;
            }
            break;
        default:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"退出登录";
                    cell.textLabel.textColor=[UIColor redColor];
                    break;
                default:
                    break;
            }
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell选择事件
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 2://修改密码
                    [self.navigationController pushViewController:[[ModifypasswordViewController alloc]init] animated:YES];
                    break;
                case 3://清除缓存
                    [self clearCache:indexPath];
                    self.totalCache=[self getCacheSize];
                    [self.settingTableView reloadData];
                default:
                    break;
            }
            break;
        
        case 1:
            switch (indexPath.row) {
                case 0:
                    NSLog(@"退出登录");
                    [self log_out];
                    break;
                default:
                    break;
            }
            
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(NSString *)getCacheSize
{
        NSInteger totleSize = [[SDImageCache sharedImageCache] totalDiskSize];
           //将文件夹大小转换为 M/KB/B
        NSString *cacheSizeStr = @"";
           if (totleSize > 1000 * 1000)
           {
               cacheSizeStr = [NSString stringWithFormat:@"%.1fM",totleSize / 1000.0f /1000.0f];
           }else if (totleSize > 1000)
           {
               cacheSizeStr = [NSString stringWithFormat:@"%.1fKB",totleSize / 1000.0f ];
               
           }else
           {
               cacheSizeStr = [NSString stringWithFormat:@"%.1fB",totleSize / 1.0f];
           }
          return cacheSizeStr;
}
//清除缓存
-(void)clearCache:(NSIndexPath *)indexPath
{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [SVProgressHUD showWithStatus:@"正在清除"];
    }];
    [SVProgressHUD dismissWithDelay:2];
    
}

-(void)log_out
{
    UIAlertController *alterController=[UIAlertController alertControllerWithTitle:@"确认退出?" message:@"即将进行退出登录操作" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[Session sharedSession] userLogout:self.user];
       [UIApplication sharedApplication].windows[0].rootViewController = [[LoginViewController alloc] init];
        
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alterController addAction:sure];
    [alterController addAction:cancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alterController animated: YES completion: nil];
    });
    
}


@end
