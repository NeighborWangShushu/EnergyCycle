//
//  MineHomePageViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineHomePageViewController.h"

#import "MineHomePageTableViewControllerProtocol.h"
#import "MineHomePageHeadView.h"
#import "HMSegmentedControl.h"

#import "UserModel.h"
#import "UserInfoModel.h"

#import "IntroViewController.h"
#import "AttentionAndFansTableViewController.h"
#import "EnergyPostTableViewController.h"
#import "PKRecordTableViewController.h"
#import "ToDayPKTableViewController.h"
#import "MyProfileViewController.h"
#import "ECAvatarManager.h"
#import "MineChatViewController.h"
#import "ChatViewController.h"
#import "WebVC.h"
#import "BrokenLineViewController.h"

@interface MineHomePageViewController ()<TabelViewScrollingProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> {
    CGFloat scrollValue;
}

@property (nonatomic, strong) MineHomePageHeadView *mineView;
@property (nonatomic, strong) HMSegmentedControl *segControl;
@property (nonatomic, strong) UserModel *model;
@property (nonatomic, strong) UserInfoModel *infoModel;

@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, assign) BOOL isHeadImage;
@property (nonatomic, strong) NSData *headImageData;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) UIViewController *showVC;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个列表在Y轴的偏移量

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) EnergyPostTableViewController *energyVC;
@property (nonatomic, strong) PKRecordTableViewController *pkVC;
@property (nonatomic, strong) ToDayPKTableViewController *toDayVC;

@end

@implementation MineHomePageViewController

- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (MineHomePageTableViewControllerProtocol *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self getUserInfo];
    [self getUserInfoModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnergyPostTableViewController" object:self userInfo:@{@"userId" : self.userId}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PKRecordTableViewController" object:self userInfo:@{@"userId" : self.userId}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToDayTableViewController" object:self userInfo:@{@"userId" : self.userId}];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mineHomePageReloadView) name:@"mineHomePageReloadView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headViewChangeHeadImage) name:@"headViewChangeHeadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headViewChangeBackgroundImage) name:@"headViewChangeBackgroundImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToAttentionController) name:@"jumpToAttentionController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToFansController) name:@"jumpToFansController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToIntroViewController) name:@"jumpToIntroViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HomePageViewControllerReloadData) name:@"HomePageViewControllerReloadData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(energyDetailWebVC:) name:@"EnergyDetailWebVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brokenLineViewController:) name:@"HomePageControllerToBrokenLineViewController" object:nil];
}

- (void)energyDetailWebVC:(NSNotification *)notification {
    WebVC *webVC = notification.object;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)brokenLineViewController:(NSNotification *)notification {
    BrokenLineViewController *blVC = notification.object;
    [self.navigationController pushViewController:blVC animated:YES];
}

