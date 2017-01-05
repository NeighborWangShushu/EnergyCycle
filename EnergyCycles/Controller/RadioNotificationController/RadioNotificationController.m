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
    [[RadioNotificationController shareInstance] addNotification:model];
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
    NSArray * arr = [RadioClockModel findAll];
    for (RadioClockModel*model in arr) {
        [self remove:model];
    }
    [RadioClockModel clearTable];
}


- (void)addNotification:(RadioClockModel*)model {
    
    
    
    
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    components.hour = model.hour;
//    components.minute = model.minutes;
    
    
  
    
    
    NSArray * weekdayComponents= [model alertDateComponents];
    
    for (int i = 0; i < weekdayComponents.count; i++) {
        NSDateComponents *components = weekdayComponents[i];
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:model.channelName ofType:@"png"];
        
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = model.title;
        content.subtitle = model.subtitle;
        content.body = model.body;
        content.sound = [UNNotificationSound defaultSound];
        content.categoryIdentifier = model.identifier;
        // 5.依据 url 创建 attachment
        if (imagePath) {
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:model.identifier URL:[NSURL fileURLWithPath:imagePath] options:nil error:nil];
            content.attachments = @[attachment];
        }
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"%i",i]
                                                                              content:content
                                                                              trigger:trigger];
        
        [self.notificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"addNotificationRequest success");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            }
            
        }];
    
    }
    
}





- (void)removeAllNotifications {
    if (self.notificationCenter) {
        [self.notificationCenter removeAllPendingNotificationRequests];
    }
}

- (void)removeNotifications:(NSArray*)models {
    
    NSMutableArray * identifiers = [NSMutableArray array];
    
    [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RadioClockModel*model = models[idx];
        [identifiers addObject:model.identifier];
    }];
    if (self.notificationCenter) {
        [self.notificationCenter removePendingNotificationRequestsWithIdentifiers:identifiers];
    }
}


- (void)removeNotification:(RadioClockModel*)model {
    
    if (self.notificationCenter) {
        [self.notificationCenter removePendingNotificationRequestsWithIdentifiers:@[model.identifier]];
    }
    
}


@end
