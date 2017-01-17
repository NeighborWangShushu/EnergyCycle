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
    RadioDurationNone = 0,
    RadioDurationTenMinutes,
    RadioDurationTwentyMinutes,
    RadioDurationThirtyMinutes,
    RadioDurationFortyMinutes,
    RadioDurationFiftyMinutes,
    RadioDurationSixtyMinutes
};

typedef NS_ENUM(NSUInteger,RadioTimeSlot) {
    RadioTimeSlotAM = 0,
    RadioTimeSlotPM
};

@interface RadioClockModel : JKDBModel


@property (nonatomic,copy)NSString * identifier;

//提醒时间
@property (nonatomic,strong)NSDate * date;

//频道名称
@property (nonatomic,strong)NSString * channelName;

//持续时间
@property (nonatomic,assign)RadioDuration duration;

//时段 上午 下午
@property (nonatomic,assign)RadioTimeSlot slot;

//是否重复
@property (nonatomic)BOOL isRepeat;

//是否打开提醒功能
@property (nonatomic)BOOL isOpen;

//从通知进入（收到通知）
@property (nonatomic)BOOL isNotification;

//标题
@property (nonatomic,copy)NSString * title;

//副标题
@property (nonatomic,copy)NSString * subtitle;

//文本
@property (nonatomic,copy)NSString * body;

//图片
@property (nonatomic,copy)NSString * img;

//未设置重复的提醒日期
@property (nonatomic,assign)NSInteger weekdayOutRepeat;

//hour
@property (nonatomic,assign)NSInteger hour;

//minutes
@property (nonatomic,assign)NSInteger minutes;

//倒计时剩余时间
@property (nonatomic)NSTimeInterval residueTime;

//已播放时间
@property (nonatomic)NSTimeInterval playedTime;

//数组 存储闹钟周期Index  -- 存储本地
@property (nonatomic,strong)NSString * weekdaysToString;

//数组 存储闹钟周期Index  -- 不存储本地
@property (nonatomic,strong)NSMutableArray * weekdays;

//设定闹钟的周期集合（周一到周日）
@property (nonatomic,copy)NSString * notificationWeekydays;

//具体时间
@property (nonatomic,copy)NSString * specificTime;


- (NSString*)durationTime;


//本周需要设置推送的时间
- (NSArray*)alertDateComponents;


@end
