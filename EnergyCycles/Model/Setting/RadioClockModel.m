//
//  RadioClockModel.m
//  EnergyCycles
//
//  Created by vj on 2016/12/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RadioClockModel.h"
#import "NSDate+Category.h"
#import "NSDate+JKUtilities.h"
#import "NSString+Utils.h"
#import <UserNotifications/UserNotifications.h>

#define RADIOTITLE @"能量圈"
#define RADIOSUBTITLE @"一个暖心的提醒"
#define REQUESTIDENTIFIER @"request_identifier"


@interface RadioClockModel ()

@property (nonatomic,assign)UNUserNotificationCenter *notificationCenter;


@end

@implementation RadioClockModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

+(NSArray *)transients
{
    return [NSArray arrayWithObjects:@"notificationWeekydays",@"specificTime",@"weekdays",nil];
}

#pragma mark - SET

- (void)setWeekdays:(NSMutableArray *)weekdays {
    
    if (weekdays.count) {
        _weekdaysToString = [weekdays componentsJoinedByString:@","];
    }
}


#pragma mark - GET


- (NSString*)notificationWeekydays {
    
    NSArray * arr = @[];
    if (![self.weekdaysToString isEqualToString:@""]) {
       arr = [self.weekdaysToString componentsSeparatedByString:@","];
    }
   __block NSString * weekdays = @"";
    if (arr.count) {
        //为数组排序
        arr = [self sort:arr];
        
        weekdays = [weekdays stringByAppendingString:@"星期"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = [[arr objectAtIndex:idx] integerValue];
          weekdays = [weekdays stringByAppendingString:[NSString stringWithFormat:@"%@、",[NSDate shortWeekdayStringFromWeekday:index]]];
        }];
    }
    if (weekdays.length > 0) {
        return [weekdays substringWithRange:NSMakeRange(0, [weekdays length] - 1)];
    }
    return @"";
}


- (NSString*)specificTime {
    
    NSString * hour = @"";
    if (self.hour < 10) {
        hour = [NSString stringWithFormat:@"0%ld",self.hour];
    }else {
        hour = [NSString stringWithFormat:@"%ld",self.hour];
    }
    
    NSString * minutes = @"";
    if (self.minutes < 10) {
        minutes = [NSString stringWithFormat:@"0%ld",self.minutes];
    }else {
        minutes = [NSString stringWithFormat:@"%ld",self.minutes];
    }
    NSString*slot = @"AM";
    switch (self.slot) {
        case RadioTimeSlotAM:
            slot = @"AM";
            break;
        case RadioTimeSlotPM:
            slot = @"PM";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@:%@ %@",hour,minutes,slot];
}

- (NSString*)durationTime {
    NSString*time = @"";
    switch (self.duration) {
        case RadioDurationNone:
            time = @"关闭";
            break;
        case RadioDurationTenMinutes:
            time = @"10分钟";
            break;
        case RadioDurationTwentyMinutes:
            time = @"20分钟";
            break;
        case RadioDurationThirtyMinutes:
            time = @"30分钟";
            break;
        case RadioDurationFortyMinutes:
            time = @"40分钟";
            break;
        case RadioDurationFiftyMinutes:
            time = @"50分钟";
            break;
        case RadioDurationSixtyMinutes:
            time = @"60分钟";
            break;
        default:
            break;
    }
    return time;
}



#pragma mark - init

- (void)initialize {
    
    self.title = RADIOTITLE;
    self.subtitle = RADIOSUBTITLE;
    NSInteger hour = 9;
    NSInteger minutes = 0;
    self.channelName = RadioClockChannelNameBBC;
    self.duration = RadioDurationTenMinutes;
    NSString * channelName = [self channelName];
    self.body = [NSString stringWithFormat:@"%ld点%ld分啦！能量圈提醒您应该收听%@电台啦！滑动本消息收听~",(long)hour,minutes,channelName];
    self.weekday = 4;
    self.hour = 9;
    self.minutes = 0;
    self.img = @"BBC";
    
    self.identifier = [NSString stringWithFormat:@"%@%i",REQUESTIDENTIFIER,self.pk];
    
}


- (void)setDate:(NSDate *)date {
//    if (date) {
//        _date = date;
//        self.weekday = [date weekday];
//        self.hour = [date hour];
//        self.minutes = [date minute];
//    }
    
}

- (NSArray*)sort:(NSArray*)datas {
    NSComparator finderSort = ^(id string1,id string2){
        
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *resultArray = [datas sortedArrayUsingComparator:finderSort];
    return resultArray;
}

@end
