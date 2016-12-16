//
//  LearnVC.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//  学习模块ViewController  V1.1

#import "LearnVC.h"
#import "Masonry.h"
#import "HMSegmentedControl.h"
#import "LearnPageViewController.h"
#import "AFSoundManager.h"
#import "WebVC.h"
#import "PopColumView.h"
#import "CategoryModel.h"
#import "JKDBHelper.h"
#import "AppHttpManager.h"
#import "LearnDetailViewController.h"
#import "MoreVC.h"
#import "PostingViewController.h"
#import "RadioListVC.h"


@interface LearnVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,PopColumViewDelegate>{
    UIView * navBg;
    PopColumView * popView;
    UIButton * left;
    UIButton * search;
    HMSegmentedControl *segmentedControl1;
    LearnPageViewController*currentPageViewController;
    int lastPlayIndex;
    NSURL *radioUrl;
    NSInteger currentSegmentIndex;
    NSString * weburl;
    BOOL isGotoDetail;
    
    AppDelegate*delegate;
}

@property (nonatomic,strong)UIPageViewController * pageController;
@property (nonatomic,strong)NSMutableArray * pageTags; //当前定制的标签
@property (nonatomic,strong)NSMutableArray * otherTags; //当前定制的标签
@property (nonatomic, strong) NSURL *playRadioUrl; // 电台的url

@end

@implementation LearnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initliaize];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    
    [delegate.tabbarController hideTabbar:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    
    
}

- (void)initliaize {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    lastPlayIndex = -1;
    radioUrl = nil;
    self.otherTags = [NSMutableArray array];
    self.pageTags  = [NSMutableArray array];
    delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.audioPlayIndex = -1;
    [self getPageData];
    [self getMyTag];
    
    // 已经对两组数据过滤掉了重复的标签
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudio:) name:@"RadioCollectionCellPlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAudio:) name:@"RadioCollectionCellStop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBanner:) name:@"WDTwoScrollViewClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(referralSelected:) name:@"ReferralSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCCTalk:) name:@"GOTOCCTALK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReferralRefresh:) name:@"ReferralRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PageViewChanged:) name:@"PageViewChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReferralHeadViewShowMore:) name:@"ReferralHeadViewShowMore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCyclePostView:) name:@"EnergyCycleViewToPostView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(learnRecommend:) name:@"LearnRecommend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(radioList) name:@"MoreRadioListVC" object:nil];
    
}


- (void)getPageData {
    [[AppHttpManager shareInstance] getGetStudyTypeWithPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                CategoryModel*model = [[CategoryModel alloc] init];
                model.name = [subDict objectForKey:@"courseTypeName"];
                [self.otherTags addObject:model];
            }
            [self compareData];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}


- (void)gotoCyclePostView:(NSNotification*)noti {
    
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        PostingViewController * postView = MainStoryBoard(@"ECPostingViewController");
        UIViewController * viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [viewController presentViewController:postView animated:YES completion:nil];
    }
}

//对我的定制数据和标签数据进行比较
- (void)compareData {
    for (int i = 0; i < [self.pageTags count]; i++) {
        CategoryModel*m = self.pageTags[i];
        for (int k = 0; k < [self.otherTags count]; k++) {
            CategoryModel*mo = self.otherTags[k];
            if ([m.name isEqualToString:mo.name]) {
                [self.otherTags removeObject:mo];
            }
        }
    }
    
    [self setupUI];
}


#pragma mark 通知事件method

/**
 *  UIPageController 页面滑动事件
 */
- (void)PageViewChanged:(NSNotification*)noti {
    NSString * name = [[noti userInfo] objectForKey:@"name"];
    currentSegmentIndex = [self indexOfPageName:name];
    [segmentedControl1 setSelectedSegmentIndex:currentSegmentIndex animated:YES];
    
}

/**
 *  ReferralHeadViewShowMore
 *
 *
 */

