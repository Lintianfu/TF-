//
//  TabBarViewController.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/6.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabBarViewController : UITabBarController
-(void)initTabbar;
-(void)addChildViewControllers;
-(void)addOneChildVC:(UIViewController*)viewController title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;
@end

NS_ASSUME_NONNULL_END
