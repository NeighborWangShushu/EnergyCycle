//
//  XMShareView.m
//  
//
//

#import "XMTwoShareView.h"

#import "VerticalUIButton.h"
#import "CommonMarco.h"
#import "XMShareWeiboUtil.h"
#import "XMShareWechatUtil.h"
#import "XMShareQQUtil.h"

//每行显示数量
static const NSInteger numbersOfItemInLine = 4;

@interface XMTwoShareView () {
    UILabel *titleLabel;
    NSInteger touchIndex;
}

@end

@implementation XMTwoShareView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.showTitle = title;
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
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, (SIZE_OF_SCREEN.height-259)/2, Screen_width-40, 259)];
    backView.backgroundColor = [UIColor whiteColor];
    ViewRadius(backView, 5);
    [self addSubview:backView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SIZE_OF_SCREEN.width-40, 26)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.showTitle;
    titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    titleLabel.font = [UIFont systemFontOfSize:19];
    [backView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SIZE_OF_SCREEN.width-40, 22)];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    subTitleLabel.text = @"晒记录，获取积分！";
    subTitleLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:subTitleLabel];
    
    CGFloat startY = 0;
    UIView *shareActionView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, SIZE_OF_SCREEN.width-40, 127)];
    shareActionView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:shareActionView];
    
    for ( int i = 0; i < iconList.count; i ++ ) {
        VerticalUIButton *tempButton;
        UIImage *img = [UIImage imageNamed: iconList[i] ];
        
        int row = i / numbersOfItemInLine;
        int col = i % numbersOfItemInLine;
        
        CGFloat x =  ((Screen_width-40-60*4)/4)+((60.0 + (Screen_width-40-60*4)/4)) * col;
        CGFloat y = startY  + (60.0 + 20) * row + 10;
        
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
    
    //
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 214, SIZE_OF_SCREEN.width-40, 1)];
    lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [backView addSubview:lineView];
    
    //
    NSArray *btnTitleArr = @[@"取消",@"确定"];
    for (NSInteger i=0; i<btnTitleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((SIZE_OF_SCREEN.width/2-20)*i, 215, SIZE_OF_SCREEN.width/2-20, 44);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        button.tag = 3001 + i;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
    }
    
    //
    UIView *twoLineView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_OF_SCREEN.width/2-19.5, 215, 1, 44)];
    twoLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [backView addSubview:twoLineView];
}

#pragma mark - 初始化数据
- (void)configureData {
    iconList = [[NSMutableArray alloc] init];
    textList = [[NSMutableArray alloc] init];
    
    [iconList addObject:@"weixin"];
    [textList addObject:NSLocalizedString(@"微信", nil)];
    
    [iconList addObject:@"pengyouquan"];
    [textList addObject:NSLocalizedString(@"朋友圈", nil)];
    
    [iconList addObject:@"weibo"];
    [textList addObject:NSLocalizedString(@"微博", nil)];
    
    [iconList addObject:@"qq"];
    [textList addObject:NSLocalizedString(@"QQ", nil)];
    
//    [iconList addObject:@"icon_share_qzone@2x"];
//    [textList addObject:NSLocalizedString(@"QQ空间", nil)];
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


- (void)buttonClick:(UIButton *)button {
    touchIndex = button.tag - 3001;
    [self clickClose];
}

- (void)clickClose {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationRemoveShareView" object:@{@"index":@(touchIndex)}];
    }];
}


@end