- (void)ReferralHeadViewShowMore:(NSNotification*)noti {
    [delegate.tabbarController hideTabbar:YES];
    NSDictionary * userInfo = [noti userInfo];
    NSString * name = [userInfo objectForKey:@"name"];
    MoreVC*morevc = MainStoryBoard(@"MoreVC");
    morevc.name = name;
    [self.navigationController pushViewController:morevc animated:YES];
    
}

- (void)ReferralRefresh:(NSNotification*)noti {
    
    
}

- (void)referralSelected:(NSNotification*)noti {
    NSDictionary * userInfo = [noti userInfo];
    NSString * ID           = [userInfo objectForKey:@"id"];
    NSString * course       = [userInfo objectForKey:@"course"];
    NSString * title        = [userInfo objectForKey:@"title"];
    NSString * content      = [userInfo objectForKey:@"content"];
    NSNumber * type         = [userInfo objectForKey:@"type"];
    NSString * pic          = [userInfo objectForKey:@"pic"];
    
    
    [delegate.tabbarController hideTabbar:YES];
    if ([type isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [self stopAudio];
    }
    
    isGotoDetail = YES;
    LearnDetailViewController *learnVC = MainStoryBoard(@"LearnDetailVCID");
    learnVC.learnAtriID = ID;
    learnVC.courseType = course;
    learnVC.learnTitle = title;
    learnVC.learnContent = content;
    learnVC.shareImage = pic;
    [self.navigationController pushViewController:learnVC animated:YES];
}

- (void)gotoCCTalk:(NSNotification*)notifi {
    NSDictionary * user = [notifi userInfo];
    weburl = [user objectForKey:@"url"];
    [self performSegueWithIdentifier:@"WebVC" sender:nil];
}

- (void)clickBanner:(NSNotification*)notifi {
    NSDictionary * user = [notifi userInfo];
    weburl = [user objectForKey:@"url"];
    NSNumber *number = [user objectForKey:@"type"];
    NSString * name = [user objectForKey:@"name"];
    if ([number isEqualToNumber:[NSNumber numberWithInteger:2]]) {
        //do some other
        [self autoSetupTuwen:name];
        return;
    }

    [self performSegueWithIdentifier:@"WebVC" sender:nil];
    
}

- (void)radioList {
    [delegate.tabbarController hideTabbar:YES];
    RadioListVC *radioVC = [[RadioListVC alloc] init];
    radioVC.radioUrl = self.playRadioUrl;
    [self.navigationController pushViewController:radioVC animated:YES];
}

- (void)learnRecommend:(NSNotification *)notification {
    weburl = notification.object;
    // 隐藏底部的tablebar
    [delegate.tabbarController hideTabbar:YES];
    [self performSegueWithIdentifier:@"WebVC" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"WebVC"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        WebVC *receive = segue.destinationViewController;
        receive.url = weburl;
    }
}

- (void)playAudio:(NSNotification*)notifi{
    
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSDictionary * dic    = [notifi userInfo];
    NSString * url        = [dic objectForKey:@"url"];
    NSInteger  audioindex = [[dic objectForKey:@"index"] integerValue];
    
    delegate.audioPlayIndex = audioindex;
    
    if (lastPlayIndex != -1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRadioPlayer" object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%i",lastPlayIndex], @"radioUrl" : self.playRadioUrl}];
    }
    
    NSString * index = [dic objectForKey:@"index"];
    lastPlayIndex = [index intValue];
    radioUrl = [NSURL URLWithString:url];
    
    self.playRadioUrl = [NSURL URLWithString:url];
    
    [self play:url];
}

- (void)stopAudio:(NSNotification*)notifi {
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.audioPlayIndex = -1;
    [self stopAudio];
}

- (void)stopAudio {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRadioPlayer" object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%i",lastPlayIndex], @"radioUrl" : radioUrl}];
    [[AFSoundManager sharedManager] stop];
}

- (void)play:(NSString*)url {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [[AFSoundManager sharedManager] startStreamingRemoteAudioFromURL:url andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        
    }];
}

#pragma mark  获取本地数据库数据
- (void)getMyTag {
    
    NSArray * all = [CategoryModel findAll];
    if ([all count] > 0) {
        for (CategoryModel * name in all) {
            [self.pageTags addObject:name];
        }
    }else
    {
        [self createTable];
    }
    
}


