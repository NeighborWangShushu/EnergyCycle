//
//  AppHelpManager.m
//
//

#import "AppHelpManager.h"

#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBookDefines.h>
#import <AddressBook/AddressBook.h>
#import <CoreMedia/CoreMedia.h>

@implementation AppHelpManager

#pragma mark - 单例
+ (id)sharedInstance{
    static AppHelpManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppHelpManager alloc] init];
    });
    return manager;
}

#pragma mark - 检测网络
- (BOOL)isConnectionAvailable {
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown://未知
//                break;
//            case AFNetworkReachabilityStatusNotReachable://无网络连接
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN://手机自带网络
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi://WiFi
//                break;
//            default:
//                break;
//        }
//    }];
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }

    return isExistenceNetwork;
}

#pragma mark - 邮箱格式
- (BOOL)isEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - 电话格式
- (BOOL)isPhoneNum:(NSString*)honeNum{
    NSString *telphone = @"^(1(([357][0-9])|(47)|[8][012356789]))\\d{8}$";
    NSPredicate *telphoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telphone];
    
    return [telphoneTest evaluateWithObject:honeNum];
}

#pragma mark - 密码格式
/* ^ 匹配一行的开头位置
 (?![0-9]+$) 预测该位置后面不全是数字
 (?![a-zA-Z]+$) 预测该位置后面不全是字母
 [0-9A-Za-z] {8,16} 由8-16位数字或这字母组成
 $ 匹配行结尾位置
 */
- (BOOL)isValidPassword:(NSString *)password{
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}


- (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
    
}


#pragma mark - MID、TOKEN
//写入MID、TOKEN
- (void)writeNSUserDefaultWithMid:(NSString *)mid withToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:mid forKey:@"mid"];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//读取MID、TOKEN
- (NSString *)readUserId {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    if ((userId == nil || [userId isKindOfClass:[NSNull class]] || [userId isEqual:[NSNull null]])) {
        userId = @"";
    }
    return userId;
}

- (NSString *)readToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"TOKEN"];
    if ((token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]])) {
        token = @"";
    }
    return token;
}

- (NSString *)readPhone {
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"];
    if ((phone == nil || [phone isKindOfClass:[NSNull class]] || [phone isEqual:[NSNull null]])) {
        phone = @"";
    }
    return phone;
}

- (NSString *)readUserName {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserNickName"];
    if ((name == nil || [name isKindOfClass:[NSNull class]] || [name isEqual:[NSNull null]])) {
        name = @"";
    }
    return name;
}

#pragma mark - 获取通讯录权限
+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error: %@", (__bridge NSError *)error);
                }else if (!granted) {
                    block(NO);
                }else {
                    block(YES);
                }
            });
        });
    }else {
        block(YES);
    }
}

#pragma mark - 获取第一帧图片
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

- (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
    
}

@end
