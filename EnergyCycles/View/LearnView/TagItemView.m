//
//  TagItemView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TagItemView.h"
#import "Masonry.h"
#import "ECLabel.h"

@interface TagItemView (){
    ECLabel * label;
}

@end

@implementation TagItemView

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}



- (CGPoint)bottomPoint {
    CGPoint p = CGPointMake(self.frame.origin.x + self.frame.size.width/2, self.frame.size.height + self.frame.origin.y + 10);
    return p;
}

- (void)initialize {
 
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    label = [ECLabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.text = self.title;
    label.textColor = [UIColor redColor];
    label.numberOfLines = 1;
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
    }];
}

- (CGSize)intrinsicContentSize {
    return label.intrinsicContentSize;
}

- (void)layoutSubviews {
    

}



@end
