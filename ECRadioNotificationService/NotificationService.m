//
//  NotificationService.m
//  ECRadioNotificationService
//
//  Created by vj on 2016/12/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler     = contentHandler;
    
    // 1.把推送内容转为可变类型
    self.bestAttemptContent = [request.content mutableCopy];
    
    // 2.获取 1 中自定义的字段 value
    NSString *urlStr = [request.content.userInfo valueForKey:@"ECRadioNotificationService"];
    
    // 3.将文件夹名和后缀分割
//    NSArray *urls    = [urlStr componentsSeparatedByString:@"."];
    
    // 4.获取该文件在本地存储的 url
//    NSURL *urlNative = [[NSBundle mainBundle] URLForResource:urls[0] withExtension:urls[1]];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *localPath = [documentPath stringByAppendingPathComponent:@"bbc.png"];
    
    // 5.依据 url 创建 attachment
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:urlStr URL:[NSURL URLWithString:[@"file://" stringByAppendingString:localPath]] options:nil error:nil];
    
    // 6.赋值 @[attachment] 给可变内容
    self.bestAttemptContent.attachments = @[attachment];
    
    // 7.处理该内容
    self.contentHandler(self.bestAttemptContent);
    
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
