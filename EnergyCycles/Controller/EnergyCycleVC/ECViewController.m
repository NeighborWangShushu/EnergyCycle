//
//  ECViewController.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECViewController.h"
#import "Masonry.h"
#import "SDAutoLayout.h"
#import "ECTimeLineModel.h"
#import "CommentUserModel.h"
#import "ECTimeLineCell.h"
#import "ECTimeLineCellLikeItemModel.h"
#import "ECTimeLineCellCommentItemModel.h"
#import "XMShareView.h"
#import "GifHeader.h"
#import "ECRecommendCell.h"
#import "AFHTTPSessionManager.h"
#import "JSONKit.h"
#import "NavMenuView.h"
#import "ECNavMenuModel.h"
#import "PostingViewController.h"
#import "WebVC.h"
#import "ECTabbarViewController.h"
#import "MineHomePageViewController.h"
#import "Appdelegate.h"
#import "ShareModel.h"
#import "ShareSDKManager.h"
#import "SCLAlertView.h"
#import "SCLAlertViewStyleKit.h"
#import "UIButton+JKCountDown.h"
#import "DateAlertModel.h"
#import "NSDate+JKReporting.h"
#import "NSDate+JKUtilities.h"

#define kTimeLineTableViewCellId @"ECTimeLineCell"
#define kCommentUserCellId @"ECCommentUserCell"


@interface ECViewController ()<UITableViewDelegate,UITableViewDataSource,ECTimeLineCellDelegate,UITextFieldDelegate,NavMenuViewDelegate,ECRecommendCellDelegate> {
    XMShareView*shareView;
    AppDelegate*delegate;
    
    UILabel*titleLabel;
    UIImageView *arrowImg;
    NSInteger pageType;//0 能量圈  1关注的人
    NSInteger currentPage; //最新动态页数
    NSInteger attentionPage; //关注的人页数
    NSString * _userId;
    NSInteger maxPageSize; //总页数
    NSInteger maxAttentionPageSize; //关注的人总页数
    UITextField*text;
    
    NSString * code; //验证码
    
    ECNavMenuModel*selectedModel;
    ECTimeLineModel * commendModel;
    
    /**
     *  点击评论的索引（哪条cell）
     */
    NSInteger commentIndex;
    /**
     *  点击评论在哪个组
     */
    NSInteger commentSection;
    ECTimeLineModel * selectedLikeModel;
    
    NSInteger  messageCount;
    
    UIView * messageCountView;
    
    //未读数label
    UILabel * count;
    
    UITextField*textf;
    
    BOOL navIsOpen;
}

@property (nonatomic,strong)UITableView * tableView;

/**
 *  导航菜单
 */
@property (nonatomic,strong)NavMenuView *navMenuView;
@property (nonatomic,strong)NSMutableArray *menuDataArray;


@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * commentArray;
@property (nonatomic,strong)NSMutableArray * newerArray;
@property (nonatomic,strong)NSMutableArray * attentionArray;


@end

@implementation ECViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    [delegate.tabbarController hideTabbar:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self transformImg:0];
    [self.navMenuView removeFromSuperview];
    self.navMenuView = nil;
    [IQKeyboardManager sharedManager].enable = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getMessageData];
    [IQKeyboardManager sharedManager].enable = NO;
    
    if (User_TOKEN.length > 0) {
        [self checkPhone];
    }
}


/**
 *  检查是否绑定手机号
 */


