//
//  CommonMarco.h
//
//
//

#ifndef XMShare_CommonMarco_h
#define XMShare_CommonMarco_h

//微信
#define APP_KEY_WEIXIN            @"wx4db0f86a514ef7ef"
#define APP_SECRECT_WEIXIN        @"eb7c123f1794cd3f173569e5bb6801dc"

//QQ
#define APP_ID_QQ                 @"1104987324"
#define APP_KEY_QQ                @"Icfd6jAfqflPmMuL"

//微博
#define APP_KEY_WEIBO             @"4273175200"
#define APP_SECRECT_WEIBO         @"922730ffd03b87285c07c27325146937"
#define APP_KEY_WEIBO_RedirectURL @"http://www.sharesdk.cn"

//分享图片
#define SHARE_IMG [UIImage imageNamed:@"icon-80.png"]

#define SHARE_IMG_COMPRESSION_QUALITY 0.5

///  Common size
#define SIZE_OF_SCREEN    [[UIScreen mainScreen] bounds].size


//View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

///  View加边框
#define ViewBorder(View, BorderColor, BorderWidth )\
\
View.layer.borderColor = BorderColor.CGColor;\
View.layer.borderWidth = BorderWidth;



#endif