- (void)HomePageViewControllerReloadData {
    [self getUserInfo];
    [self getUserInfoModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
//    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] size:CGSizeMake(kScreenWidth, 64)];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = nil;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 获取用户基本数据
- (void)getUserInfo {
    [[AppHttpManager shareInstance] getGetInfoByUseridWithUserid:self.userId PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if ([dict[@"Data"] count]) {
                for (NSDictionary *subDict in dict[@"Data"]) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                    self.model = model;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addNavgationTitle];
                [self.mineView getdateDataWithModel:self.model userInfoModel:self.infoModel];
            });
        }
        
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

// 获取关注数,粉丝数等数据
- (void)getUserInfoModel {
    
    [[AppHttpManager shareInstance] getGetUserInfoWithUserid:[User_ID == NULL ? 0 : User_ID intValue] OtherUserID:[self.userId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dict[@"Data"][0] error:nil];
            self.infoModel = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 判断是否是自己的主页
                if ([self.userId integerValue] == [User_ID integerValue]) {
                    [self moreButton];
                } else {
                    [self attentionButton];
                }
//                [self addNavgationTitle];
                self.titleLabel.text = self.model.nickname;
                [self.mineView getdateDataWithModel:self.model userInfoModel:self.infoModel];
            });
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY {
//    NSLog(@"%f",offsetY);
    if (offsetY > kHeaderImgHeight - kNavigationHeight) {
        if (![self.mineView.superview isEqual:self.view]) {
            [self.view insertSubview:self.mineView belowSubview:self.navigationController.navigationBar];
        }
        CGRect rect = self.mineView.frame;
        rect.origin.y = kNavigationHeight - kHeaderImgHeight;
        self.mineView.frame = rect;
    } else {
        [self.view insertSubview:self.mineView belowSubview:self.navigationController.navigationBar];
        
//        if (offsetY < 0) {
////            CGFloat scale = (kHeaderImgHeight - kNavigationHeight) / offsetY;
//            self.mineView.backgroundImage.frame = CGRectMake(self.mineView.backgroundImage.frame.origin.x, self.mineView.backgroundImage.frame.origin.y, self.mineView.backgroundImage.frame.size.width / (- offsetY * 0.5), self.mineView.backgroundImage.frame.size.height / (- offsetY * 0.5));
////            self.mineView.backgroundImageHeight.constant = 250 - offsetY;
//        }
        
        CGRect rect = self.mineView.frame;
        rect.origin.y = - offsetY;
        self.mineView.frame = rect;

    }
    
    if (offsetY > 0) {
        CGFloat alpha = offsetY / (kHeaderImgHeight - kNavigationHeight);
        if (alpha >= 1) {
            alpha = 0.99;
        }
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:alpha] size:CGSizeMake(kScreenWidth, 64)];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.titleLabel.alpha = alpha;
        self.titleLabel.hidden = NO;
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.titleLabel.alpha = 0;
        self.titleLabel.hidden = YES;
    }
}

// 添加列表
- (void)addController {
    self.energyVC = [[EnergyPostTableViewController alloc] init];
    self.energyVC.delegate = self;
    self.pkVC = [[PKRecordTableViewController alloc] init];
    self.pkVC.tableView.showsVerticalScrollIndicator = NO;
    self.pkVC.delegate = self;
    self.toDayVC = [[ToDayPKTableViewController alloc] init];
    self.toDayVC.tableView.showsVerticalScrollIndicator = NO;
    self.toDayVC.delegate = self;
    
    CGRect frame = self.view.bounds;
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    CGSize size = frame.size;
    size.width = frame.size.width * 3;
    self.scrollView.contentSize = size;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    CGRect energyView = self.energyVC.view.frame;
    energyView.size.height += energyView.origin.y;
    energyView.origin.y = 0;
    self.energyVC.view.frame = energyView;
    [self.scrollView addSubview:self.energyVC.view];
    frame.origin.x += frame.size.width;
    self.pkVC.view.frame = frame;
    [self.scrollView addSubview:self.pkVC.view];
    frame.origin.x += frame.size.width;
    self.toDayVC.view.frame = frame;
    [self.scrollView addSubview:self.toDayVC.view];
    
    [self.view addSubview:self.scrollView];
    
//    [self addChildViewController:energyVC];
//    [self addChildViewController:pkVC];
//    [self addChildViewController:toDayVC];
}

// 添加头视图
- (void)addHeadView {
    MineHomePageHeadView *mineView = [[NSBundle mainBundle] loadNibNamed:@"MineHomePageHeadView" owner:nil options:nil].lastObject;
    mineView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderImgHeight + kSegmentedHeight);
//    [mineView getdateDataWithModel:self.model signIn:0 attention:0 fans:0];
    
    [self addNavgationTitle];
    
    self.mineView = mineView;
    self.segControl = mineView.segControl;
    [self createSegmentControl];
}