- (void)checkPhone {
    
    [[AppHttpManager shareInstance] getGetInfoByUseridWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if ([(NSArray*)dict[@"Data"]count] > 0) {
                NSDictionary *dic = dict[@"Data"][0];
                if (dic) {
                    if ([dic objectForKey:@"phone"] == [NSNull null]) {
                        NSLog(@"绑定");
                        [self showAlert];
                    }
                }
            }
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

- (void)showAlert {
//    // 获取沙盒主目录路径
//    NSString *homeDir = NSHomeDirectory();
//    // 获取Documents目录路径
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
    
    DateAlertModel*model = [DateAlertModel findByPK:1];
    if (!model) {
        NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
        
        model = [[DateAlertModel alloc] init];
        model.last_alert_date = interval;
        model.is_alert = NO;
        [model save];
    }
    else {
        NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
        NSDate*nextDate = [NSDate jk_oneDayAfter:[[NSDate date]dateByAddingTimeInterval:model.last_alert_date]];
        if ([[NSDate date] jk_isLaterThanDate:nextDate]) {
            //如果当前时间晚于下次需要提醒的时间提醒
            model.is_alert = NO;
            model.last_alert_date = interval;
            [model saveOrUpdate];
        }
    }
    
    
    if (!model.is_alert) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert setCustomViewColor:[UIColor colorWithRed:242.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0]];
        
        //Using Block
        [alert addButton:@"确定" validationBlock:^BOOL {
            return YES;
        } actionBlock:^(void) {
            NSLog(@"Second button tapped");
            
        }];
        
        [alert showSuccess:self title:@"温馨提示" subTitle:@"根据工信部相关规定，APP应用必须进行用户实名认证。系统检测到您使用的是第三方登录，请您尽快到“我的\"模块\"->\"我的资料\"栏目中设置您的手机号，完成实名认证，谢谢配合！" closeButtonTitle:nil duration:0.0f];
        model.is_alert = YES;
        NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
        model.last_alert_date = interval;
        [model saveOrUpdate];
    }
    
}

- (void)vertyAction:(UIButton*)button {
    NSLog(@"获取验证码");
    if ([[AppHelpManager sharedInstance] isPhoneNum:textf.text]) {
        [self getVertyCode:textf.text];
        [button jk_startTime:30 title:@"获取验证码" waitTittle:@"s"];
    }else {
        [SVProgressHUD showImage:nil status:@"请输入正确的手机号码"];
    }
}

- (void)bindPhoneNumber:(NSString*)phone {
    [[AppHttpManager shareInstance] changePhoneNumberWithUserid:[User_ID intValue] Token:User_TOKEN Phone:phone PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            
        } else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];

}

/**
 *  获取验证码
 */


- (void)getVertyCode:(NSString*)phone {
    
    [[AppHttpManager shareInstance] getVerificationCodeWithPhoneNo:phone Type:2 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1)  {
            NSLog(@"验证码：%@",dict);
            code = dict[@"Data"];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [SVProgressHUD showImage:nil status:str];
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self setup];
    [self getData:YES];
    
    // Do any additional setup after loading the view.
}


- (void)initialize {
    
    delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    currentPage = 0;
    attentionPage = 0;
    self.dataArray = [NSMutableArray array];
    self.commentArray = [NSMutableArray array];
    self.newerArray = [NSMutableArray array];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSLog(@"NSDocumentDirectory:%@",documentsDirectory);
    
    _userId = [[NSString stringWithFormat:@"%@",User_ID] isEqualToString:@""]?@"0":User_ID;
    [self getNavData];
    
    if ([selectedModel.name isEqualToString:@"能量帖"] || !selectedModel) {
        pageType = 0;
    }else {
        pageType = 1;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputModeDidChange:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCyclePostView:) name:@"EnergyCycleViewToPostView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSuccess:) name:@"ECPOSTINGSUCCESS" object:nil];
    
}


#pragma mark  GET


//读取未读消息并显示
- (void)getMessageData {
    
    [[AppHttpManager shareInstance] getMyMessageNum:[_userId intValue] success:^(NSDictionary *dict) {
        if ([dict objectForKey:@"Data"] && [dict objectForKey:@"Data"] != [NSNull null]) {
            NSDictionary * dic = dict[@"Data"][0];
            NSNumber * comment = [dic objectForKey:@"CommentCount"];
            NSNumber * zan = dic[@"ZanCount"];
            NSNumber * sixin = dic[@"SixinCount"];
            messageCount = [comment integerValue] + [zan integerValue] + [sixin integerValue];
            if (messageCount == 0) {
                messageCountView.hidden = YES;
            }else {
                messageCountView.hidden = NO;
            }
            count.text = [NSString stringWithFormat:@"%ld",(long)messageCount];
        }
        
    } failure:^(NSString *str) {
        
    }];
    
    
}


