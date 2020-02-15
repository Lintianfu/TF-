//
//  HistoryOrdersViewController.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/7.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "BaseViewController.h"
#import "UserDAO.h"
#import "HistoryOrder.h"
#import "HistoryDetailOrder.h"
NS_ASSUME_NONNULL_BEGIN

@interface HistoryOrdersViewController : BaseViewController
@property(nonatomic,strong)User *user;
@end

NS_ASSUME_NONNULL_END
