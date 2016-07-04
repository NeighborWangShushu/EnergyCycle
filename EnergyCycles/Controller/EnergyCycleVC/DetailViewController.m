//
//  DetailViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DetailViewController.h"

#import "PingLunViewCell.h"
#import "XMShareView.h"

#import "EnergyDetailModel.h"
#import "TheAdvDetailModel.h"
#import "NSDate+Category.h"

static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";
// 用于UIWebView保存图片
enum
{
    GESTURE_STATE_NONE = 0,
    GESTURE_STATE_START = 1,
    GESTURE_STATE_MOVE = 2,
    GESTURE_STATE_END = 4,
    GESTURE_STATE_ACTION = (GESTURE_STATE_START | GESTURE_STATE_END),
};
@interface DetailViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIWebViewDelegate,UIActionSheetDelegate> {
    NSMutableArray *_allArr;
    NSMutableArray *_dataArr;
    NSMutableArray *_otherDataArr;
    
    UIView *inputBackView;
    UITextField *inputTextField;
    
    XMShareView *shareView;
    UIActivityIndicatorView *_activityView;
    NSMutableDictionary *postDict;
    CGFloat subHight;
    UIView *headBackView;
    
    NSString *loadStr;
    
    NSTimer *_timer;	// 用于UIWebView保存图片
    int _gesState;	  // 用于UIWebView保存图片
    NSString *_imgURL;  // 用于UIWebView保存图片
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.view.backgroundColor = [UIColor whiteColor];
    _allArr = [[NSMutableArray alloc] init];
    _dataArr = [[NSMutableArray alloc] init];
    _otherDataArr = [[NSMutableArray alloc] init];
    
    postDict = [[NSMutableDictionary alloc] init];
    
    self.title = @"能量圈";
    if ([self.tabBarStr isEqualToString:@"pk"]) {
        self.title = @"进阶PK详情";
    }
    
    detailTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    detailTabelView.showsVerticalScrollIndicator = NO;
    detailTabelView.backgroundColor = [UIColor whiteColor];
    
    //创建输入框
    [self creatInputTextFieldView];
    