- (void)getNavData {
    NSArray * all = [ECNavMenuModel findAll];
    if ([all count]) {
        [self.menuDataArray addObjectsFromArray:all];
        for (ECNavMenuModel*model in all) {
            if (model.isSelected) {
                selectedModel = model;
            }
        }
    }else {
        ECNavMenuModel*model1 = [ECNavMenuModel new];
        model1.name = @"能量帖";
        model1.isSelected = YES;
        
        ECNavMenuModel*model2 = [ECNavMenuModel new];
        model2.name = @"关注的人";
        
        selectedModel = model1;
        [model1 save];
        [model2 save];
        [self.menuDataArray addObject:model1];
        [self.menuDataArray addObject:model2];
    }
}

- (void)getData:(BOOL)isloading {
    __weak typeof(self) weakSelf = self;
    _userId = [[NSString stringWithFormat:@"%@",User_ID] isEqualToString:@""]?@"0":User_ID;

    if (pageType == 0) {
        //能量圈
        if(isloading)[SVProgressHUD showWithStatus:@""];
        
        
        NSString * jingxuan = [NSString stringWithFormat:@"%@%@?type=2&userId=%@&token=%@&pageIndex=%@&pageSize=%@",INTERFACE_URL,GetArticleList,_userId,User_TOKEN,@"0",@"10"];
        NSString * tuijian = [NSString stringWithFormat:@"%@%@?userId=%@&pageSize=%@",INTERFACE_URL,GetRecommendUser,@"0",[NSNumber numberWithInt:10]];
        NSString * zuixin = [NSString stringWithFormat:@"%@%@?type=1&userId=%@&token=%@&pageIndex=%@&pageSize=%@",INTERFACE_URL,GetArticleList,_userId,User_TOKEN,@"0",@"10"];
        currentPage = 0;
        [self.tableView.mj_footer resetNoMoreData];
        
        
        //任务1 精选动态
        AFHTTPSessionManager * operation1 = [[AFHTTPSessionManager alloc] init];
        //任务2 推荐用户
        AFHTTPSessionManager * operation2 = [[AFHTTPSessionManager alloc] init];
        //任务3 最新用户
        AFHTTPSessionManager * operation3 = [[AFHTTPSessionManager alloc] init];
 
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t q = dispatch_get_global_queue(0, 0);
        
        dispatch_group_async(group, q, ^{
            dispatch_group_enter(group);//很重要,不能少
            
            [operation1 GET:jingxuan parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary*dic = responseObject;
                [weakSelf.dataArray removeAllObjects];
                for (NSDictionary * data in (NSDictionary*)dic[@"Data"]) {
                    ECTimeLineModel*model = [self sortByData:data];
                    [weakSelf.dataArray addObject:model];
                }
                NSLog(@"operation1 is complete");
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];

        });
        
        dispatch_group_async(group, q, ^{
            dispatch_group_enter(group);//很重要,不能少
            [operation2 GET:tuijian parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = responseObject;
                [self.commentArray removeAllObjects];
                
                for (NSDictionary * data in dic[@"Data"]) {
                    CommentUserModel*model = [CommentUserModel new];
                    model.name = data[@"nickName"];
                    model.url = data[@"photourl"];
                    model.ID = [data[@"use_id"] integerValue];
                    model.isHeart = [data[@"isHeart"] boolValue];
                    model.badge = [NSString stringWithFormat:@"%@",data[@"ReportNum"]];
                    [weakSelf.commentArray addObject:model];
                }
                NSLog(@"operation2 is complete");
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        });
        
        dispatch_group_async(group, q, ^{
            dispatch_group_enter(group);//很重要,不能少
            [operation3 GET:zuixin parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = responseObject;
                [self.newerArray removeAllObjects];
                
                for (NSDictionary * data in dic[@"Data"]) {
                    ECTimeLineModel*model = [self sortByData:data];
                    maxPageSize = [[data objectForKey:@"RowCounts"] integerValue]/10;
                    [weakSelf.newerArray addObject:model];
                }
                NSLog(@"operation3 is complete");
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    NSLog(@"tableview reloaddata");
                    self.tableView.hidden = NO;
                    [SVProgressHUD dismiss];
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];

            
        });
        
    }else {
        //关注的人
        [SVProgressHUD showWithStatus:@""];

        if ([User_TOKEN length] <= 0) {
            [SVProgressHUD showImage:nil status:@"您还未登录，暂无数据"];
            [self.tableView reloadData];
            return;
        }
        attentionPage = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self.attentionArray removeAllObjects];
        [[AppHttpManager shareInstance] getGetArticleListWithType:@"3" Userid:_userId Token:User_TOKEN PageIndex:@"1" PageSize:@"10" PostOrGet:@"get" success:^(NSDictionary *dict) {
            for (NSDictionary * data in dict[@"Data"]) {
                ECTimeLineModel*model     = [self sortByData:data];
                [weakSelf.attentionArray addObject:model];
                maxAttentionPageSize = [[data objectForKey:@"RowCounts"] integerValue]/10;
            }
            weakSelf.tableView.hidden = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                [SVProgressHUD dismiss];
            });
            
        } failure:^(NSString *str) {
            
        }];
    }
}


