//
//  CalendarCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CalendarCell.h"
#import "FSCalendarExtensions.h"

@implementation CalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *selectionLayer = [[CAShapeLayer alloc] init];
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.selectionLayer.frame = self.bounds;
    self.preferredTitleOffset = CGPointMake(0, 3); // 修改文字的偏移量
    
    if (self.selectionType != SelectionTypeNone) {
        
        CGFloat diameter = MIN(self.selectionLayer.fs_height, self.selectionLayer.fs_width);
        CGFloat reduce = diameter / 4;
        self.selectionLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.fs_width/2-diameter / 2 + reduce, self.contentView.fs_height / 2 - diameter / 2 + reduce, diameter - 2 * reduce, diameter - 2 * reduce)].CGPath;
        
        if (self.selectionType == SelectionTypeFinish) {
            self.selectionLayer.fillColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
        } else if (self.selectionType == SelectionTypeUndone) {
            self.selectionLayer.fillColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1].CGColor;
        }
        
        self.preferredTitleDefaultColor = [UIColor whiteColor]; // 设置文字的颜色
        
        // 设置阴影
        self.selectionLayer.shadowOpacity = 0.5; // 阴影透明度
        self.selectionLayer.shadowColor = self.selectionLayer.fillColor; // 阴影颜色
        self.selectionLayer.shadowOffset = CGSizeMake(0, 4); // 阴影偏移量
        self.selectionLayer.shadowRadius = 3; // 阴影半径
        
    } else if (self.selectionType == SelectionTypeNone) {
        
        self.selectionLayer.fillColor = [UIColor clearColor].CGColor;
        
    }
    
}

- (void)setSelectionType:(SelectionType)selectionType {
    if (_selectionType != selectionType) {
        _selectionType = selectionType;
        [self setNeedsLayout];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
