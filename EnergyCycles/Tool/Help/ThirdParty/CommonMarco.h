//
//  CommonMarco.h
//
//
//

#ifndef XMShare_CommonMarco_h
#define XMShare_CommonMarco_h

//微信
#define APP_KEY_WEIXIN            @"wx4db0f86a514ef7ef"

//QQ
#define APP_KEY_QQ                @"1104987324"

//微博
#define APP_KEY_WEIBO             @"4273175200"
#define APP_KEY_WEIBO_RedirectURL @"http://www.sina.com"

//分享图片
#define SHARE_IMG [UIImage imageNamed:@"icon-60.png"]

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