- (ECTimeLineModel*)sortByData:(NSDictionary*)data {
    
    ECTimeLineModel*model = [ECTimeLineModel new];
    model.iconName = data[@"photoUrl"];
    model.name = data[@"nickName"];
    model.ID = [NSString stringWithFormat:@"%@",data[@"artId"]];
    model.UserID = [NSString stringWithFormat:@"%@",data[@"userId"]];
    NSString *informationStr = [data[@"artContent"] stringByRemovingPercentEncoding];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    model.msgContent = informationStr;
    model.location = data[@"address"];
    model.time = data[@"createTime"];
    model.picNamesArray = data[@"artPic"];
    model.liked = [data[@"isHasLike"] boolValue];
    model.badge = [NSString stringWithFormat:@"%@",data[@"ReportNum"]];
    
    NSMutableArray * likeArr = [NSMutableArray array];
    if ([data[@"LikeUserList"] count]) {
        for (NSDictionary * like in data[@"LikeUserList"]) {
            ECTimeLineCellLikeItemModel*likeModel = [ECTimeLineCellLikeItemModel new];
            likeModel.userId = [like[@"UserID"] stringValue];
            likeModel.userName = like[@"NickName"];
            [likeArr addObject:likeModel];
        }
    }
    
    NSMutableArray * commentArr = [NSMutableArray array];
    if ([data[@"commentList"] count]) {
        for (NSDictionary * comment in data[@"commentList"]) {
            ECTimeLineCellCommentItemModel*commentModel = [ECTimeLineCellCommentItemModel new];
            commentModel.firstUserName = comment[@"commNickName"];
            NSString * commentText = [comment[@"commContent"] stringByRemovingPercentEncoding];
            commentText = [commentText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            commentText = [commentText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            commentModel.commentString = commentText;
            commentModel.firstUserId = [comment[@"commUserId"] stringValue];
            [commentArr addObject:commentModel];
        }
    }
    model.likeItemsArray = likeArr;
    model.commentItemsArray = commentArr;
    return model;
}

/**
 *  GET
 */

- (UIView*)navMenuView {
    if (!_navMenuView) {
        _navMenuView = [[NavMenuView alloc] initWithDatas:self.menuDataArray];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_navMenuView];
    }
    return _navMenuView;
}

- (NSMutableArray*)menuDataArray {
    if (!_menuDataArray) {
        _menuDataArray = [NSMutableArray array];
    }
    return _menuDataArray;
}

- (NSMutableArray*)attentionArray {
    if (!_attentionArray) {
        _attentionArray = [NSMutableArray array];
    }
    return _attentionArray;
}


/**
 *  弹出评论键盘
 */
- (void)showKeyboard {
    [self toolBar];
}

- (void)toolBar {
    
    if (!text) {
        text = [UITextField new];
        [self.view addSubview:text];
        text.delegate = self;
    }
    
    UITextField*toolText = [[UITextField alloc] initWithFrame:CGRectMake(5, 3, self.view.frame.size.width - 70, 40)];
    toolText.borderStyle = UITextBorderStyleRoundedRect;
    toolText.placeholder = @"评论";
    toolText.delegate = self;
    toolText.returnKeyType = UIReturnKeySend;
    
    UIButton*button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(self.view.frame.size.width - 60, 3, 30, 20)];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithCustomView:toolText],
                           [[UIBarButtonItem alloc]initWithCustomView:button],
                           nil];
    [numberToolbar sizeToFit];
    
    text.inputAccessoryView = numberToolbar;
    [text becomeFirstResponder];
    [toolText becomeFirstResponder];
    
}

