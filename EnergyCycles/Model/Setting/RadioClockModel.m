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

#pragma mark GET

- (NSString*)notificationWeekydays {
    NSArray * arr = [RadioClockModel findAll];
    NSString * weekdays = @"";
    if (arr.count) {
        weekdays = [weekdays stringByAppendingString:@"星期"];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RadioClockModel*model = arr[idx];
            [weekdays stringByAppendingString:[NSString stringWithFormat:@"%@、",[NSDate shortWeekdayStringFromWeekday:model.weekday]]];
        }];
    }
    if (weekdays.length > 0) {
        return [weekdays substringWithRange:NSMakeRange(0, [weekdays length] - 1)];
    }
    return @"";
}

- (NSString*)specificTime {
    
    return [self.date formattedDateDescription];
}

- (NSString*)getChannelName {
    NSString*name = @"";
    switch (self.channelName) {
        case RadioClockChannelNameBBC:
            name = @"bbc";
            break;
        case RadioClockChannelNameCNN:
            name = @"cnn";
            break;
        case RadioClockChannelNameJPR:
            name = @"jpr";
            break;
        case RadioClockChannelNameLBC:
            name = @"lbc";
            break;
        case RadioClockChannelNameNPR:
            name = @"nrp";
            break;
        case RadioClockChannelNameTED:
            name = @"ted";
            break;
        case RadioClockChannelNameVOA:
            name = @"voa";
            break;
        case RadioClockChannelNameFOXNEWS:
            name = @"fox";
            break;
        case RadioClockChannelNameAustralia:
            name = @"australia";
            break;
            
        default:
            break;
    }
    return name;
}


- (NSString*)durationTime {
    NSString*time = @"";
    switch (self.duration) {
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
    NSString * channelName = [self getChannelName];
    self.body = [NSString stringWithFormat:@"%ld点%ld分啦！能量圈提醒您应该收听%@电台啦！滑动本消息收听~",(long)hour,minutes,channelName];
    self.weekday = 0;
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



@end
