//
//  CommitView.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommitViewDelegate <NSObject>
@optional
-(void)didClickCommitButton:(UIButton *)commitBtn;
@end

@interface CommitView : UIView
@property(weak,nonatomic)id<CommitViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
