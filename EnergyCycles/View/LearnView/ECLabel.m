//
//  ECLabel.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECLabel.h"

@implementation ECLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width  += 10;
    size.height += 10;
    return size;
}

@end
