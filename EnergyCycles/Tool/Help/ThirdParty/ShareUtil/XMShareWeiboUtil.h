//
//  XMShareWeiboUtil.h
//  
//
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

#import "XMShareUtil.h"

@interface XMShareWeiboUtil : XMShareUtil


/**
 *  分享到微博
 */
- (void)shareToWeibo;

+ (instancetype)sharedInstance;

- (void)weiBoLogin;

@end
