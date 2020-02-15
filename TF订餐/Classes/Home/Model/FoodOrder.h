//
//  FoodOrder.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoodOrder : NSObject
//食物照片名
@property (copy , nonatomic) NSString *img;
//时段
@property (copy , nonatomic) NSString *time;
//所选食物
@property (strong , nonatomic) NSArray *foods;
-(instancetype)initOrderWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
