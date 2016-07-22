//
//  UIImage+Category.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 *  将图片缩放到指定的CGSize大小
 *
 *  @param image 原始的图片
 *  @param size  要缩放的大小
 *
 *  @return 缩放后的图片
 */
+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)size;

/**
 *  从图片中按照指定的位置大小截取图片的一部分
 *
 *  @param image 原始图片
 *  @param rect  截取的区域
 *
 *  @return 截取的图片
 */

+ (UIImage *)imageFromImage:(UIImage *)image Rect:(CGRect)rect;

/**
 *  自适应裁剪
 根据给定的size的宽高比自动缩放原图片,自动判断截取位置,进行图片截取
*
*  @param image 原始的图片
*  @param size  截取图片的size
*
*  @return 截取的图片
*/
+ (UIImage *)clipImage:(UIImage *)image Rect:(CGSize)size;


@end
