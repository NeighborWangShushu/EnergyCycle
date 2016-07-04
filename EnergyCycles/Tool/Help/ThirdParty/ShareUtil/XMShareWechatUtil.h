//
//  XMShareWechatUtil.h
//  
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "XMShareUtil.h"

@interface XMShareWechatUtil : XMShareUtil

/**
 *  分享到微信会话
 */
- (void)shareToWeixinSession;

/**
 *  分享到朋友圈
 */
- (void)shareToWeixinTimeline;

+ (instancetype)sharedInstance;



@end
