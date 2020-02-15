//
//  FoodList.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"
NS_ASSUME_NONNULL_BEGIN

@interface FoodList : NSObject
@property (copy, nonatomic)  NSString *msg;
//用户最少选择菜式
@property (copy, nonatomic) NSString *limit;
@property (copy, nonatomic) NSString *maxLimit;
//食物
@property (strong , nonatomic) NSMutableArray *foodsList;
//判断用户是否选择了菜式
@property (nonatomic,assign) BOOL foodIsSelected;
-(instancetype)initWithDict:(NSDictionary *)list foodSelected:(Boolean) isSelectedFood;
@end

NS_ASSUME_NONNULL_END
