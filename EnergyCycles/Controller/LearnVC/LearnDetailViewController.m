//
//  LearnDetailViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LearnDetailViewController.h"

#import "LearnDetailViewCell.h"
#import "PingLunViewCell.h"

#import "CourseTuiJianModel.h"
#import "LearnCommentModel.h"

#import "XMShareView.h"
#import "NSDate+Category.h"
#import "Masonry.h"

@interface LearnDetailViewController () <UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,UITextFieldDelegate,WKScriptMessageHandler,WKUIDelegate> {
    
    XMShareView *shareView;
    NSMutableArray *_tuiJDataArr;
    
    NSMutableArray *_allArr;
    NSMutableArray *_dataArr;
    NSMutableArray *_otherDataArr;
    
    UIActivityIndicatorView *_activityView;
    
    NSString *loadStr;
    NSMutableDictionary *postDict;
    
    UIView *inputBackView;
    UITextField *inputTextField;
    UIView *backView;
    
    //
    NSMutableArray *allInforArr;
    UIButton *commentButton;
    UIButton *caiButton;
    UIButton *zanButton;
    
    CGFloat subHeight;
}

@end

@implementation LearnDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学习详情";
    EnetgyCycle.energyTabBar.tabBar.translucent = NO;
    
    _tuiJDataArr  = [[NSMutableArray alloc] init];
    _allArr       = [[NSMutableArray alloc] init];
    _dataArr      = [[NSMutableArray alloc] init];
    _otherDataArr = [[NSMutableArray alloc] init];
    allInforArr   = [[NSMutableArray alloc] init];
    postDict      = [[NSMutableDictionary alloc] init];
    
    learnDetailTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    learnDetailTableView.showsHorizontalScrollIndicator = NO;
    learnDetailTableView.showsVerticalScrollIndicator   = NO;
    
    [self setupLeftNavBarWithimage:@"whiteback_normal.png"];
    
    //创建分享按键
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 25, 19);
    [button setBackgroundImage:[[UIImage imageNamed:@"share_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(detailRightActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [UIView setAnimationsEnabled:NO];
    
    
    //    NSString * jsstring = @" $(\"img\").on(\"taphold,\" function () {});";
    //    WKUserScript *script = [[WKUserScript alloc] initWithSource:jsstring injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
    
    
    //加载网页
    learnWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 80) configuration:config];
    learnWebView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    //    learnWebView.navigationDelegate = self;
    learnWebView.UIDelegate = self;
    [self.view addSubview:learnWebView];
    
    NSString * user_id = [[NSString stringWithFormat:@"%@",User_ID] isEqualToString:@""]?@"0":[NSString stringWithFormat:@"%@",User_ID];
    loadStr = [NSString stringWithFormat:@"%@/%@?id=%@&userId=%@",INTERFACE_URL,StudyDetailAspx,self.learnAtriID,user_id];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loadStr]];
    [learnWebView loadRequest:request];
    
    
    [learnWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-5);
    }];
    
    
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)leftAction {
    [UIView setAnimationsEnabled:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [learnWebView removeFromSuperview];
    learnWebView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    
    //    [self getAboutTuiJian];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"AppModel"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSLog(@"%@", message.body);
        
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    NSLog(@"%@", message);
    
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    
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

- (void)keyboardShow:(NSNotification *)notif {
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    inputBackView.alpha = 0;
    inputBackView.frame = CGRectMake(0, Screen_Height, Screen_width, 46);
    
    [UIView commitAnimations];
}

- (void)keyboardHide:(NSNotification *)notif {
    
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

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [_activityView stopAnimating];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = CGRectMake(frame.origin.x, frame.origin.y, Screen_width, frame.size.height);
    CGFloat height = Screen_Height;
    
    CGRect rect = learnWebView.frame;
    rect.size.height = height+40;
    learnWebView.frame = rect;
    
    //
    learnWabBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, height+50)];
    learnDetailTableView.tableHeaderView = learnWabBackView;
    [learnWabBackView addSubview:learnWebView];
    
    //    subHeight = height;
    //
    //    [self getZanOrCaiDataWithId:self.learnAtriID withHeight:subHeight];
}

#pragma mark -
- (void)tableViewButtonClick:(UIButton *)button {
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        if (button.tag == 3201) {//赞
            [self zanOrCaiButtonWithType:@"1"];
        }else if (button.tag == 3202) {//踩
            [self zanOrCaiButtonWithType:@"2"];
        }else {//评论
            [postDict setObject:@"0" forKey:@"type"];
            [inputTextField becomeFirstResponder];
        }
    }
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

