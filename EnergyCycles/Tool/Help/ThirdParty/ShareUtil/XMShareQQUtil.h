//  
//  XMShareQQUtil.h
//
//
//

#import <Foundation/Foundation.h>
#import "CommonMarco.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

#import "XMShareUtil.h"

//分享到QQ的类型
typedef NS_ENUM(NSInteger, SHARE_QQ_TYPE){
    SHARE_QQ_TYPE_SESSION,//QQ会话
    SHARE_QQ_TYPE_QZONE//  QQ空间
};

@protocol getQQLoginGetInformationDelegate <NSObject>
- (void)passQQLoginGetInformationWithDict:(NSDictionary *)dict;

@end

@interface XMShareQQUtil : XMShareUtil <TencentSessionDelegate,TencentApiInterfaceDelegate,TCAPIRequestDelegate,QQApiInterfaceDelegate>

@property (nonatomic, strong) NSMutableDictionary *inforDict;


/**
 *  分享到QQ会话
 */
- (void)shareToQQ;

/**
 *  分享到QQ空间
 */
- (void)shareToQzone;

+ (instancetype)sharedInstance;

//登录
- (void)login;

@property (nonatomic, strong) id <getQQLoginGetInformationDelegate> delegate;


@end
