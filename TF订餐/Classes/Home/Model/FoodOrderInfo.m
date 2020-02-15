//
//  FoodOrderInfo.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "FoodOrderInfo.h"

@implementation FoodOrderInfo
-(instancetype)initOrderAllDayWithDict:(NSDictionary *)dict
{
    self=[super init];
    if(self)
    {
        self.providerTime = [dict valueForKey:@"providerTime"];
        self.breakfast = [[dict valueForKey:@"breakfast"] integerValue];
        self.lunch = [[dict valueForKey:@"lunch"] integerValue];
        self.dinner = [[dict valueForKey:@"dinner"] integerValue];
        self.xiaoye = [[dict valueForKey:@"xiaoye"] integerValue];
        self.providerId = [NSString stringWithFormat:@"%@",[dict valueForKey:@"providerId"]];
    }
    return self;
}
@end
