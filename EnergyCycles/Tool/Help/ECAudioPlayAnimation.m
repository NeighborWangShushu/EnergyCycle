//
//  ECAudioPlayAnimation.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECAudioPlayAnimation.h"

@implementation ECAudioPlayAnimation

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAudioPlayAnimationView];
    }
    return self;
}

- (void)createAudioPlayAnimationView {
    self.numberOfRect = 6;
    self.rectColor = [UIColor blackColor];
    self.space = 1;
    self.rectSize = self.frame.size;
    self.rectWidth = 5;
}

- (void)addRectView {
    [self removeRect];
    self.hidden = NO;
    for (int i = 0; i < self.numberOfRect; i++) {
        CGFloat x = i * (self.rectWidth + self.space);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, self.rectWidth, 1)];
        view.backgroundColor = self.rectColor;
        [view.layer addAnimation:[self addAnimationWithDelay:((double)i * 0.1) currentHeight:[self animationToValueHeight:i]] forKey:@"rectAnimation"];
        [self addSubview:view];
    }
}

- (CGFloat)animationToValueHeight:(int)number {
    NSInteger centerNum = self.numberOfRect / 2;
    NSInteger minHeight = self.rectSize.height / centerNum;
    NSInteger abs = ABS(centerNum - number);
    CGFloat currentHeight = (self.rectSize.height - (abs * minHeight)) <= 1 ? 1 : self.rectSize.height - (abs * minHeight);
    return currentHeight;
}

- (CAAnimation *)addAnimationWithDelay:(double)delay currentHeight:(CGFloat)currentHeight {
    // CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fromValue = @(1);
    animation.toValue = @(currentHeight);
    // animation.fromValue = [NSNumber numberWithFloat:0];
    // animation.toValue = [NSNumber numberWithDouble:M_PI];
    animation.duration = 0.4;
    animation.beginTime = CACurrentMediaTime() + delay;
    return animation;
}

- (void)startAnimation {
    [self addRectView];
}

- (void)stopAnimation {
    [self removeRect];
}

- (void)removeRect {
    if (self.subviews.count > 0) {
        [self removeFromSuperview];
    }
    self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
