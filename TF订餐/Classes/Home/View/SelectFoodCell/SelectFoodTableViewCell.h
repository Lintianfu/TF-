//
//  SelectFoodTableViewCell.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
@protocol SelectFoodCellDelegate <NSObject>
@optional
-(void)didSelectFood:(Food *)food selectButton:(UIButton *)button;
-(void)cancleSelectFood:(Food *)food;
@end
@interface SelectFoodTableViewCell : UITableViewCell
@property(nonatomic,strong)Food *food;
@property (weak , nonatomic) id<SelectFoodCellDelegate> delegate;
-(instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath selected:(Boolean) selected;
@end