- (void)setup {
    
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(200, 10, 150, 50)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(showFromNavigation) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:button];
    
    titleLabel = [UILabel new];
    titleLabel.text = selectedModel.name;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titleLabel];
    
    arrowImg = [UIImageView new];
    [arrowImg setImage:[UIImage imageNamed:@"ec_arrow"]];
    [navView addSubview:arrowImg];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(navView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView.mas_centerX);
        make.centerY.equalTo(navView.mas_centerY);
    }];
    
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).with.offset(5);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.width.equalTo(@17);
        make.height.equalTo(@8);
    }];
    
    self.navigationItem.titleView = navView;
    
    UIButton *rightbutton                   = [UIButton buttonWithType:UIButtonTypeSystem];
    rightbutton.frame                       = CGRectMake(0, 0, 21, 25);
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"ec_sign"] forState:UIControlStateNormal];
    rightbutton.tag                         = 1001;
    [rightbutton addTarget:self action:@selector(energyRightActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item                   = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItems = @[item];

    UIView*leftView                         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    UIButton *leftbutton                    = [UIButton buttonWithType:UIButtonTypeSystem];
    leftbutton.frame                        = CGRectMake(0, 4, 18, 22);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"bell-icon"] forState:UIControlStateNormal];
    leftbutton.tag                          = 1002;
    [leftbutton addTarget:self action:@selector(energyLeftActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:leftbutton];
    
    
    messageCountView                       = [[UIView alloc] initWithFrame:CGRectMake(15, 2, 13, 13)];
    messageCountView.backgroundColor       = [UIColor whiteColor];
    messageCountView.layer.cornerRadius    = 7.0;
    messageCountView.hidden                = YES;
    [leftView addSubview:messageCountView];

    count                                  = [[UILabel alloc] initWithFrame:CGRectMake(1, 2, 12, 10)];
    count.font                             = [UIFont systemFontOfSize:10];
    count.center                           = messageCountView.center;
    count.textAlignment                    = NSTextAlignmentCenter;
    count.textColor                        = [UIColor colorWithRed:244.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0];
    count.text                             = [NSString stringWithFormat:@"%ld",(long)messageCount];
    [leftView addSubview:count];
    
    
    UIBarButtonItem *leftitem              = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItems = @[leftitem];
    
    
    
    UITableView * tableView   = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate        = self;
    tableView.dataSource      = self;
    [tableView setShowsVerticalScrollIndicator:NO];
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[ECTimeLineCell class] forCellReuseIdentifier:@"TestCell2"];
    [tableView registerClass:[ECRecommendCell class] forCellReuseIdentifier:kCommentUserCellId];
    [self.view addSubview:tableView];
    tableView.hidden = YES;
    

    
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.tableView = tableView;
    self.tableView.mj_header = [GifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}


#pragma mark Actions

//Navigation Action
- (void)showFromNavigation {
    if (self.navMenuView && !navIsOpen) {
        self.navMenuView.delegate = self;
        navIsOpen = YES;
        [self.navMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@60);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(@150);
            make.height.equalTo(@(self.menuDataArray.count * 50));
        }];
        [self transformImg:-180];
        
    }else {
        navIsOpen = NO;
        [self removeNavMenu];
    }
}

//旋转

- (void)transformImg:(CGFloat)angle {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    arrowImg.transform = CGAffineTransformMakeRotation(angle * (M_PI /180.0f));
    [UIView commitAnimations];
}

- (void)removeNavMenu {
    [_navMenuView removeFromSuperview];
    _navMenuView = nil;
    [self transformImg:0];
}

//签到
- (void)energyRightActionWithBtn:(id)sender {
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [self performSegueWithIdentifier:@"EnergyCycleViewToSignInView" sender:nil];
    }
}

//跳转到消息界面
- (void)energyLeftActionWithBtn:(id)sender {
    delegate.isPushToMessageView = YES;
    [delegate.tabbarController setSelectIndex:3];
}

- (void)loadNewData {
    [self getData:NO];
}

