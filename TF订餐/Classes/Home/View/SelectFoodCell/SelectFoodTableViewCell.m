//
//  SelectFoodTableViewCell.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "SelectFoodTableViewCell.h"
#import <SDWebImage/SDWebImage.h>
@interface SelectFoodTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *foodImage;
@property (weak, nonatomic) IBOutlet UILabel *foodName;
@property (weak, nonatomic) IBOutlet UILabel *foodType;
@property (weak, nonatomic) IBOutlet UILabel *recommendation;
@property (weak, nonatomic) IBOutlet UILabel *foodPrice;
@property (weak, nonatomic) IBOutlet UIButton *likeButton_1;
@property (weak, nonatomic) IBOutlet UIButton *likeButton_2;
@property (weak, nonatomic) IBOutlet UIButton *likeButton_3;
@property (weak, nonatomic) IBOutlet UIButton *likeButton_4;
@property (weak, nonatomic) IBOutlet UIButton *likeButton_5;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
//用户是否点餐
@property (assign , nonatomic) Boolean selectFood;


@end

@implementation SelectFoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath selected:(Boolean)selected
{
    static NSString *ID = @"selectFoodCell";
    SelectFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectFoodTableViewCell" owner:nil options:nil] lastObject];
    }
    //设置cell样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectFood = selected;
    return cell;
}
-(void)setFood:(Food *)food
{
    _food = food;
    //设置食物图片
    NSURL *foodImage_URL = [NSURL URLWithString:food.picture];
    NSLog(@"图片的url%@",foodImage_URL);
    [self.foodImage sd_setImageWithURL:foodImage_URL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image){
            self.foodImage.image = image;
        }
    }];
    //设置食物名
    self.foodName.text = food.foodName;
    //设置事食物分类
    self.foodType.text = food.sort;
    //设置按钮选择状态
    self.selectedButton.selected = self.food.foodIsSelected;
    //设置价格
    self.foodPrice.text = [NSString stringWithFormat:@"￥%@",food.foodPrice];
    //设置食物ID
    self.food.foodUid = food.foodUid;

}
-(void)selectFood:(UIButton *)selectButton {
        self.selectedButton.selected = !self.selectedButton.selected;
        self.food.foodIsSelected = self.selectedButton.selected;
        //使用代理传输数据给SelectFoodViewController
        if (self.selectedButton.selected && [self.delegate respondsToSelector:@selector(didSelectFood:selectButton:)]) {
            [self.delegate didSelectFood:self.food selectButton:selectButton];
            NSLog(@"点击了选择");
            [self.selectedButton setImage:[UIImage imageNamed:@"choice_selected"] forState:UIControlStateNormal];
        }
        if (!self.selectedButton.selected && [self.delegate respondsToSelector:@selector(cancleSelectFood:)]) {
            [self.delegate cancleSelectFood:self.food];
            [self.selectedButton setImage:[UIImage imageNamed:@"choice_normal"] forState:UIControlStateNormal];
        }
    
}
- (IBAction)selectBtn:(id)sender {
    [self selectFood:self.selectedButton];
}

@end
