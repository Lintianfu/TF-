//
//  HistoryOrder.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/15.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "HistoryOrder.h"

@implementation HistoryOrder
-(instancetype)initOrderAllDayWithDict:(NSDictionary *)dict
{
    self=[super init];
    if(self)
    {
       self.orderID = dict[@"id"];
       self.selTime = dict[@"selTime"];
       self.breadfast = [NSString stringWithFormat:@"%@",dict[@"breakfast"]];
       self.lunch = [NSString stringWithFormat:@"%@",dict[@"lunch"]];
       self.dinner = [NSString stringWithFormat:@"%@",dict[@"dinner"]];
       self.xiaoye = [NSString stringWithFormat:@"%@",dict[@"xiaoye"]];
    }
    return self;
}
@end