- (void)loadMoreData {
    if (pageType == 0) {
        currentPage ++;
        if (currentPage > maxPageSize) {
            currentPage = maxPageSize;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
    }else {
        attentionPage ++;
        if (attentionPage > maxAttentionPageSize) {
            attentionPage = maxAttentionPageSize;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }

    }
    
    __weak typeof(self) weakSelf = self;
    if (pageType == 0) {
        //能量圈
        NSLog(@"当前页数：%ld",currentPage);
        [[AppHttpManager shareInstance] getGetArticleListWithType:@"1" Userid:_userId Token:User_TOKEN PageIndex:[NSString stringWithFormat:@"%ld",(long)currentPage] PageSize:@"10" PostOrGet:@"get" success:^(NSDictionary *dict) {
            for (NSDictionary * data in dict[@"Data"]) {
                ECTimeLineModel*model = [self sortByData:data];
                [weakSelf.newerArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_footer endRefreshing];
                [weakSelf.tableView reloadDataWithExistedHeightCache];
            });
            
        } failure:^(NSString *str) {
            
        }];
    }else {
        //关注的人
        [[AppHttpManager shareInstance] getGetArticleListWithType:@"3" Userid:_userId Token:User_TOKEN PageIndex:[NSString stringWithFormat:@"%ld",(long)attentionPage] PageSize:@"10" PostOrGet:@"get" success:^(NSDictionary *dict) {
            for (NSDictionary * data in dict[@"Data"]) {
                ECTimeLineModel*model = [self sortByData:data];
                [weakSelf.attentionArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_footer endRefreshing];
                [weakSelf.tableView reloadDataWithExistedHeightCache];
            });
            
        } failure:^(NSString *str) {
            
        }];
    }

}

/**
 *  取消发送评论
 */

- (void)cancelAction {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
}

- (BOOL)isContainBlank:(NSString*)str
{
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}





/**
 *  发送评论接口
 *
 *  @return
 */

