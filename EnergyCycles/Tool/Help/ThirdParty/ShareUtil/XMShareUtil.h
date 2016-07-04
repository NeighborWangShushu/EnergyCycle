//  
//  XMShareUtil.h
//
//
//

#import <Foundation/Foundation.h>
#import "CommonMarco.h"

@interface XMShareUtil : NSObject

/**
 *  分享标题
 */
@property (nonatomic, strong) NSString *shareTitle;

/**
 *  分享内容
 */
@property (nonatomic, strong) NSString *shareText;

/**
 *  分享链接地址
 */
@property (nonatomic, strong) NSString *shareUrl;


@end
