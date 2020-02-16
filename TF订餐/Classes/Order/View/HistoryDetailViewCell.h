//
//  HistoryDetailViewCell.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/15.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryOrder.h"
#import "HistoryDetailOrder.h"
NS_ASSUME_NONNULL_BEGIN

@interface HistoryDetailViewCell : UITableViewCell
@property (strong , nonatomic) HistoryDetailOrder *historyDetailOrder;
-(instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