- (void)sendCommend:(NSString*)message index:(NSInteger)index section:(NSInteger)section {
    
    if ([[AppHelpManager sharedInstance]isBlankString:message]) {
        [SVProgressHUD showImage:nil status:@"发送内容不能为空"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [[AppHttpManager shareInstance] postAddCommentOfArticleWithArticleId:[commendModel.ID intValue] PId:0 Content:message CommUserId:[User_ID intValue] type:@"1" token:[NSString stringWithFormat:@"%@",User_TOKEN] PostOrGet:@"post" success:^(NSDictionary *dict) {
        NSDictionary*data = dict[@"Data"];
        ECTimeLineModel*model = [self sortByData:data];
        NSIndexPath*indexPath = [NSIndexPath indexPathForRow:index inSection:section];
        if (commentSection == 0) {
            if (pageType == 0) {
                [weakSelf.dataArray replaceObjectAtIndex:index withObject:model];
            }else {
                [weakSelf.attentionArray replaceObjectAtIndex:index withObject:model];
            }
            
        } else if(commentSection == 2){
            [weakSelf.newerArray replaceObjectAtIndex:index withObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
        
        [SVProgressHUD showImage:nil status:@"评论成功"];
        
    } failure:^(NSString *str) {
        
        
    }];
}

- (void)sendReply:(NSString*)message {
    
}


#pragma mark NavMenuViewDelegate
- (void)didSelected:(NSIndexPath *)indexPath item:(ECNavMenuModel *)model {
    pageType = indexPath.row;
    titleLabel.text = model.name;
    [self removeNavMenu];
    [self getData:YES];
}

#pragma mark UITableViewDelegate


- (void)didClickCommendUser:(UITableViewCell *)cell userId:(NSString *)userId userName:(NSString *)name {
    [delegate.tabbarController hideTabbar:YES];
    MineHomePageViewController *home = MainStoryBoard(@"MineHomePageViewController");
    home.userId = userId;
    [self.navigationController pushViewController:home animated:YES];
}

- (void)didClickMoreCommendUser {
    [delegate.tabbarController hideTabbar:YES];
    [self performSegueWithIdentifier:@"EnergyCycleViewToInviteView" sender:nil];
    
}

- (void)didClickOtherUser:(UITableViewCell *)cell userId:(NSString *)userId userName:(NSString *)name {
    
    [delegate.tabbarController hideTabbar:YES];
    MineHomePageViewController *otherUserVC = MainStoryBoard(@"MineHomePageViewController");
    otherUserVC.userId = userId;
    [self.navigationController pushViewController:otherUserVC animated:YES];
    
}

//删除动态
- (void)didDelete:(ECTimeLineModel *)model atIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认删除该动态吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteArticle:model indexPath:indexPath];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:alert completion:nil];
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)deleteArticle:(ECTimeLineModel*)model indexPath:(NSIndexPath*)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            [self.dataArray removeObjectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
            break;
        case 2: {
            [self.newerArray removeObjectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
            break;
            
        default:
            break;
    }
    
    [[AppHttpManager shareInstance] getDeleteArticleWithuserId:[User_ID intValue] Token:User_TOKEN AType:1 AId:[model.ID intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
        
    } failure:^(NSString *str) {
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ECTimeLineModel*model = nil;
    
    if (indexPath.section != 1) {
        if (pageType == 0) {
            if (indexPath.section == 0) {
                model = [self.dataArray objectAtIndex:indexPath.row];
            }else if (indexPath.section == 2) {
                model = [self.newerArray objectAtIndex:indexPath.row];
            }
        }else {
            model = [self.attentionArray objectAtIndex:indexPath.row];
        }
        
        NSString*aid = model.ID;
        [delegate.tabbarController hideTabbar:YES];
        
        WebVC *webVC = MainStoryBoard(@"WebVC");
        webVC.titleName = @"动态详情";
        webVC.url = [NSString stringWithFormat:@"%@%@?aid=%@&userId=%@",INTERFACE_URL,ArticleDetailAspx,aid,[NSString stringWithFormat:@"%@",User_ID]];
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else {
        [self performSegueWithIdentifier:@"EnergyCycleViewToInviteView" sender:nil];
    }
}


- (void)didActionInCell:(UITableViewCell *)cell actionType:(ECTimeLineCellActionType)type atIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray * data = nil;
    if (pageType == 0) {
        if (indexPath.section == 0) {
            data = self.dataArray;
        }else if (indexPath.section == 2) {
            data = self.newerArray;
        }
    }else {
        data = self.attentionArray;
    }
    
    switch (type) {
        case ECTimeLineCellActionTypeShare:
            [self share:data[indexPath.row]];
            break;
        case ECTimeLineCellActionTypeLike:
            [self doLike:data[indexPath.row] indexPath:indexPath];
            break;
        case ECTimeLineCellActionTypeComment:
            [self doComment:data[indexPath.row] indexPath:indexPath];
            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        id model = nil;
        if(pageType == 0) {
          model = indexPath.section == 0? self.dataArray[indexPath.row]:self.newerArray[indexPath.row];
        }else {
            model = self.attentionArray[indexPath.row];
        }
        
        CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ECTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
        
        NSLog(@"height:%f",height);
        
        return height;
    }else {
        return 155;
    }
}


- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark UITableViewDataSource

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        UILabel*title = [UILabel new];
        title.text = pageType == 0?@"精彩推荐":@"关注的人";
        title.textColor = [UIColor colorWithRed:(74 / 255.0) green:(74 / 255.0) blue:(74 / 255.0) alpha:1.0];
        title.font = [UIFont systemFontOfSize:14];
        [view addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).with.offset(10);
            make.centerY.equalTo(view.mas_centerY);
        }];
        return view;
    }else if(section == 2){
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        UILabel*title = [UILabel new];
        title.text = @"最新动态";
        title.textColor = [UIColor colorWithRed:(74 / 255.0) green:(74 / 255.0) blue:(74 / 255.0) alpha:1.0];
        title.font = [UIFont systemFontOfSize:14];
        [view addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).with.offset(10);
            make.centerY.equalTo(view.mas_centerY);
        }];
        return view;
    }
    else {
        return [UIView new];
    }

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 2) {
        ECTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
        cell.indexPath = indexPath;
        __weak typeof(self) weakSelf = self;
        if (!cell.moreButtonClickedBlock) {
            [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
                if (pageType == 0) {
                    ECTimeLineModel *model = indexPath.section == 0? weakSelf.dataArray[indexPath.row]:weakSelf.newerArray[indexPath.row];
                    model.isOpening = !model.isOpening;
                }else {
                    ECTimeLineModel *model = weakSelf.attentionArray[indexPath.row];
                    model.isOpening = !model.isOpening;
                }
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            cell.delegate = self;
        }
        
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        if (pageType == 0) {
            cell.model = indexPath.section == 0? self.dataArray[indexPath.row]:self.newerArray[indexPath.row];
        }else {
            cell.model = self.attentionArray[indexPath.row];
        }
        
        return cell;
    }else {
        
        ECRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentUserCellId];
        cell.datas = self.commentArray;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 30;
    }
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (pageType == 0) {
        if (section == 0) {
            return [self.dataArray count];
        }else if (section == 2) {
            return [self.newerArray count];
        }
        else {
            return 1;
        }
    }else {
        return [self.attentionArray count];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (pageType == 0) {
        return 3;
    }else {
        return 1;
    }
}

