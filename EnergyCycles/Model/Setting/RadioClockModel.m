//
//  RadioClockModel.m
//  EnergyCycles
//
//  Created by vj on 2016/12/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RadioClockModel.h"
#import "NSDate+Category.h"
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

- (NSString*)getChannelName {
    NSString*name = @"";
    switch (self.channelName) {
        case RadioClockChannelNameBBC:
            name = @"BBC";
            break;
        case RadioClockChannelNameCNN:
            name = @"CNN";
            break;
        case RadioClockChannelNameJPR:
            name = @"JPR";
            break;
        case RadioClockChannelNameLBC:
            name = @"LBC";
            break;
        case RadioClockChannelNameNPR:
            name = @"NPR";
            break;
        case RadioClockChannelNameTED:
            name = @"TED";
            break;
        case RadioClockChannelNameVOA:
            name = @"VOA";
            break;
        case RadioClockChannelNameFOXNEWS:
            name = @"FOXNEWS";
            break;
        case RadioClockChannelNameAustralia:
            name = @"Australia";
            break;
            
        default:
            break;
    }
    return name;
}

- (void)initialize {
    
    self.title = RADIOTITLE;
    self.subtitle = RADIOSUBTITLE;
    NSInteger hour = 9;
    NSInteger minutes = 0;
    self.channelName = RadioClockChannelNameBBC;
    self.duration = RadioDurationTenMinutes;
    NSString * channelName = [self getChannelName];
    self.body = [NSString stringWithFormat:@"%ld点%ld分啦！能量圈提醒您应该收听%@电台啦！滑动本消息收听~",hour,minutes,channelName];
    self.weekday = 0;
    self.hour = 9;
    self.minutes = 0;
    self.img = @"BBC";
    
    self.identifier = [NSString stringWithFormat:@"%@%i",REQUESTIDENTIFIER,self.pk];
    
}


- (void)setDate:(NSDate *)date {
    
    _date = date;
    self.weekday = [date weekday];
    self.hour = [date hour];
    self.minutes = [date minute];
    
    
    
}



@end
