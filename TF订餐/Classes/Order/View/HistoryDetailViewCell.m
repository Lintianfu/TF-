//
//  HistoryDetailViewCell.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/15.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "HistoryDetailViewCell.h"
#import <SDWebImage/SDWebImage.h>
#define DLIconURL @"http://119.145.103.100:8898/meal"
#define DLIP @"http://119.145.103.100:8898"//东丽机房
#define DLPicURL [NSString stringWithFormat:@"%@/meal",DLIP]
@interface HistoryDetailViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *foodPicture;
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *foodSort;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (copy, nonatomic) NSString *foodID;

@end
@implementation HistoryDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"historyDetailCell";
    HistoryDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryDetailViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setHistoryDetailOrder:(HistoryDetailOrder *)historyDetailOrder
{
    _historyDetailOrder = historyDetailOrder;
    //设置食物图片
    NSURL *foodImage_URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DLPicURL,historyDetailOrder.foodPicture]];
    [self.foodPicture sd_setImageWithURL:foodImage_URL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image){
            self.foodPicture.image = image;
        }
    }];
    
    self.foodName.text = historyDetailOrder.foodName;
    self.foodSort.text = historyDetailOrder.foodSort;
    self.foodID = historyDetailOrder.foodID;
    self.price.text = [NSString stringWithFormat:@"¥%@",historyDetailOrder.foodPrice];
    [self.foodPicture setContentMode:UIViewContentModeScaleAspectFill];
}
@end
