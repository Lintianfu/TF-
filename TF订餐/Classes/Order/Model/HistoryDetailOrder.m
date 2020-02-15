//
//  HistoryDetailOrder.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/15.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "HistoryDetailOrder.h"

@implementation HistoryDetailOrder
-(instancetype)initHistoryDetailOrderWithDict:(NSDictionary *)dict
{
    self=[super init];
    if (self) {
          self.foodPicture = dict[@"pic"];
          self.foodName = dict[@"foodName"];
          self.foodSort = dict[@"sort"];
          self.foodID = [NSString stringWithFormat:@"%@",dict[@"id"]];
          self.foodPrice = dict[@"foodPrice"];
    }
    return self;
}
@end
