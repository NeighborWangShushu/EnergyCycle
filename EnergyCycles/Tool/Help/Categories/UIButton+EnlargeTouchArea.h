//
//  UIButton+EnlargeTouchArea.h
//  DuoLiFarm
//
//  Created by AD-iOS on 15/6/29.
//  Copyright (c) 2015年 wangding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (EnlargeTouchArea)

- (void)enlargeTouchAreaWithEdgeInset:(UIEdgeInsets)edgeInsets;

- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
