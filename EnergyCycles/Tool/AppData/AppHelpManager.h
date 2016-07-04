//
//  AppHelpManager.h
//
//

#import <Foundation/Foundation.h>

#define AppHM ((AppHelpManager *)[AppHelpManager sharedInstance])

#define CurrentUserMid [[AppHM readMidAndToken] objectForKey:@"mid"]
#define CurrentUserToken [[AppHM readMidAndToken] objectForKey:@"token"]


@interface AppHelpManager : NSObject

//单例
+ (id)sharedInstance;

//检测网络
- (BOOL)isConnectionAvailable;

//邮箱格式
- (BOOL)isEmail:(NSString *)email;

//电话格式
- (BOOL)isPhoneNum:(NSString*)honeNum;

//密码格式
- (BOOL)isValidPassword:(NSString *)password;

//写入mid、token
- (void)writeNSUserDefaultWithMid:(NSString *)mid withToken:(NSString *)token;
//读取userid、token
- (NSString *)readUserId;
- (NSString *)readToken;
- (NSString *)readPhone;

//获取通讯录权限
+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block;

//获取第一帧图片
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;



@end
