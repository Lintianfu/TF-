//
//  HistoryOrder.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/15.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryOrder : NSObject
//点餐日的ID
@property (nonatomic , copy) NSString * orderID;
//点餐日期
@property (copy , nonatomic) NSString * selTime;
//早中晚餐点餐状态-- 0：未点餐  1：已点餐  2：已消费
@property (strong , nonatomic) NSString * breadfast;
@property (strong , nonatomic) NSString * lunch;
@property (strong , nonatomic) NSString * dinner;
@property (strong , nonatomic) NSString * xiaoye;
-(instancetype)initOrderAllDayWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
