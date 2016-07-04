//
//  XMShareView.m
//  
//
//

#import "XMShareView.h"

#import "VerticalUIButton.h"
#import "CommonMarco.h"
#import "XMShareWeiboUtil.h"
#import "XMShareWechatUtil.h"
#import "XMShareQQUtil.h"

//每行显示数量
static const NSInteger numbersOfItemInLine = 4;

@implementation XMShareView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureData];
        [self initUI];
    }
    
    return self;
}

#pragma mark - 加载视图
- (void)initUI {
    //背景色黑色半透明
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    //点击关闭
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickClose)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SIZE_OF_SCREEN.height, Screen_width, 125)];
    backView.backgroundColor = [UIColor clearColor];
    [self addSubview:backView];
    
    [UIView animateWithDuration:0.25 animations:^{
        backView.frame = CGRectMake(0, SIZE_OF_SCREEN.height-125, Screen_width, 125);
    }];
    
    CGFloat startY = 0;
    UIView *shareActionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SIZE_OF_SCREEN.width, 130)];
    shareActionView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:shareActionView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SIZE_OF_SCREEN.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    label.text = @"分享到";
    label.font = [UIFont systemFontOfSize:16];
    [shareActionView addSubview:label];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SIZE_OF_SCREEN.width-20, 10)];
//    lineView.backgroundColor = [UIColor whiteColor];
//    [backView addSubview:lineView];
//    
//    UIView *twoLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, SIZE_OF_SCREEN.width-20, 10)];
//    twoLineView.backgroundColor = [UIColor whiteColor];
//    [backView addSubview:twoLineView];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.frame = CGRectMake(0, 140, SIZE_OF_SCREEN.width-20, 40);
//    button.backgroundColor = [UIColor whiteColor];
//    [button setTitle:@"取消" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 5.f;
//    [button addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:button];
//    CGFloat start = (Screen_width - 42*4 - 20*(4-1))/2;

    for ( int i = 0; i < iconList.count; i ++ ) {
        VerticalUIButton *tempButton;
        UIImage *img = [UIImage imageNamed: iconList[i]];
        
        int row = i / numbersOfItemInLine;
        int col = i % numbersOfItemInLine;
        
        CGFloat x =  ((Screen_width-70*4)/4)+((70.0 + (Screen_width-70*4)/4)) * col;
        
        
        CGFloat y = startY  + (60.0 + 20) * row + 20;
        
        tempButton = [[VerticalUIButton alloc] initWithFrame:CGRectMake(x, 30+y, 60.0, 60.0)];
        tempButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [tempButton setImage:img forState:UIControlStateNormal];
        [tempButton setTitle:textList[i] forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1] forState:UIControlStateNormal];
        [tempButton addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if([textList[i] isEqualToString:NSLocalizedString(@"微信", nil)]){
            tempButton.tag = SHARE_ITEM_WEIXIN_SESSION;
        }else if([textList[i] isEqualToString:NSLocalizedString(@"朋友圈", nil)]){
            tempButton.tag = SHARE_ITEM_WEIXIN_TIMELINE;
        }else if([textList[i] isEqualToString:NSLocalizedString(@"QQ", nil)]){
            tempButton.tag = SHARE_ITEM_QQ;
        }else if([textList[i] isEqualToString:NSLocalizedString(@"QQ空间", nil)]){
            tempButton.tag = SHARE_ITEM_QZONE;
        }else if([textList[i] isEqualToString:NSLocalizedString(@"微博", nil)]){
            tempButton.tag = SHARE_ITEM_WEIBO;
        }
        
        [shareActionView addSubview:tempButton];
    }
}

#pragma mark - 初始化数据
- (void)configureData {
    iconList = [[NSMutableArray alloc] init];
    textList = [[NSMutableArray alloc] init];
    
    [iconList addObject:@"wechat"];
    [textList addObject:NSLocalizedString(@"微信", nil)];
    
    [iconList addObject:@"pengyouquan"];
//    [iconList addObject:@"weixin"];
    [textList addObject:NSLocalizedString(@"朋友圈", nil)];
    
    [iconList addObject:@"share_weibo"];
    [textList addObject:NSLocalizedString(@"微博", nil)];

    [iconList addObject:@"qzone"];
    [textList addObject:NSLocalizedString(@"QQ空间", nil)];

//    [textList addObject:NSLocalizedString(@"QQ", nil)];
    
//    [iconList addObject:@"icon_share_qzone@2x"];
}

//点击事件
- (void)clickActionButton:(VerticalUIButton *)sender {
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    BOOL hadInstalledWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]];
    
    if ( sender.tag == SHARE_ITEM_WEIXIN_SESSION ) {//微信
        if(hadInstalledWeixin){
            [self shareToWeixinSession];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil) message:NSLocalizedString(@"手机未安装相关应用", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if ( sender.tag == SHARE_ITEM_WEIXIN_TIMELINE ) {//微信朋友圈
        if(hadInstalledWeixin){
            [self shareToWeixinTimeline];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil) message:NSLocalizedString(@"手机未安装相关应用", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if ( sender.tag == SHARE_ITEM_QQ ) {//QQ
        if (hadInstalledQQ) {
            [self shareToQQ];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil) message:NSLocalizedString(@"手机未安装相关应用", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if ( sender.tag == SHARE_ITEM_QZONE ) {//QQ空间
        [self shareToQzone];
    }else if ( sender.tag == SHARE_ITEM_WEIBO ) {//微博
        if (hadInstalledWeibo) {
            [self shareToWeibo];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil) message:NSLocalizedString(@"手机未安装相关应用", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    
    [self clickClose];
}

- (void)shareToWeixinSession {
    XMShareWechatUtil *util = [XMShareWechatUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    
    [util shareToWeixinSession];
}

- (void)shareToWeixinTimeline {
    XMShareWechatUtil *util = [XMShareWechatUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    
    [util shareToWeixinTimeline];
}

- (void)shareToQQ {
    XMShareQQUtil *util = [XMShareQQUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    
    [util shareToQQ];
}

- (void)shareToQzone {
    XMShareQQUtil *util = [XMShareQQUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    
    [util shareToQzone];
}

- (void)shareToWeibo {
    XMShareWeiboUtil *util = [XMShareWeiboUtil sharedInstance];
    util.shareTitle = self.shareTitle;
    util.shareText = self.shareText;
    util.shareUrl = self.shareUrl;
    
    [util shareToWeibo];
}


- (void)clickClose {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationRemoveShareView" object:nil];
    }];
}


@end
