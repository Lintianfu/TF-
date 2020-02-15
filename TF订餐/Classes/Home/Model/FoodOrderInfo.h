//
//  FoodOrderInfo.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoodOrderInfo : NSObject
//订餐日期
@property (nonatomic , copy) NSString *providerTime;

//providerId 点击cell选餐/查看已订菜式时要传给服务器(确定日期)
@property (nonatomic , copy) NSString *providerId;

//早中晚餐是否订餐
@property (assign , nonatomic) Boolean breakfast;
@property (assign , nonatomic) Boolean lunch;
@property (assign , nonatomic) Boolean dinner;
@property (assign , nonatomic) Boolean xiaoye;
-(instancetype)initOrderAllDayWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