    //
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerWillFullscreen:) name:UIWindowDidBecomeVisibleNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerWillExitFullscreen:) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    //增加消息中心,移除分享界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShareView:) name:@"NotificationRemoveShareView" object:nil];
    
    //加载网页
    detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 80)];
    detailWebView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    detailWebView.delegate = self;
    if ([self.tabBarStr isEqualToString:@"pk"]) {
        loadStr = [NSString stringWithFormat:@"%@/%@?postId=%@&userId=%@",INTERFACE_URL,PostDetailAspx,self.showDetailId,User_ID];
        [detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadStr]]];
    }else {
        loadStr = [NSString stringWithFormat:@"%@/%@?artId=%@&userId=%@",INTERFACE_URL,ArticleDetailAspx,self.showDetailId,User_ID];
        [detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadStr]]];
    }
    
    detailWebView.allowsInlineMediaPlayback = YES;
    detailWebView.mediaPlaybackRequiresUserAction = NO;
    detailWebView.scrollView.scrollEnabled=NO;
    
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 创建右按键
- (void)creatButton {
    NSArray *rightImageArr = @[@"fenxiang_.png",@"50zan_.png"];
    NSMutableArray *itemBtnArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<rightImageArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 28, 28);
        [button setBackgroundImage:[[UIImage imageNamed:rightImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        if (_allArr.count && i==1) {
            TheAdvDetailModel *model = (TheAdvDetailModel *)_allArr[0];
            if ([model.isHasLike integerValue] == 0) {
                [button setBackgroundImage:[UIImage imageNamed:@"50zan_.png"] forState:UIControlStateNormal];
            }else {
                [button setBackgroundImage:[UIImage imageNamed:@"32xin02_.png"] forState:UIControlStateNormal];
            }
        }
        
        button.tag = 1001 + i;
        [button addTarget:self action:@selector(detailRightActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        [itemBtnArr addObject:item];
    }
    self.navigationItem.rightBarButtonItems = itemBtnArr;
}

#pragma mark - 键盘事件
- (void)keyboardWillShow:(NSNotification *)notif {
    NSDictionary *userInfo = [notif userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (!EnetgyCycle.isEnterLoginView) {
        inputBackView.alpha = 1;
        inputBackView.frame = CGRectMake(0, Screen_Height-keyboardEndFrame.size.height-46, Screen_width, 46);
    }
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    inputBackView.alpha = 0;
    inputBackView.frame = CGRectMake(0, Screen_Height, Screen_width, 46);
    
    [UIView commitAnimations];
}

#pragma mark - 加载动画
- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        UIActivityIndicatorView *indicator =[[UIActivityIndicatorView alloc] init];
        indicator.tag = 10000;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityView =indicator;
        indicator.center =self.view.center;
        
        [self.view addSubview:indicator];
    }
    return _activityView;
}

#pragma mark - webView
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self activityView];
    [_activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityView stopAnimating];
    
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = CGRectMake(frame.origin.x, frame.origin.y, Screen_width, frame.size.height);
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    CGRect rect = detailWebView.frame;
    rect.size.height = height+80;
    detailWebView.frame = rect;
    
    deatilWabBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 80+height)];
    detailTabelView.tableHeaderView = deatilWabBackView;
    [deatilWabBackView addSubview:detailWebView];
    
    subHight = height+80;
    if ([self.tabBarStr isEqualToString:@"pk"]) {
        [self getAdvPKDetailWithAtiticleId:self.showDetailId];
    }else {
        [self getEnergyDetailDataWithArticleID:self.showDetailId];
    }
    
    deatilWabBackView.userInteractionEnabled = YES;
    if (!([self.videoUrl isKindOfClass:[NSNull class]] || [self.videoUrl isEqual:[NSNull null]] || self.videoUrl == nil || [self.videoUrl length] <= 0 || [self.videoUrl isEqualToString:@"(null)"])) {
        UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeSystem];
        videoButton.frame = CGRectMake(Screen_width-100, height+45, 88, 30);
        [videoButton setTitle:@"查看视频" forState:UIControlStateNormal];
        [videoButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        
        videoButton.layer.masksToBounds = YES;
        videoButton.layer.cornerRadius = 4.f;
        videoButton.layer.borderWidth = 1.f;
        videoButton.layer.borderColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1].CGColor;
        [videoButton addTarget:self action:@selector(videoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [deatilWabBackView addSubview:videoButton];
    }
    
    // 防止内存泄漏
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    // 响应touch事件，以及获得点击的坐标位置，用于保存图片
    [detailWebView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
}
// 功能：UIWebView响应长按事件
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[_request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                _gesState = GESTURE_STATE_START;
                NSLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [detailWebView stringByEvaluatingJavaScriptFromString:js];
                _imgURL = nil;
                if ([tagName isEqualToString:@"IMG"]) {
                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                }
                if (_imgURL&&(!_timer)) {
                    _timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                }

//                NSString *path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"txt"];
//                NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//                [detailWebView stringByEvaluatingJavaScriptFromString: jsCode];
//                NSString *tags = [detailWebView stringByEvaluatingJavaScriptFromString:
//                                  [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(int)ptX,(int)ptY]];
//                if ([tags rangeOfString:@",A,"].location != NSNotFound) {
//                    
//                }
//                
//                if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
//                    NSString *str = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
//                    _imgURL = [detailWebView stringByEvaluatingJavaScriptFromString: str];
//                    NSLog(@"启动一个request下载图片:%@",_imgURL);
//                    _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
//                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                [_timer invalidate];
                _timer = nil;
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                _gesState = GESTURE_STATE_MOVE;
                NSLog(@"you are move");
            }
        }
        else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
            [_timer invalidate];
            _timer = nil;
            _gesState = GESTURE_STATE_END;
            NSLog(@"touch end");
        }
        return NO;
    }
    return YES;
}