#pragma mark - 实现UITextField协议方法
- (void)textFieldDidValueEndEditing:(UITextField *)textField {
    NSString *comment = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [postDict setObject:comment forKey:@"comment"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([postDict[@"comment"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入评论内容"];
    }else {
        [textField resignFirstResponder];
        inputBackView.alpha = 0;
        
        [self commentLearnDetailViewWithDict:postDict];
        textField.text = nil;
    }
    
    return YES;
}

#pragma mark - 获取相关推荐
- (void)getAboutTuiJian {
    [[AppHttpManager shareInstance] getGetAboutCourseListWithStudyType:self.courseType PostOrGet:@"get" success:^(NSDictionary *dict) {
        [_tuiJDataArr removeAllObjects];
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                CourseTuiJianModel *model = [[CourseTuiJianModel alloc] initWithDictionary:subDict error:nil];
                [_tuiJDataArr addObject:model];
            }
        }
        [learnDetailTableView reloadData];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 获取文章其他信息
- (void)getZanOrCaiDataWithId:(NSString *)articeId withHeight:(CGFloat)height {
    [[AppHttpManager shareInstance] getGetStudyInfoByIdWithUserId:[User_ID intValue] StudyId:[articeId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSArray *arr = [dict[@"Data"] componentsSeparatedByString:@","];
            for (NSInteger i=0; i<arr.count; i++) {
                [allInforArr addObject:arr[i]];
            }
            
            for (UIView *view in learnWabBackView.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [view removeFromSuperview];
                }
            }
            
            NSArray *imageArr = @[@"zan_normal.png",@"pinglun_normal.png"];
            NSArray *titleArr = @[@"赞",@"评论"];
            
            //赞
            zanButton = [UIButton buttonWithType:UIButtonTypeSystem];
            zanButton.frame = CGRectMake(Screen_width/2*0, height, Screen_width/2, 40);
            zanButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [zanButton setTitle:titleArr[0] forState:UIControlStateNormal];
            [zanButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            zanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            zanButton.tag = 3201;
            [zanButton addTarget:self action:@selector(tableViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [learnWabBackView addSubview:zanButton];
            //            //踩
            //            caiButton = [UIButton buttonWithType:UIButtonTypeSystem];
            //            caiButton.frame = CGRectMake(Screen_width/3*1, height, Screen_width/3, 40);
            //            caiButton.titleLabel.font = [UIFont systemFontOfSize:14];
            //            [caiButton setTitle:titleArr[1] forState:UIControlStateNormal];
            //            [caiButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            //            caiButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            //            caiButton.tag = 3201 + 1;
            //            [caiButton addTarget:self action:@selector(tableViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            //            [learnWabBackView addSubview:caiButton];
            //
            //            //评论
            commentButton = [UIButton buttonWithType:UIButtonTypeSystem];
            commentButton.frame = CGRectMake(Screen_width/2, height, Screen_width/2, 40);
            [commentButton setImage:[[UIImage imageNamed:imageArr[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [commentButton setTitle:titleArr[1] forState:UIControlStateNormal];
            [commentButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            commentButton.tag = 3201 + 2;
            [commentButton addTarget:self action:@selector(tableViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [learnWabBackView addSubview:commentButton];
            
            if ([arr[3] integerValue] == 0) {
                [zanButton setImage:[[UIImage imageNamed:imageArr[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }else {
                [zanButton setImage:[[UIImage imageNamed:@"zan_pressed.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                caiButton.userInteractionEnabled = NO;
            }
            
            if ([arr.lastObject integerValue] == 0) {
                [caiButton setImage:[[UIImage imageNamed:imageArr[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            }else {
                [caiButton setImage:[[UIImage imageNamed:@"cai_pressed.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                zanButton.userInteractionEnabled = NO;
            }
            
            [learnDetailTableView reloadData];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 获取评论数据
- (void)getPinLunListWithStudyId:(NSString *)studyId {
    [[AppHttpManager shareInstance] getGetStudyCommentListWithStudyId:[studyId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [_dataArr removeAllObjects];
            [_otherDataArr removeAllObjects];
            
            NSDictionary *notifiDict = @{@"type":@"4",@"index":@(self.touchIndex)};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isLearnDetailChange" object:notifiDict];
            
            //获取一级评论
            for (NSDictionary *subDict in dict[@"Data"]) {
                if ([subDict[@"pid"] integerValue] == 0) {
                    LearnCommentModel *subModel = [[LearnCommentModel alloc] initWithDictionary:subDict error:nil];
                    [_dataArr addObject:subModel];
                }
            }
            
            //根据一级评论 获取二级评论
            if (_dataArr.count) {
                for (NSInteger i=0; i<_dataArr.count; i++) {
                    LearnCommentModel *subMModel = (LearnCommentModel *)_dataArr[i];
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *subSubDict in dict[@"Data"]) {
                        if ([subMModel.commID integerValue] == [subSubDict[@"pid"] integerValue]) {
                            LearnCommentModel *subSubModel = [[LearnCommentModel alloc] initWithDictionary:subSubDict error:nil];
                            [subArr addObject:subSubModel];
                        }
                    }
                    [_otherDataArr addObject:subArr];
                }
            }
            
            [learnDetailTableView reloadData];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else if (section == _dataArr.count+1) {
        return _tuiJDataArr.count;
    }else {
        if (_dataArr.count) {
            return [_otherDataArr[section-1] count];
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40.f;
    }else if (indexPath.section == _dataArr.count+1) {
        return 60.f;
    }else {
        if (_otherDataArr.count) {
            LearnCommentModel *model = (LearnCommentModel *)_otherDataArr[indexPath.section-1][indexPath.row];
            if (indexPath.row == [_otherDataArr[indexPath.section-1] count]-1) {
                return [self textHeightFromTextString:[model.comment stringByRemovingPercentEncoding] width:Screen_width-80 fontSize:14]+72;
            }
            return [self textHeightFromTextString:[model.comment stringByRemovingPercentEncoding] width:Screen_width-80 fontSize:14]+70;
        }
        return 0.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == _dataArr.count+1) {
        static NSString *LearnDetailViewCellId = @"LearnDetailViewCellId";
        LearnDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LearnDetailViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"LearnDetailViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_tuiJDataArr.count) {
            CourseTuiJianModel *model = (CourseTuiJianModel *)_tuiJDataArr[indexPath.row];
            
            cell.titleLabel.text = model.title;
            cell.liulanLabel.text = model.readCount;
            
            cell.typeLabel.text = model.studyType;
            cell.typeLabel.textColor = [UIColor whiteColor];
            
            cell.typeLabel.backgroundColor = [UIColor orangeColor];
            cell.typeLabel.layer.masksToBounds = YES;
            cell.typeLabel.layer.cornerRadius = 2.f;
            
            CGRect rect = [model.studyType boundingRectWithSize:CGSizeMake(SIZE_MAX, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] context:nil];
            cell.typeLabelAutoLayout.constant = rect.size.width+10;
        }
        
        return cell;
    }
    
    static NSString *PingLunViewCellId = @"PingLunViewCellId";
    PingLunViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PingLunViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PingLunViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_otherDataArr.count) {
        cell.backViewBootmAutoLayout.constant = 0.f;
        LearnCommentModel *model = (LearnCommentModel *)_otherDataArr[indexPath.section-1][indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photourl]] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
        cell.nameLabel.text = model.nickname;
        cell.neirongLabel.text = [model.comment stringByRemovingPercentEncoding];
        
        NSArray *timeArr = [model.addtime componentsSeparatedByString:@"T"];
        NSArray *subTimeArr = [timeArr.lastObject componentsSeparatedByString:@"."];
        NSString *dateString = [NSString stringWithFormat:@"%@ %@",timeArr.firstObject,subTimeArr.firstObject];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *nowDate = [dateFormatter dateFromString:dateString];
        
        NSInteger min = [nowDate minutesBeforeDate:[NSDate date]];
        if (min >= 60) {
            NSInteger hour = [nowDate hoursBeforeDate:[NSDate date]];
            if (hour >= 24) {
                NSArray *timeArr = [model.addtime componentsSeparatedByString:@"T"];
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
        if (indexPath.row == [_otherDataArr[indexPath.section-1] count]-1) {
            cell.backViewBootmAutoLayout.constant = 10.f;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == _dataArr.count+1) {
        CourseTuiJianModel *model = (CourseTuiJianModel *)_tuiJDataArr[indexPath.row];
        LearnDetailViewController *learnDetailVC = MainStoryBoard(@"LearnDetailVCID");
        learnDetailVC.learnAtriID = model.courseId;
        learnDetailVC.courseType = model.studyType;
        learnDetailVC.learnTitle = model.title;
        learnDetailVC.learnContent = model.contents;
        
        [self.navigationController pushViewController:learnDetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.f;
    }else if (section == _dataArr.count+1) {//最后一个
        return 50.f;
    }
    
    if (_dataArr.count) {
        LearnCommentModel *model = (LearnCommentModel *)_dataArr[section-1];
        return [self textHeightFromTextString:[model.comment stringByRemovingPercentEncoding] width:Screen_width-62-58 fontSize:14]+60;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 40)];
        headBackView.backgroundColor = [UIColor whiteColor];
        
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, Screen_width-24, 17)];
        headLabel.font = [UIFont systemFontOfSize:12];
        if (allInforArr.count) {
            headLabel.text = [NSString stringWithFormat:@"%@个赞 %@个踩 %@条评论",allInforArr.firstObject,allInforArr[1],allInforArr[2]];
        }
        headLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [headBackView addSubview:headLabel];
        
        return headBackView;
    }else if (section == _dataArr.count + 1) {
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 50)];
        subView.backgroundColor = [UIColor whiteColor];
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 17, Screen_width-24, 20)];
        subLabel.font = [UIFont systemFontOfSize:16];
        subLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        subLabel.text = @"相关推荐";
        [subView addSubview:subLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, Screen_width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
        [subView addSubview:lineView];
        
        return subView;
    }else {
        if (_dataArr.count) {
            LearnCommentModel *model = (LearnCommentModel *)_dataArr[section-1];
            if (backView) {
                backView = nil;
            }
            
            backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 100.f)];
            backView.backgroundColor = [UIColor whiteColor];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
            [backView addSubview:lineView];
            
            //
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 40, 40)];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 20.f;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photourl]] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
            [backView addSubview:imageView];
            
            //
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(62, 12, Screen_width-172, 20)];
            label.font = [UIFont systemFontOfSize:16];
            label.text = model.nickname;
            label.textColor = [UIColor blackColor];
            [backView addSubview:label];
            
            //
            UILabel *louLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_width-112, 12, 100, 20)];
            louLabel.font = [UIFont systemFontOfSize:14];
            louLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            louLabel.text = [NSString stringWithFormat:@"%ld楼",(long)section];
            louLabel.textAlignment = NSTextAlignmentRight;
            [backView addSubview:louLabel];
            
            //
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 33, Screen_width-172, 20)];
            timeLabel.font = [UIFont systemFontOfSize:11];
            NSArray *timeArr = [model.addtime componentsSeparatedByString:@"T"];
            NSArray *subTimeArr = [timeArr.lastObject componentsSeparatedByString:@"."];
            NSString *dateString = [NSString stringWithFormat:@"%@ %@",timeArr.firstObject,subTimeArr.firstObject];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *nowDate = [dateFormatter dateFromString:dateString];
            
            NSInteger min = [nowDate minutesBeforeDate:[NSDate date]];
            if (min >= 60) {
                NSInteger hour = [nowDate hoursBeforeDate:[NSDate date]];
                if (hour >= 24) {
                    NSArray *timeArr = [model.addtime componentsSeparatedByString:@"T"];
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
            CGFloat hight = [self textHeightFromTextString:[model.comment stringByRemovingPercentEncoding] width:Screen_width-62-58 fontSize:14];
            UILabel *pinglunLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 53, Screen_width-62-58, hight)];
            pinglunLabel.font = [UIFont systemFontOfSize:14];
            pinglunLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            pinglunLabel.text = [model.comment stringByRemovingPercentEncoding];
            pinglunLabel.numberOfLines = 0;
            [backView addSubview:pinglunLabel];
            
            //
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(Screen_width-60, 48, 58, 30);
            [button setImage:[[UIImage imageNamed:@"pinglun_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            button.tag = 3401+section-1;
            [button addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:button];
            
            return backView;
        }
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }else if (section == _dataArr.count) {//最后二个
        return 10.f;
    }else if (section == _dataArr.count+1){//倒数第一个
        return 20.f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 10)];
    if (section == 2) {
        footView.frame = CGRectMake(0, 0, Screen_width, 20);
    }
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

#pragma mark - 评论按键
- (void)commentButtonClick:(UIButton *)button {
    LearnCommentModel *model = (LearnCommentModel *)_dataArr[button.tag - 3401];
    [postDict setObject:model.commID forKey:@"type"];
    [inputTextField becomeFirstResponder];
}

#pragma mark - 评论
- (void)commentLearnDetailViewWithDict:(NSMutableDictionary *)getDict {
    [[AppHttpManager shareInstance] getAddCommnetWithUserId:[User_ID intValue] StudyId:[self.learnAtriID intValue] Pid:[getDict[@"type"] intValue] Commnet:getDict[@"comment"] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self getPinLunListWithStudyId:self.learnAtriID];
            
            if ([getDict[@"type"] integerValue] == 0) {
                [allInforArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%ld",(long)[allInforArr[2] integerValue] +1]];
                
                NSDictionary *notifiDict = @{@"type":@"3",@"index":@(self.touchIndex)};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isLearnDetailChange" object:notifiDict];
            }
        }else if ([dict[@"Code"] integerValue] == 10000) {
            
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 赞、踩
- (void)zanOrCaiButtonWithType:(NSString *)type {
    //    1 赞 2 踩
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [self zanOrCaiWithType:[type intValue] artId:[self.learnAtriID intValue]];
    }
}

- (void)zanOrCaiWithType:(int)type artId:(int)artId {
    [[AppHttpManager shareInstance] getStudyAddLikeOrNoLikeWithType:type articleId:artId userId:[User_ID intValue] token:User_TOKEN PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
        }else {
            if (type == 1) {
                if ([allInforArr[3] integerValue] == 0) {
                    [allInforArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",(long)[allInforArr.firstObject integerValue]+1]];
                    
                    [allInforArr replaceObjectAtIndex:3 withObject:@"1"];
                    [zanButton setImage:[[UIImage imageNamed:@"zan_pressed.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                    caiButton.userInteractionEnabled = NO;
                }else {
                    if ([allInforArr[0] integerValue] -1 <= 0) {
                        [allInforArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",@"0"]];
                    }else {
                        [allInforArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",(long)[allInforArr.firstObject integerValue]-1]];
                    }
                    
                    [allInforArr replaceObjectAtIndex:3 withObject:@"0"];
                    [zanButton setImage:[[UIImage imageNamed:@"zan_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                    caiButton.userInteractionEnabled = YES;
                }
                NSDictionary *notifiDict = @{@"type":@"1",@"index":@(self.touchIndex)};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isLearnDetailChange" object:notifiDict];
            }else {
                if ([allInforArr.lastObject integerValue] == 0) {
                    [allInforArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%ld",(long)[allInforArr[1] integerValue]+1]];
                    
                    [allInforArr replaceObjectAtIndex:4 withObject:@"1"];
                    [caiButton setImage:[[UIImage imageNamed:@"cai_pressed.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                    zanButton.userInteractionEnabled = NO;
                }else {
                    if ([allInforArr[1] integerValue] -1 <= 0) {
                        [allInforArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@",@"0"]];
                    }else {
                        [allInforArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%ld",(long)[allInforArr.firstObject integerValue]-1]];
                    }
                    
                    [allInforArr replaceObjectAtIndex:4 withObject:@"0"];
                    [caiButton setImage:[[UIImage imageNamed:@"cai_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                    zanButton.userInteractionEnabled = YES;
                }
                NSDictionary *notifiDict = @{@"type":@"2",@"index":@(self.touchIndex)};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isLearnDetailChange" object:notifiDict];
            }
        }
        [learnDetailTableView reloadData];
    } failure:^(NSString *str) {
        
    }];
}

#pragma mark - 右按键响应事件 分享
- (void)detailRightActionWithBtn:(UIButton *)button {
    shareView = [[XMShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
    shareView.alpha = 0.0;
    shareView.shareTitle = self.learnTitle;
    shareView.shareText = @"";
    shareView.shareImageUrl = self.shareImage;
    NSString * share_url = @"";
    share_url = [NSString stringWithFormat:@"%@/%@?id=%@",INTERFACE_URL,StudyDetailAspx,self.learnAtriID];
    
    shareView.shareUrl = [NSString stringWithFormat:@"%@&is_Share=1",share_url];
    
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    [UIView animateWithDuration:0.25 animations:^{
        shareView.alpha = 1.0;
    }];
}

//实现消息中心方法
- (void)removeShareView:(NSNotification *)notification {
    [shareView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
