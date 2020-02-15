//
//  HistoryDetailOrder.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/15.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryDetailOrder : NSObject
@property (nonatomic , copy) NSString *foodPicture;
//食物名
@property (nonatomic , copy) NSString *foodName;
//食物分类
@property (nonatomic , copy) NSString *foodSort;
//是否评价
@property (assign , nonatomic) Boolean status;
//食物ID
@property (nonatomic , copy) NSString *foodID;
//食物价格
@property (nonatomic , copy) NSString *foodPrice;

//初始化方法
-(instancetype)initHistoryDetailOrderWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