// 功能：如果点击的是图片，并且按住的时间超过1s，执行handleLongTouch函数，处理图片的保存操作。
- (void)handleLongTouch {
    if (_imgURL && _gesState == GESTURE_STATE_START) {
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}
// 功能：保存图片到手机
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [_timer invalidate];
    _timer = nil;
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存到手机"]) {
        NSString *urlToSave = [detailWebView stringByEvaluatingJavaScriptFromString:_imgURL];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
        UIImage* image = [UIImage imageWithData:data];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
// 功能：显示对话框
-(void)showAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}
// 功能：显示图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        [self showAlert:@"保存失败..."];
    }else {
        [self showAlert:@"保存成功！"];
    }
}
#pragma mark - 植入webview长按图片保存------end-------

//跳转视频
- (void)videoButtonClick {
    if ([self.videoUrl hasPrefix:@"http://"] || [self.videoUrl hasPrefix:@"https://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.videoUrl]];
    }else {
        [SVProgressHUD showImage:nil status:@"视频链接出错了"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
}

//视频全屏的捕捉事件
-(void)playerWillFullscreen:(NSNotification *)notification{
    [UIApplication sharedApplication].statusBarHidden=YES;
    self.navigationController.navigationBarHidden=YES;
}

//视频离开的捕捉事件
-(void)playerWillExitFullscreen:(NSNotification *)notification{
    [UIApplication sharedApplication].statusBarHidden=NO;
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
    self.navigationController.navigationBar.transform = CGAffineTransformMakeRotation(0);
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, Screen_width, 44);
}

#pragma mark - 创建输入框
- (void)creatInputTextFieldView {
    inputBackView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_width, 46)];
    inputBackView.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:248/255.0 alpha:1];
    [[UIApplication sharedApplication].keyWindow addSubview:inputBackView];
    inputBackView.alpha = 0;
    
    inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 8, Screen_width-30, 30)];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    inputTextField.placeholder = @"评论";
    inputTextField.delegate = self;
    [inputTextField addTarget:self action:@selector(textFieldDidValueEndEditing:) forControlEvents:UIControlEventEditingChanged];
    
    inputTextField.returnKeyType = UIReturnKeySend;
    [inputBackView addSubview:inputTextField];
}

#pragma mark - 获取能量圈文章详情
- (void)getEnergyDetailDataWithArticleID:(NSString *)articleId {
    [[AppHttpManager shareInstance] getGetArticleInfoByIdWithArticleId:articleId userId:[User_ID intValue] token:User_TOKEN PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [_dataArr removeAllObjects];
            [_otherDataArr removeAllObjects];
            
            [_allArr removeAllObjects];
            EnergyDetailModel *model = [[EnergyDetailModel alloc] initWithDictionary:dict[@"Data"] error:nil];
            [_allArr addObject:model];
            [self creatTableViewHeadOrFootView];
            
            //获取一级评论
            for (NSDictionary *subDict in dict[@"Data"][@"commentList"]) {
                if ([subDict[@"pId"] integerValue] == 0) {
                    EnergyDetailModel *subModel = [[EnergyDetailModel alloc] initWithDictionary:subDict error:nil];
                    [_dataArr addObject:subModel];
                }
            }
            
            //根据一级评论 获取二级评论
            if (_dataArr.count) {
                for (NSInteger i=0; i<_dataArr.count; i++) {
                    EnergyDetailModel *subMModel = (EnergyDetailModel *)_dataArr[i];
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *subSubDict in model.commentList) {
                        if ([subMModel.commId integerValue] == [subSubDict[@"pId"] integerValue]) {
                            EnergyDetailModel *subSubModel = [[EnergyDetailModel alloc] initWithDictionary:subSubDict error:nil];
                            [subArr addObject:subSubModel];
                        }
                    }
                    [_otherDataArr addObject:subArr];
                }
            }
            
            [detailTabelView reloadData];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [_activityView stopAnimating];
    }];
}

