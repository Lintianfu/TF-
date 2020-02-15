//
//  Food.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Food : NSObject
@property (copy, nonatomic)  NSString *foodName;  //食物名称
@property (copy, nonatomic) NSString *foodID;  //食物id
@property (copy , nonatomic) NSString *picture; //食物图片
@property (nonatomic , copy) NSString *sort;    //食物类别
@property (nonatomic, assign) BOOL foodIsSelected;  //判断是否选择了食物
@property (nonatomic , copy) NSString *foodUid;  //食物的uid
@property (nonatomic , copy) NSString *foodPrice; //食物价格
-(instancetype)initWithDict:(NSDictionary *)dict foodSelected:(Boolean) isSelectedFood;//构造方法
@end

NS_ASSUME_NONNULL_END
