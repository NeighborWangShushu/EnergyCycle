//
//  RadioNotificationController.m
//  EnergyCycles
//
//  Created by vj on 2016/12/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RadioNotificationController.h"
#import <UserNotifications/UserNotifications.h>

@interface RadioNotificationController ()

@property (nonatomic,assign)UNUserNotificationCenter * notificationCenter;

@end

@implementation RadioNotificationController

+ (RadioNotificationController *)shareInstance {
    static RadioNotificationController *shareNetworkMessage = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareNetworkMessage = [[self alloc] init];
    });
    
    return shareNetworkMessage;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize {
    self.notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    [self.notificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization successded!");
        }
    }];
    
    [self.notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",settings);
    }];
}


+ (NSArray*)findAll {
    return [RadioClockModel findAll];
}

+ (void)add:(RadioClockModel *)model {
    [model save];
    
}

+ (void)remove:(RadioClockModel *)model {
    [model deleteObject];
}

+ (void)addObjects:(NSArray *)models {
    for (RadioClockModel * model in models) {
        [model save];
    }
}

+ (void)removeAll {
   
    
}


- (void)addNotification:(RadioClockModel*)model {
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:model.identifier ofType:@"png"];
    
    // 5.依据 url 创建 attachment
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"request_identifier1" URL:[NSURL fileURLWithPath:imagePath] options:nil error:nil];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = model.title;
    content.subtitle = model.subtitle;
    content.body = model.body;
    content.attachments = @[attachment];

    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekday = model.weekday;
    components.hour = model.hour;
    components.minute = model.minutes;
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:model.identifier
                                                                          content:content
                                                                          trigger:trigger];
    [self.notificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        
    }];
    
}


@end