#pragma mark - 获取进阶PK详情
- (void)getAdvPKDetailWithAtiticleId:(NSString *)ariticleId {
    [[AppHttpManager shareInstance] getGetPostInfoByIdWithUserId:[User_ID intValue] Token:User_TOKEN PostId:[ariticleId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [_dataArr removeAllObjects];
            [_otherDataArr removeAllObjects];
            
            [_allArr removeAllObjects];
            TheAdvDetailModel *model = [[TheAdvDetailModel alloc] initWithDictionary:dict[@"Data"] error:nil];
            [_allArr addObject:model];
            [self creatButton];
            [self creatTableViewHeadOrFootView];
            
            //获取一级评论
            for (NSDictionary *subDict in dict[@"Data"][@"commentOfPost"]) {
                if ([subDict[@"pId"] integerValue] == 0) {
                    TheAdvDetailModel *subModel = [[TheAdvDetailModel alloc] initWithDictionary:subDict error:nil];
                    [_dataArr addObject:subModel];
                }
            }
            
            //根据一级评论 获取二级评论
            if (_dataArr.count) {
                for (NSInteger i=0; i<_dataArr.count; i++) {
                    TheAdvDetailModel *subMModel = (TheAdvDetailModel *)_dataArr[i];
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *subSubDict in model.commentOfPost) {
                        if ([subMModel.commId integerValue] == [subSubDict[@"pId"] integerValue]) {
                            EnergyDetailModel *subSubModel = [[EnergyDetailModel alloc] initWithDictionary:subSubDict error:nil];
                            [subArr addObject:subSubModel];
                        }
                    }
                    [_otherDataArr addObject:subArr];
                }
            }
            
            [detailTabelView reloadData];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [_activityView stopAnimating];
    }];
}

