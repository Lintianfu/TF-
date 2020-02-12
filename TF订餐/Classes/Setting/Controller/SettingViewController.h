//
//  SettingViewController.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/7.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "BaseViewController.h"
#import "UserDAO.h"
NS_ASSUME_NONNULL_BEGIN

@interface SettingViewController : BaseViewController
@property(nonatomic,strong)User *user;
@property(nonatomic,strong)UserDAO *dao;
-(NSString *)getCacheSize;
@end

NS_ASSUME_NONNULL_END