//创建数据库 插入数据
- (void)createTable {
    
    CategoryModel * m1 = [[CategoryModel alloc] init];
    m1.name            = @"推荐";
    CategoryModel * m2 = [[CategoryModel alloc] init];
    m2.name            = @"热门";
    [self.pageTags addObject:m1];
    [self.pageTags addObject:m2];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [m1 save];
        [m2 save];
    });
    
}


- (void)setupUI {
    
    navBg = [UIView new];
    navBg.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:79/255.0 blue:81.0/255.0 alpha:1.0];
    [self.view addSubview:navBg];
    [navBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@64);
    }];
    
    left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"sousuo_"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [navBg addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navBg.mas_left).with.offset(10);
        make.centerY.equalTo(navBg.mas_centerY).with.offset(10);
        make.width.equalTo(@50);
    }];
    
    search = [UIButton buttonWithType:UIButtonTypeCustom];
    [search setImage:[UIImage imageNamed:@"learn_add"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
    [navBg addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navBg.mas_right).with.offset(-10);
        make.centerY.equalTo(navBg.mas_centerY).with.offset(10);
        make.width.equalTo(@50);
    }];
    
    [self setSegmentControl];
    [self setPage];
    
}


- (void)setSegmentControl {
    
    NSMutableArray * titles = [NSMutableArray array];
    if ([self.pageTags count] > 0) {
        for (CategoryModel*model in self.pageTags) {
            [titles addObject:model.name];
        }
        
        if (!segmentedControl1) {
            segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
            segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(5, 10, 0, 10);
            segmentedControl1.selectionIndicatorColor = [UIColor whiteColor];
            segmentedControl1.backgroundColor = [UIColor clearColor];
            segmentedControl1.selectionIndicatorHeight = 2.0;
            [segmentedControl1 setSelectedSegmentIndex:0 animated:NO];
            segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
            segmentedControl1.segmentWidthStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
            segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            segmentedControl1.verticalDividerEnabled = NO;
            [segmentedControl1 setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
                return attString;
            }];
            [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
            [navBg addSubview:segmentedControl1];
            [segmentedControl1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(left.mas_right).with.offset(10);
                make.right.equalTo(search.mas_left).with.offset(-10);
                make.centerY.equalTo(left.mas_centerY);
                make.height.equalTo(@30);
            }];
            
            LearnPageViewController * refView = [self viewControllerAtIndex:0];
            NSArray *viewControllers =[NSArray arrayWithObject:refView];
            [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }else {
            [segmentedControl1 removeFromSuperview];
            segmentedControl1 = nil;
            [self setSegmentControl];
        }
        
    }
}

- (void)searchAction {
    
    [self performSegueWithIdentifier:@"LearnViewToSearchView" sender:nil];
}

- (void)setPage {
    
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageController.dataSource = self;
    [self.pageController.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, Screen_Height - 64)];
    LearnPageViewController * refView = [self viewControllerAtIndex:0];
    NSArray *viewControllers =[NSArray arrayWithObject:refView];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    
}



//打开popview
- (void)startAnimation {
    if (popView) {
        return;
    }
    
    [delegate.tabbarController hideTabbar:YES];
    
    popView = [[PopColumView alloc] initWithData:self.pageTags myColum:self.otherTags];
    popView.delegate = self;
    [self.view addSubview:popView];
    
    popView.alpha = 0.0;
    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.view.mas_height).with.offset(64);
        make.top.equalTo(self.view.mas_top).with.offset(0);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        popView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
    }];
}


#pragma mark 自动定制频道
- (void)autoSetupTuwen:(NSString*)name {
    for (CategoryModel*model in self.pageTags) {
        if ([model.name isEqualToString:name]) {
            for (CategoryModel*m in self.otherTags) {
                if ([m.name isEqualToString:name]) {
                    [self.otherTags removeObject:m];
                }
            }
            [self jumpToTuwen:name];
            
            return;
        }
    }
    
    //    新建图文直播频道
    CategoryModel*newmodel = [[CategoryModel alloc] init];
    newmodel.name = name;
    [newmodel save];
    [self.pageTags addObject:newmodel];
    
    
    for (CategoryModel*m in self.otherTags) {
        if ([m.name isEqualToString:name]) {
            [self.otherTags removeObject:m];
            break;
        }
    }
    
    [self setSegmentControl];
    [self jumpToTuwen:name];
    
    
}

