//
//  ECAudioPlayAnimation.h
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECAudioPlayAnimation : UIView

@property (nonatomic, assign) NSInteger numberOfRect; // view的个数
@property (nonatomic, strong) UIColor *rectColor; // 颜色
@property (nonatomic, assign) CGSize rectSize; // 整个动画的大小
@property (nonatomic, assign) CGFloat space; // 每个view的间距
@property (nonatomic, assign) CGFloat rectWidth; // 单个view的宽

- (void)startAnimation;

- (void)stopAnimation;

@end
