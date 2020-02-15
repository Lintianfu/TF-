//
//  HistoryDetailViewController.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/15.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryDetailViewController : BaseViewController
@property (strong , nonatomic) NSMutableDictionary *param;

@property (nonatomic , copy) NSString *period;

@property (nonatomic , copy) NSString *time;

//@property (nonatomic , copy) NSString *mealStatus;//用户用餐状态：已订餐/已消费

@property (copy , nonatomic) NSString *status;//是否已经消费
@property (nonatomic , copy) NSString *evaluate;//是否评论
@property (nonatomic , copy) NSString *unEvaluate;//未评论时，向服务器提交评论所用
@property (nonatomic , copy) NSString *isEvaluate;//已经评论，向服务器请求评论内容所用

//从HistoryOrdersViewController传过来的数据
@property (strong , nonatomic) NSDictionary *json;
@end

NS_ASSUME_NONNULL_END
