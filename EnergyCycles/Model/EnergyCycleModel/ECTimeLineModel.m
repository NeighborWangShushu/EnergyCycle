//
//  ECTimeLineModel.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECTimeLineModel.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"

 CGFloat contentLabelFontSize = 15;
 CGFloat maxContentLabelHeight = 70;

@implementation ECTimeLineModel
{
    CGFloat _lastContentWidth;
}

@synthesize msgContent = _msgContent;

- (void)setMsgContent:(NSString *)msgContent
{
    _msgContent = msgContent;
    
}

- (NSString *)msgContent
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_msgContent boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }
    
    return _msgContent;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

- (void)setTime:(NSString *)time {
    NSDateFormatter*f = [NSDateFormatter defaultDateFormatter];
    NSString * s = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString*newTime = [s stringByReplacingCharactersInRange:NSMakeRange([time length] - 4, 4 - ([time length] - [s length])) withString:@""];
    NSLog(@"%@",newTime);
    
    NSDate*date  = [f dateFromString:newTime];
    _time = [date timeIntervalDescription];
    NSLog(@"%@",_time);
}

@end