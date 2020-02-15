//
//  FoodList.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "FoodList.h"
@implementation FoodList
-(instancetype)initWithDict:(NSDictionary *)list foodSelected:(Boolean)isSelectedFood
{
    self=[super init];
    if(self)
    {
               //设置数据
               self.msg = [list valueForKey:@"msg"];
               self.limit = [NSString stringWithFormat:@"%@",[list valueForKey:@"limit"]];
               self.maxLimit = [NSString stringWithFormat:@"%@",[list valueForKey:@"maxLimit"]];
               NSArray *listArr = [list valueForKey:@"lists"];
               NSMutableArray *foodList = [NSMutableArray array];
               for (NSDictionary *dict in listArr) {
                   Food *food = [[Food alloc]initWithDict:dict foodSelected:isSelectedFood];
                   [foodList addObject:food];
               }
               self.foodsList = foodList;
               self.foodIsSelected = isSelectedFood;
    }
    return self;
}
@end
