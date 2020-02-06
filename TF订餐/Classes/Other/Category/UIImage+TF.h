//
//  UIImage+TF.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/6.
//  Copyright © 2020 Mr.TF. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TF)
/**
 *  根据颜色创建图片（宽度和高度都为1）
 *
 *  @param aColor 颜色
 *
 *  @return 图片
 */
+(UIImage *)TF_imageWithColor:(UIColor *)aColor;
/**
 *  根据颜色创建指定大小图片
 *
 *  @param aColor 颜色
 *
 *  @return 图片
 */
+(UIImage *)TF_imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;


/**
 放缩图片

 @param scaleFactor 缩放因子
 @return 图片
 */
-(UIImage*)TF_scaleByFactor:(float)scaleFactor;

/**
 按照size的尺寸去填充图片

 @param newSize 尺寸
 @return 修改后的图片
 */
-(UIImage*)TF_scaleToFillSize:(CGSize)newSize;
@end

NS_ASSUME_NONNULL_END