- (void)addNavgationTitle {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.model.nickname;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel sizeToFit];
    self.titleLabel.hidden = YES;
    self.navigationItem.titleView = self.titleLabel;
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    [self.showVC.view removeFromSuperview];
    
    if (!self.bottomView) {
        [self createBottomView];
    }
    
    if (sender.selectedSegmentIndex != 2) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:2
                            options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self.bottomView setFrame:CGRectMake(self.bottomView.frame.origin.x, Screen_Height, self.bottomView.frame.size.width, self.bottomView.frame.size.height)];
                            } completion:nil];
    } else {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:2
                            options:UIViewAnimationOptionLayoutSubviews animations:^{
            [self.bottomView setFrame:CGRectMake(self.bottomView.frame.origin.x, Screen_Height - 90, self.bottomView.frame.size.width, self.bottomView.frame.size.height)];
        } completion:nil];
    }
    
    MineHomePageTableViewControllerProtocol *newVC = [[MineHomePageTableViewControllerProtocol alloc] init];
    if (sender.selectedSegmentIndex == 0) {
        newVC = self.energyVC;
    } else if (sender.selectedSegmentIndex == 1) {
        newVC = self.pkVC;
    } else if (sender.selectedSegmentIndex == 2) {
        newVC = self.toDayVC;
    }
    [self tableViewScroll:newVC.tableView offsetY:newVC.tableView.contentOffset.y];
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(Screen_width * sender.selectedSegmentIndex, 0);
    }];
    
    
//    [self.showVC.view removeFromSuperview];

//    MineHomePageTableViewControllerProtocol *newVC = self.childViewControllers[sender.selectedSegmentIndex];
//    if (sender.selectedSegmentIndex == 0) {
//        EnergyPostTableViewController *newVC =
//    }
//    if (!newVC.view.superview) {
//        [self.view addSubview:newVC.view];
//        newVC.view.frame = self.view.bounds;
//    }
//    
//    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
//    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
//    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
//    
//    [self.view insertSubview:newVC.view belowSubview:self.navigationController.navigationBar];
//    if (offsetY <= kHeaderImgHeight - kNavigationHeight) {
//        [newVC.view addSubview:self.mineView];
//        
//        CGRect rect = self.mineView.frame;
//        rect.origin.y = 0;
//        self.mineView.frame = rect;
//    }  else {
//        [self.view insertSubview:self.mineView belowSubview:self.navigationController.navigationBar];
//        CGRect rect = self.mineView.frame;
//        rect.origin.y = kNavigationHeight - kHeaderImgHeight;
//        self.mineView.frame = rect;
//    }
//    self.showVC = newVC;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    [self.segControl setSelectedSegmentIndex:offset.x / Screen_width animated:YES];
    [self segmentedControlChangedValue:self.segControl];
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    self.mineView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", self.showVC];
    if (offsetY > kHeaderImgHeight - kNavigationHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                self.offsetYDict[key] = @(offsetY);
            } else if ([self.offsetYDict[key] floatValue] <= kHeaderImgHeight - kNavigationHeight) {
                self.offsetYDict[key] = @(kHeaderImgHeight - kNavigationHeight);
            }
        }];
    } else {
        if (offsetY <= kHeaderImgHeight - kNavigationHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                self.offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    self.mineView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", self.showVC];
    if (offsetY > kHeaderImgHeight - kNavigationHeight) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                self.offsetYDict[key] = @(offsetY);
            } else if ([self.offsetYDict[key] floatValue] <= kHeaderImgHeight - kNavigationHeight) {
                self.offsetYDict[key] = @(kHeaderImgHeight - kNavigationHeight);
            }
        }];
    } else {
        if (offsetY <= kHeaderImgHeight - kNavigationHeight) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                self.offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewWillBeginDecelerating:(UITableView *)tablView offsetY:(CGFloat)offsetY {
    self.mineView.userInteractionEnabled = NO;
    if (self.segControl.selectedSegmentIndex == 2) {
        if ((offsetY - scrollValue) > 0) {
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:2
                                options:UIViewAnimationOptionLayoutSubviews animations:^{
                                    [self.bottomView setFrame:CGRectMake(self.bottomView.frame.origin.x, Screen_Height, self.bottomView.frame.size.width, self.bottomView.frame.size.height)];
                                } completion:nil];
        }
        if ((offsetY - scrollValue) < 0) {
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:2
                                options:UIViewAnimationOptionLayoutSubviews animations:^{
                                    [self.bottomView setFrame:CGRectMake(self.bottomView.frame.origin.x, Screen_Height - 90, self.bottomView.frame.size.width, self.bottomView.frame.size.height)];
                                } completion:nil];
        }
        scrollValue = offsetY;
    }
}

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    self.mineView.userInteractionEnabled = NO;
}


- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加更多按钮
- (void)moreButton {
    UIImage *image = [UIImage imageNamed:@"more"];
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickMoreButton)];
    self.navigationItem.rightBarButtonItem = moreButton;
}

- (void)clickMoreButton {
    MyProfileViewController *myVC = MainStoryBoard(@"MyProfileViewController");
    myVC.model = self.model;
    [self.navigationController pushViewController:myVC animated:YES];
}

// 添加关注按钮
- (void)attentionButton {
    UIImage *image = [[UIImage alloc] init];
    if ([self.infoModel.IsGuanZhu intValue] == 1) {
        image = [UIImage imageNamed:@"Guanzhu"];
    } else {
        image = [UIImage imageNamed:@"addGuanzhu"];
    }
    UIButton *attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionButton.frame = CGRectMake(30, 0, 49, 20);
    [attentionButton setImage:image forState:UIControlStateNormal];
    [attentionButton addTarget:self action:@selector(clickAttentionButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *attentionBarButton = [[UIBarButtonItem alloc] initWithCustomView:attentionButton];
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.frame = CGRectMake(20, 0, 49, 20);
    [chatButton setImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(jumpChatViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *chatBarButton = [[UIBarButtonItem alloc] initWithCustomView:chatButton];
    self.navigationItem.rightBarButtonItems = @[attentionBarButton, chatBarButton];
//    self.navigationItem.rightBarButtonItem = chatButton;
//    self.navigationItem.rightBarButtonItem = attentionButton;
}

- (void)jumpChatViewController {
    ChatViewController *chatVC = MainStoryBoard(@"ChatViewVCID");
    chatVC.otherName = self.model.nickname;
    chatVC.otherID = self.userId;
    [self.navigationController pushViewController:chatVC animated:YES];
//    MineChatViewController *chatVC = MainStoryBoard(@"MineChatViewController");
//    chatVC.useredId = self.userId;
//    chatVC.chatName = self.model.nickname;
//    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)clickAttentionButton {
    if ([self.infoModel.IsGuanZhu intValue] == 1) {
        [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:2 UserId:[User_ID intValue] Token:User_TOKEN OUserId:[self.userId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"已取消关注" maskType:SVProgressHUDMaskTypeClear];
                self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"addGuanzhu"];
                [self getUserInfoModel];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    } else {
        [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:1 UserId:[User_ID intValue] Token:User_TOKEN OUserId:[self.userId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"关注成功" maskType:SVProgressHUDMaskTypeClear];
                self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"Guanzhu"];
                [self getUserInfoModel];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    }
}

- (void)createBottomView {
    if ([self.userId integerValue] != [User_ID integerValue]) {
        return;
    }
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(Screen_width - 160, Screen_Height, 160, 90)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
    image.image = [UIImage imageNamed:@"ToDay_BottomView"];
    [self.bottomView addSubview:image];
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake(10, -13, image.frame.size.width / 2, image.frame.size.height);
    [postButton setImage:[UIImage imageNamed:@"ToDay_BottomPost"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:postButton];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(image.frame.size.width / 2 - 10, -13, image.frame.size.width / 2, image.frame.size.height);
    [shareButton setImage:[UIImage imageNamed:@"ToDay_BottomShare"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:shareButton];
    [self.view addSubview:self.bottomView];
}

- (void)postAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToDayViewControllerPost" object:nil];
}

- (void)shareAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToDayViewControllerShare" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftNavBarWithimage:@"loginfanhui"];

    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = YES;
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] size:CGSizeMake(kScreenWidth, 64)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    

    
    [self addHeadView];
    [self addController];
    [self segmentedControlChangedValue:self.segControl];
    

    
    // Do any additional setup after loading the view.
}

- (void)mineHomePageReloadView {
//    [self getUserInfo];
    [self.view insertSubview:self.mineView belowSubview:self.navigationController.navigationBar];
}

// 更改头像
- (void)headViewChangeHeadImage {
    self.isHeadImage = YES;
    [self createPicker];
}

// 更改背景
- (void)headViewChangeBackgroundImage {
    self.isHeadImage = NO;
    [self createPicker];
}

// 创建图片选择器
- (void)createPicker {
    if (!self.picker) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
        self.picker.navigationBar.tintColor = [UIColor whiteColor];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.view.window.rootViewController presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.view.window.rootViewController presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cameraAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [viewController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (self.isHeadImage) { // 上传头像
        self.headImageData = UIImageJPEGRepresentation(image, 0.01);
        [self.picker dismissViewControllerAnimated:YES completion:nil];
        [[AppHttpManager shareInstance] postAddImgWithPhoneNo:self.model.use_id Img:self.headImageData PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [self getUserInfo];
            } else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    } else { // 上传背景图片
        self.headImageData = UIImageJPEGRepresentation(image, 0.1);
        [self.picker dismissViewControllerAnimated:YES completion:nil];
        [[AppHttpManager shareInstance] postPostFileWithImageData:self.headImageData PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
//                NSLog(@"%@", dict[@"Data"]);
                NSString *backgroundImage = dict[@"Data"][0];
                [self changeBackgoundImage:backgroundImage];
            } else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
        

    }
    
}

- (void)changeBackgoundImage:(NSString *)backgroundImage {
    [[AppHttpManager shareInstance] changeBackgroundImgWithUserid:[self.model.use_id intValue] Token:self.model.token BackgroundImg:backgroundImage PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self getUserInfo];
        } else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)jumpToAttentionController {
    AttentionAndFansTableViewController *afVC = [[AttentionAndFansTableViewController alloc] init];
    afVC.userId = self.model.use_id;
    afVC.type = 1;
    [self.navigationController pushViewController:afVC animated:YES];
}

- (void)jumpToFansController {
    AttentionAndFansTableViewController *afVC = [[AttentionAndFansTableViewController alloc] init];
    afVC.userId = self.model.use_id;
    afVC.type = 2;
    [self.navigationController pushViewController:afVC animated:YES];
}



- (void)jumpToIntroViewController {
    IntroViewController *introVC = MainStoryBoard(@"IntroViewController");
    introVC.introString = self.model.Brief;
    [self.navigationController pushViewController:introVC animated:YES];
}

// 创建分段控件
- (void)createSegmentControl {
    self.segControl.sectionTitles = @[@"能量帖          ",@"PK记录          ",@"今日PK          "];
    // 横线的高度
    self.segControl.selectionIndicatorHeight = 2.0f;
    // 背景颜色
    self.segControl.backgroundColor = [UIColor whiteColor];
    // 横线的颜色
    self.segControl.selectionIndicatorColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    // 横线在底部出现
    self.segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    // 横线根据文本的长度自适应长度
    self.segControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    // 为选中时的文本样式
    self.segControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:14]};
    // 选中后的文本样式
    self.segControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:242/ 255.0 green:77/255.0 blue:77/255.0 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:14]};
    // 初始位置
    if (self.isPK) {
        self.segControl.selectedSegmentIndex = 2;
    } else {
        self.segControl.selectedSegmentIndex = 0;
    }
    // 边界样式
    self.segControl.borderType = HMSegmentedControlBorderTypeBottom;
    // 边界颜色
    self.segControl.borderColor = [UIColor lightGrayColor];
    // 触发方法
    [self.segControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
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
