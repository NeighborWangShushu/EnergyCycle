//
//  HealthModel.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HealthModel.h"
#import "NSDateFormatter+Category.h"
#import "NSDate+Category.h"


@implementation HealthModel

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