#pragma mark - 分享
- (void)share:(ECTimeLineModel*)model {
    
    shareView = [[XMShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
    shareView.alpha = 0.0;
    shareView.shareTitle = model.msgContent;
    shareView.shareText = model.msgContent;
    NSString * share_url = @"";
    share_url = [NSString stringWithFormat:@"%@%@?aid=%@",INTERFACE_URL,ArticleDetailAspx,model.ID];
    shareView.shareUrl = [NSString stringWithFormat:@"%@&is_Share=1",share_url];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    [UIView animateWithDuration:0.25 animations:^{
        shareView.alpha = 1.0;
    }];
}

//评论
- (void)doComment:(ECTimeLineModel*)model indexPath:(NSIndexPath*)indexPath{
    
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
        return;
    }
    commentIndex = indexPath.row;
    commentSection = indexPath.section;
    commendModel = model;
    [self showKeyboard];
}

//点赞
- (void)doLike:(ECTimeLineModel*)model indexPath:(NSIndexPath*)indexPath{
    
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
        return;
    }
    selectedLikeModel = model;
    [self like:model indexPath:indexPath];
}

- (void)like:(ECTimeLineModel*)model indexPath:(NSIndexPath*)indexPath{
    
    model.liked = !model.liked;
    NSMutableArray * likes = model.likeItemsArray;
    if (!model.liked) {
        //删除点赞名
        for (ECTimeLineCellLikeItemModel *model in likes) {
            if ([model.userId isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
                NSLog(@"删除了点赞人%@",model.userName);
                [likes removeObject:model];
                break;
            }
        }
        
    }else {
        //添加点赞名
        ECTimeLineCellLikeItemModel*likeModel = [ECTimeLineCellLikeItemModel new];
        likeModel.userId = [NSString stringWithFormat:@"%@",User_ID];
        likeModel.userName = User_NAME;
        [model.likeItemsArray addObject:likeModel];
    }
    
    if (pageType == 0) {
        if (indexPath.section == 0) {
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        }else if (indexPath.section == 0) {
            [self.newerArray replaceObjectAtIndex:indexPath.row withObject:model];
        }
    }else {
        [self.attentionArray replaceObjectAtIndex:indexPath.row withObject:model];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self postLike:model];
}

/**
 *  调用点赞接口
 */
- (void)postLike:(ECTimeLineModel*)model {
    
    NSInteger OpeType = !model.liked;
    [[AppHttpManager shareInstance] postAddLikeOrNoLikeWithType:@"1" OpeType:[NSString stringWithFormat:@"%ld",(long)OpeType] ArticleId:[model.ID intValue] UserId:[User_ID intValue] token:[NSString stringWithFormat:@"%@",User_TOKEN] PostOrGet:@"post" success:^(NSDictionary *dict) {
        
    } failure:^(NSString *str) {
        
    }];
    
    
}


#pragma mark  Notification

- (void)postSuccess:(NSNotification*)notifi {
    [self getData:YES];
}

- (void)keyboardWillShow:(NSNotification*)notifi {
    
}

- (void)keyboardWillHide:(NSNotification*)notifi {
    
}

- (void)keyboardDidChange:(NSNotification*)notifi {
    [text resignFirstResponder];
    
}

- (void)inputModeDidChange:(NSNotification*)notifi {
    
}

- (void)gotoCyclePostView:(NSNotification*)notifi {
    
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        
        PostingViewController * postView = MainStoryBoard(@"ECPostingViewController");
        UIViewController * viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController*nav = [[UINavigationController alloc] initWithRootViewController:postView];
        nav.navigationBar.hidden = YES;
        [viewController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //发送评论
    [self sendCommend:textField.text index:commentIndex section:commentSection];
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
