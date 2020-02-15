//
//  CommitView.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "CommitView.h"
#import <Masonry/Masonry.h>
@interface CommitView()
@property(nonatomic,strong)UIButton *commitbutton;
@end
@implementation CommitView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.commitbutton=[[UIButton alloc]init];
        self.commitbutton.titleLabel.font=[UIFont systemFontOfSize:20];
        [self.commitbutton setTitle:@"点 餐" forState:UIControlStateNormal];
        self.commitbutton.backgroundColor=[UIColor redColor];
        self.commitbutton.layer.cornerRadius=5;
        self.layer.maskedCorners=YES;
        [self.commitbutton addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.commitbutton];
    }
    return self;
}
-(void)layoutSubviews
{
    [_commitbutton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_offset(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}
-(void)commitBtnClick
{
    if ([self.delegate respondsToSelector:@selector(didClickCommitButton:)]) {
        [self.delegate didClickCommitButton:_commitbutton];
    }
}

@end
