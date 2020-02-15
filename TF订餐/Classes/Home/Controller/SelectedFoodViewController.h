//
//  SelectedFoodViewController.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectedFoodViewController : BaseViewController
//providerId 点击cell选餐/查看已订菜式时要传给服务器
@property (nonatomic , copy) NSString *providerId;
//period 点击cell选餐/查看已订菜式时要传给服务器
@property (nonatomic , copy) NSString *period;
//用户是否已经点餐
@property (nonatomic , assign) Boolean isSelectFood;
//homeViewController传过来的数据
@property (strong , nonatomic) NSDictionary *json;

@end

NS_ASSUME_NONNULL_END
