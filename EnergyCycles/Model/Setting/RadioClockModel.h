//
//  RadioClockModel.h
//  EnergyCycles
//
//  Created by vj on 2016/12/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

typedef NS_ENUM(NSUInteger,RadioClockChannelName) {
    RadioClockChannelNameBBC = 0,
    RadioClockChannelNameCNN,
    RadioClockChannelNameFOXNEWS,
    RadioClockChannelNameNPR,
    RadioClockChannelNameAustralia,
    RadioClockChannelNameLBC,
    RadioClockChannelNameVOA,
    RadioClockChannelNameJPR,
    RadioClockChannelNameTED
    
};

typedef NS_ENUM(NSUInteger,RadioDuration) {
    RadioDurationTenMinutes = 0,
    RadioDurationTwentyMinutes,
    RadioDurationThirtyMinutes,
    RadioDurationFortyMinutes,
    RadioDurationFiftyMinutes,
    RadioDurationSixtyMinutes
};

@interface RadioClockModel : JKDBModel


@property (nonatomic,copy)NSString * identifier;
//提醒时间
@property (nonatomic,strong)NSDate * date;

//频道名称
@property (nonatomic,assign)RadioClockChannelName channelName;

//持续时间
@property (nonatomic,assign)RadioDuration duration;

//标题
@property (nonatomic,copy)NSString * title;

//副标题
@property (nonatomic,copy)NSString * subtitle;

//文本
@property (nonatomic,copy)NSString * body;

//图片
@property (nonatomic,copy)NSString * img;

//weeday
@property (nonatomic,assign)NSInteger weekday;

//hour
@property (nonatomic,assign)NSInteger hour;

//minutes
@property (nonatomic,assign)NSInteger minutes;

//设定闹钟的周期集合（周一到周日）
@property (nonatomic,readonly)NSString * notificationWeekydays;

//具体时间
@property (nonatomic,readonly)NSString * specificTime;


- (NSString*)getChannelName;

- (NSString*)durationTime;

@end