- (void)jumpToTuwen:(NSString*)name {
    NSInteger index = 0;
    for (int i = 0;i<self.pageTags.count;i++) {
        CategoryModel*model = self.pageTags[i];
        if ([model.name isEqualToString:name]) {
            index = i;
        }
    }
    [segmentedControl1 setSelectedSegmentIndex:index animated:YES];
    LearnPageViewController * refView = [self viewControllerAtIndex:segmentedControl1.selectedSegmentIndex];
    [self.pageController setViewControllers:@[refView] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


#pragma mark PopColumViewDelegate
- (void)popColunView:(PopColumView *)view didChooseColums:(NSMutableArray *)items otherItems:(NSMutableArray *)others{
    
    [UIView animateWithDuration:0.25 animations:^{
        popView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [popView removeFromSuperview];
        popView = nil;
    }];
    [delegate.tabbarController hideTabbar:NO];
    
    //处理数据
    BOOL isDelete = [self.pageTags count] > [items count];
    NSMutableArray * p = [NSMutableArray arrayWithArray:items];
    if (isDelete) {
        //删数据
        for (int i = 0; i < [p count]; i++) {
            CategoryModel*model = p[i];
            for (int j = 0; j < [self.pageTags count]; j++) {
                CategoryModel*model2 = self.pageTags[j];
                if ([model.name isEqualToString:model2.name]) {
                    [self.pageTags removeObject:model2];
                }
            }
        }
        for (CategoryModel * delete in self.pageTags) {
            [delete deleteObject];
        }
        
        self.pageTags = items;
        
    }else {
        
        NSMutableArray * itemscopy = [NSMutableArray arrayWithArray:items];
        for (int i = 0; i < [itemscopy count]; i++) {
            CategoryModel*model = itemscopy[i];
            for (int j = 0; j < self.pageTags.count; j++) {
                CategoryModel*model2 = self.pageTags[j];
                NSLog(@"model:%@---model2:%@",model.name,model2.name);
                if ([model.name isEqualToString:model2.name]) {
                    [items removeObject:model];
                }
            }
        }
        
        for (int m = 0; m < items.count; m++) {
            CategoryModel*model3 = items[m];
            [model3 save];
            [self.pageTags addObject:model3];
        }
        
    }
    
    self.otherTags = others;
    [self setSegmentControl];
}

- (NSInteger)indexOfPageName:(NSString*)name {
    for (int i = 0; i < self.pageTags.count; i++) {
        CategoryModel*model = self.pageTags[i];
        if ([model.name isEqualToString:name]) {
            return i;
        }
    }
    return 0;
}


#pragma mark HMSegmentedControl Method

- (void)segmentedControlChangedValue:(HMSegmentedControl*)segmentedControl {
    LearnPageViewController * refView = [self viewControllerAtIndex:segmentedControl.selectedSegmentIndex];
    [self.pageController setViewControllers:@[refView] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


#pragma mark UIPageControl DataSource
- (NSUInteger)indexOfViewController:(LearnPageViewController *)viewController {
    return [self.pageTags indexOfObject:viewController.model];
}

- (LearnPageViewController*)viewControllerAtIndex:(NSInteger)index {
    if (([self.pageTags count] == 0) || (index >= [self.pageTags count])) {
        return nil;
    }
    
    // 创建一个新的控制器类，并且分配给相应的数据
    LearnPageViewController *dataViewController =[[LearnPageViewController alloc] init];
    CategoryModel*model      = self.pageTags[index];
    dataViewController.type  = model.name;
    dataViewController.model = model;
    return dataViewController;
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(LearnPageViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [self.pageTags count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:(LearnPageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    return [self viewControllerAtIndex:index];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.pageController.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, Screen_Height - 64 - 50)];

    
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
