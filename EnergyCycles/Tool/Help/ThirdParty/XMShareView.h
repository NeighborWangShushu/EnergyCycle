//
//  XMShareView.h
//  
//
//

#import <UIKit/UIKit.h>

//分享类型
typedef NS_ENUM(NSInteger, SHARE_ITEM){
    SHARE_ITEM_WEIXIN_SESSION,//微信
    SHARE_ITEM_WEIXIN_TIMELINE,//微信朋友圈
    SHARE_ITEM_QQ,//QQ
    SHARE_ITEM_QZONE,//QQ空间
    SHARE_ITEM_WEIBO//微博
};

@interface XMShareView : UIView {
    NSMutableArray *iconList;//图片项
    NSMutableArray *textList;//文字项
}

//分享标题
@property (nonatomic, strong) NSString *shareTitle;

//分享文本
@property (nonatomic, strong) NSString *shareText;

//分享链接
@property (nonatomic, strong) NSString *shareUrl;

//分享图片
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *imageUrl;

//分享标题图片
@property (nonatomic, strong) NSString *shareImageUrl;


@end