#pragma mark - 创建头视图
- (void)creatTableViewHeadOrFootView {
    if (headBackView) {
        [headBackView removeFromSuperview];
        headBackView = nil;
    }
    
    TheAdvDetailModel *advModel = (TheAdvDetailModel *)_allArr[0];
    headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, subHight-40, Screen_width-100, 40)];
    
    //创建尾视图
    UIView *footBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 40)];
    footBackView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [footBackView addSubview:lineView];
    
    NSArray *imageArr = @[@"zan_normal.png",@"cai_normal.png",@"pinglun_normal.png"];
    NSArray *titleArr = @[@"赞",@"踩",@"评论"];
    if ([self.tabBarStr isEqualToString:@"pk"]) {
        imageArr = @[@"48zongpiao_.png",@"7xinzheng_.png",@"6pinglun_.png"];
    }
    
    //
    UIButton *zanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    zanButton.frame = CGRectMake(0, 0, Screen_width/3, 40);
    zanButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [zanButton setTitle:titleArr[0] forState:UIControlStateNormal];
    if ([self.tabBarStr isEqualToString:@"pk"]) {
        [zanButton setTitle:[NSString stringWithFormat:@"%@总票",advModel.hits] forState:UIControlStateNormal];
    }
    [zanButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    zanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    zanButton.tag = 1301;
    [zanButton addTarget:self action:@selector(tableViewFootButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footBackView addSubview:zanButton];
    //
    UIButton *caiButton = [UIButton buttonWithType:UIButtonTypeSystem];
    caiButton.frame = CGRectMake(Screen_width/3, 0, Screen_width/3, 40);
    caiButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [caiButton setTitle:titleArr[1] forState:UIControlStateNormal];
    if ([self.tabBarStr isEqualToString:@"pk"]) {
        [caiButton setTitle:[NSString stringWithFormat:@"%@新增",advModel.daysHits] forState:UIControlStateNormal];
    }
    [caiButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    caiButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    caiButton.tag = 1302;
    [caiButton addTarget:self action:@selector(tableViewFootButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footBackView addSubview:caiButton];
    //
    UIButton *comButton = [UIButton buttonWithType:UIButtonTypeSystem];
    comButton.frame = CGRectMake(Screen_width/3*2, 0, Screen_width/3, 40);
    [comButton setImage:[[UIImage imageNamed:imageArr[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    comButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [comButton setTitle:titleArr[2] forState:UIControlStateNormal];
    if ([self.tabBarStr isEqualToString:@"pk"]) {
        [comButton setTitle:advModel.commNum forState:UIControlStateNormal];
    }
    [comButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    comButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    comButton.tag = 1303;
    [comButton addTarget:self action:@selector(tableViewFootButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footBackView addSubview:comButton];
    detailTabelView.tableFooterView = footBackView;
    
    if (![self.tabBarStr isEqualToString:@"pk"]) {
        EnergyDetailModel *model = (EnergyDetailModel *)_allArr[0];
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, Screen_width-124, 17)];
        headLabel.font = [UIFont systemFontOfSize:12];
        headLabel.text = [NSString stringWithFormat:@"%@个赞 %@个踩 %@条评论",model.likeNum,model.noLikeNum,model.commentNum];
        headLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [headBackView addSubview:headLabel];
        [deatilWabBackView addSubview:headBackView];
        
        if ([model.isHasLike integerValue] == 0) {
            [zanButton setImage:[[UIImage imageNamed:imageArr[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }else {
            [zanButton setImage:[[UIImage imageNamed:@"zan_pressed.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            caiButton.userInteractionEnabled = NO;
        }
        
        if ([model.isHasNoLike integerValue] == 0) {
            [caiButton setImage:[[UIImage imageNamed:imageArr[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }else {
            [caiButton setImage:[[UIImage imageNamed:@"cai_pressed.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            zanButton.userInteractionEnabled = NO;
        }
    }
}


#pragma mark - 尾视图按键点击事件
- (void)tableViewFootButtonClick:(UIButton *)button {
    if ([self.tabBarStr isEqualToString:@"pk"]) {
        if (button.tag == 1303) {//评论
            if ([User_TOKEN length] <= 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
            }else {
                [postDict setObject:@"0" forKey:@"type"];
                [inputTextField becomeFirstResponder];
            }
        }
    }else {
        EnergyDetailModel *model = (EnergyDetailModel *)_allArr[0];
        if (button.tag == 1301) {//赞
            if ([model.isHasLike integerValue] == 0) {
                [self zanOrCaiButtonWithType:@"1" withOType:@"0"];//赞
            }else {
                [self zanOrCaiButtonWithType:@"1" withOType:@"1"];//取消赞
            }
        }else if (button.tag == 1302) {//踩
            if ([model.isHasNoLike integerValue] == 0) {
                [self zanOrCaiButtonWithType:@"2" withOType:@"0"];//踩
            }else {
                [self zanOrCaiButtonWithType:@"2" withOType:@"1"];//取消踩
            }
        }else {//评论
            if ([User_TOKEN length] <= 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
            }else {
                [postDict setObject:@"0" forKey:@"type"];
                [inputTextField becomeFirstResponder];
            }
        }
    }
}

#pragma mark - 赞和踩点击响应事件
- (void)zanOrCaiButtonWithType:(NSString *)type withOType:(NSString *)oType {
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [[AppHttpManager shareInstance] postAddLikeOrNoLikeWithType:type OpeType:oType ArticleId:[self.showDetailId intValue] UserId:[User_ID intValue] token:User_TOKEN PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                EnergyDetailModel *model = (EnergyDetailModel *)_allArr[0];
                
                if ([type isEqualToString:@"1"]) {//赞
                    if ([model.isHasLike integerValue] == 0) {
                        model.isHasLike = @"1";
                        model.likeNum = [NSString stringWithFormat:@"%ld",(long)[model.likeNum integerValue] + 1];
                    }else {
                        model.isHasLike = @"0";
                        model.likeNum = [NSString stringWithFormat:@"%ld",(long)([model.likeNum integerValue] - 1)>0?((long)[model.likeNum integerValue] - 1):0];
                    }
                    
                    NSDictionary *notifiDict = @{@"type":@"1",@"index":@(self.touchIndex)};
                    if ([self.isMine isEqualToString:@"1"]) {//我的能量圈
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"isMineEnergyCycleDetailChange" object:notifiDict];
                    }else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"isEnergyCycleDetailChange" object:notifiDict];
                    }
                }else {//踩
                    if ([model.isHasNoLike integerValue] == 0) {
                        model.isHasNoLike = @"1";
                        model.noLikeNum = [NSString stringWithFormat:@"%ld",(long)[model.noLikeNum integerValue] + 1];
                    }else {
                        model.isHasNoLike = @"0";
                        model.noLikeNum = [NSString stringWithFormat:@"%ld",(long)([model.noLikeNum integerValue] - 1)>0?((long)[model.noLikeNum integerValue] - 1):0];
                    }
                    NSDictionary *notifiDict = @{@"type":@"2",@"index":@(self.touchIndex)};
                    if ([self.isMine isEqualToString:@"1"]) {//我的能量圈
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"isMineEnergyCycleDetailChange" object:notifiDict];
                    }else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"isEnergyCycleDetailChange" object:notifiDict];
                    }
                }
                
                [_allArr removeAllObjects];
                [_allArr addObject:model];
                
                [self creatTableViewHeadOrFootView];
            }else if ([dict[@"Code"] integerValue] == 10000) {
                [SVProgressHUD showImage:nil status:@"登录失效"];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }
}

#pragma mark - 实现UITextField协议方法
- (void)textFieldDidValueEndEditing:(UITextField *)textField {
    NSString *content = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [postDict setObject:content forKey:@"content"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([postDict[@"content"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入评论内容"];
    }else {
        [textField resignFirstResponder];
        inputBackView.alpha = 0;
        
        if ([self.tabBarStr isEqualToString:@"pk"]) {
            [self advPKCommentWithContentWithDict:postDict];
        }else {
            [self commentWithContentWithDict:postDict];
        }
        
        textField.text = nil;
    }
    
    return YES;
}

#pragma mark - 能量圈评论
- (void)commentWithContentWithDict:(NSDictionary *)getDict {
    EnergyDetailModel *model = (EnergyDetailModel *)_allArr[0];
    [[AppHttpManager shareInstance] postAddCommentOfArticleWithArticleId:[model.artId intValue] PId:[getDict[@"type"] intValue] Content:getDict[@"content"] CommUserId:[User_ID intValue] token:User_TOKEN PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self getEnergyDetailDataWithArticleID:self.showDetailId];
            
            if ([getDict[@"type"] integerValue] == 0) {
                NSDictionary *notifiDict = @{@"type":@"3",@"index":@(self.touchIndex)};
                if ([self.isMine isEqualToString:@"1"]) {//我的能量圈
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isMineEnergyCycleDetailChange" object:notifiDict];
                }else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isEnergyCycleDetailChange" object:notifiDict];
                }
            }
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 进阶PK评论
- (void)advPKCommentWithContentWithDict:(NSDictionary *)getDict {
    TheAdvDetailModel *model = (TheAdvDetailModel *)_allArr[0];
    [[AppHttpManager shareInstance] getAddCommentOfPostWithId:[model.postId intValue] pId:[getDict[@"type"] intValue] content:getDict[@"content"] commUserId:[User_ID intValue] Token:User_TOKEN PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self getAdvPKDetailWithAtiticleId:self.showDetailId];
            if ([getDict[@"type"] integerValue] == 0) {
                NSDictionary *notifiDict = @{@"type":@"3",@"index":@(self.touchIndex)};
                if ([self.isMine isEqualToString:@"1"]) {//我的进阶PK
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isMineTheAdvDetailChange" object:notifiDict];
                }else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"isTheAdvDetailChange" object:notifiDict];
                }
            }
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_otherDataArr.count) {
        return [_otherDataArr[section] count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_otherDataArr.count) {
        EnergyDetailModel *model = (EnergyDetailModel *)_otherDataArr[indexPath.section][indexPath.row];
        if (indexPath.row == [_otherDataArr[indexPath.section] count]-1) {
            return [self textHeightFromTextString:[model.commContent stringByRemovingPercentEncoding] width:Screen_width-80 fontSize:14]+72;
        }
        return [self textHeightFromTextString:[model.commContent stringByRemovingPercentEncoding] width:Screen_width-80 fontSize:14]+70;
    }
    return 0.f;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PingLunViewCellId = @"PingLunViewCellId";
    PingLunViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PingLunViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PingLunViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_otherDataArr.count) {
        cell.backViewBootmAutoLayout.constant = 0.f;
        EnergyDetailModel *model = (EnergyDetailModel *)_otherDataArr[indexPath.section][indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.commPhotoUrl]] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
        cell.nameLabel.text = model.commNickName;
        cell.neirongLabel.text = [model.commContent stringByRemovingPercentEncoding];
        
        NSString *dateString = model.commTime;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *nowDate = [dateFormatter dateFromString:dateString];
        
        NSInteger min = [nowDate minutesBeforeDate:[NSDate date]];
        if (min >= 60) {
            NSInteger hour = [nowDate hoursBeforeDate:[NSDate date]];
            if (hour >= 24) {
                NSArray *timeArr = [model.commTime componentsSeparatedByString:@" "];
                cell.timeLabel.text = timeArr.firstObject;
            }else {
                cell.timeLabel.text = [NSString stringWithFormat:@"%ld小时前",(long)hour];
            }
        }else {
            if (min == 0) {
                min = 1;
            }
            cell.timeLabel.text = [NSString stringWithFormat:@"%ld分钟前",(long)min];
        }
        if (indexPath.row == [_otherDataArr[indexPath.section] count]-1) {
            cell.backViewBootmAutoLayout.constant = 10.f;
        }
    }
    
    return cell;
}
//分区头视图
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_dataArr.count) {
        EnergyDetailModel *model = (EnergyDetailModel *)_dataArr[section];
        return [self textHeightFromTextString:[model.commContent stringByRemovingPercentEncoding] width:Screen_width-62-58 fontSize:14]+60;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_dataArr.count) {
        EnergyDetailModel *model = (EnergyDetailModel *)_dataArr[section];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 100.f)];
        backView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        [backView addSubview:lineView];
        
        //
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 40, 40)];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 20.f;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.commPhotoUrl]] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
        [backView addSubview:imageView];
        
        //
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(62, 12, Screen_width-172, 20)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = model.commNickName;
        label.textColor = [UIColor blackColor];
        [backView addSubview:label];
        
        //
        UILabel *louLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_width-112, 12, 100, 20)];
        louLabel.font = [UIFont systemFontOfSize:14];
        louLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        louLabel.text = [NSString stringWithFormat:@"%ld楼",(long)section+1];
        louLabel.textAlignment = NSTextAlignmentRight;
        [backView addSubview:louLabel];
        
        //
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 33, Screen_width-172, 20)];
        timeLabel.font = [UIFont systemFontOfSize:11];
        NSString *dateString = model.commTime;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *nowDate = [dateFormatter dateFromString:dateString];
        
        NSInteger min = [nowDate minutesBeforeDate:[NSDate date]];
        if (min >= 60) {
            NSInteger hour = [nowDate hoursBeforeDate:[NSDate date]];
            if (hour >= 24) {
                NSArray *timeArr = [model.commTime componentsSeparatedByString:@" "];
                timeLabel.text = timeArr.firstObject;
            }else {
                timeLabel.text = [NSString stringWithFormat:@"%ld小时前",(long)hour];
            }
        }else {
            if (min == 0) {
                min = 1;
            }
            timeLabel.text = [NSString stringWithFormat:@"%ld分钟前",(long)min];
        }
        timeLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [backView addSubview:timeLabel];
        
        //
        CGFloat hight = [self textHeightFromTextString:[model.commContent stringByRemovingPercentEncoding] width:Screen_width-62-58 fontSize:14];
        UILabel *pinglunLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 53, Screen_width-62-58, hight)];
        pinglunLabel.font = [UIFont systemFontOfSize:14];
        pinglunLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        pinglunLabel.text = [model.commContent stringByRemovingPercentEncoding];
        pinglunLabel.numberOfLines = 0;
        [backView addSubview:pinglunLabel];
        
        //
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(Screen_width-60, 48, 58, 30);
        [button setImage:[[UIImage imageNamed:@"pinglun_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        button.tag = 1311 + [model.commId integerValue];
        [button addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];  
        
        return backView;

    }
    return nil;
}

#pragma mark -
- (void)headButtonClick:(UIButton *)button {
    if ([User_TOKEN isKindOfClass:[NSNull class]] || [User_TOKEN isEqual:[NSNull null]] || User_TOKEN == nil || [User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [postDict setObject:[NSString stringWithFormat:@"%ld",(long)button.tag-1311] forKey:@"type"];
        [inputTextField becomeFirstResponder];
    }
}

//分区尾视图
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 右按键响应事件
- (void)detailRightActionWithBtn:(UIButton *)button {
    if (button.tag == 1001) {//分享
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"2" forKey:@"shareSuccessCallType"];

        shareView = [[XMShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
        shareView.alpha = 0.0;
        shareView.shareTitle = [self.advModel.title stringByRemovingPercentEncoding];
        shareView.shareText = [self.advModel.content stringByRemovingPercentEncoding];
        shareView.shareUrl = loadStr;
        
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        
        [UIView animateWithDuration:0.25 animations:^{
            shareView.alpha = 1.0;
        }];
    }else {//赞
        if ([User_TOKEN length] <= 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
        }else {
            TheAdvDetailModel *model = (TheAdvDetailModel *)_allArr[0];
            [[AppHttpManager shareInstance] getPKAddLikeOrNoLikeWithType:1 ArticleId:[model.postId intValue] UserId:User_ID Token:User_TOKEN PostOrGet:@"post" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                    if ([model.isHasLike integerValue] == 1) {
                        model.isHasLike = @"0";
                        [button setBackgroundImage:[UIImage imageNamed:@"50zan_.png"] forState:UIControlStateNormal];
                        [SVProgressHUD showImage:nil status:@"取消点赞成功"];
                    }else {
                        model.isHasLike = @"1";
                        [button setBackgroundImage:[UIImage imageNamed:@"32xin02_.png"] forState:UIControlStateNormal];
                        [SVProgressHUD showImage:nil status:@"点赞成功"];
                        
                        model.hits = [NSString stringWithFormat:@"%ld",(long)[model.hits integerValue] + 1];
                        model.daysHits = [NSString stringWithFormat:@"%ld",(long)[model.daysHits integerValue] + 1];
                        
                        NSDictionary *notifiDict = @{@"type":@"2",@"index":@(self.touchIndex)};
                        if ([self.isMine isEqualToString:@"1"]) {//我的进阶PK
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"isMineTheAdvDetailChange" object:notifiDict];
                        }else {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"isTheAdvDetailChange" object:notifiDict];
                        }
                    }
                    
                    [_allArr removeAllObjects];
                    [_allArr addObject:model];
                    
                    [self creatTableViewHeadOrFootView];
                }else if ([dict[@"Code"] integerValue] == 10000) {
                    [SVProgressHUD showImage:nil status:@"登录失效"];
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }else {
                    [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                }
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
        }
    }
}

//实现消息中心方法
- (void)removeShareView:(NSNotification *)notification {
    [shareView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
