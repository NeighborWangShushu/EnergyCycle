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

#import "EnergyPostTableViewController.h"
#import "PKRecordTableViewController.h"

@interface MineHomePageViewController ()<TabelViewScrollingProtocol>

@property (nonatomic, strong) MineHomePageHeadView *mineView;
@property (nonatomic, strong) HMSegmentedControl *segControl;

@property (nonatomic, weak) UIViewController *showVC;

@end

@implementation MineHomePageViewController

- (void)addController {
    EnergyPostTableViewController *energyVC = [[EnergyPostTableViewController alloc] init];
    energyVC.delegate = self;
    PKRecordTableViewController *pkVC = [[PKRecordTableViewController alloc] init];
    pkVC.delegate = self;
    [self addChildViewController:energyVC];
    [self addChildViewController:pkVC];
    
}

- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    if (offsetY > kHeaderImgHeight - kNavigationHeight) {
        if (![self.mineView.superview isEqual:self.view]) {
//            self.view insertSubview:self.mineView belowSubview:
            
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}


- (void)configNav {
//    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navView.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, kScreenWidth, 20)];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.text = self.userInfoDic[@"nickname"];
    titleLabel.text = @"asdfdasfsadfsdfd";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    [self.view addSubview:navView];
}

- (void)addHeadView {
    MineHomePageHeadView *mineView = [[NSBundle mainBundle] loadNibNamed:@"MineHomePageHeadView" owner:nil options:nil].lastObject;
    mineView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderImgHeight + kSegmentedHeight);
    [mineView getdateDataWithBackgroundImage:self.userInfoDic[@"BackgroundImg"] headImage:self.userInfoDic[@"photourl"] name:self.userInfoDic[@"nickname"] sex:self.userInfoDic[@"sex"] signIn:0 address:self.userInfoDic[@"city"] intro:self.userInfoDic[@"Brief"] attention:0 fans:0];
    self.mineView = mineView;
    self.segControl = mineView.segControl;
    [self createSegmentControl];
}

//- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
//    [self.showVC.view removeFromSuperview];
//    
//    MineHomePageTableViewControllerProtocol *newVC = self.childViewControllers[sender.selectedSegmentIndex];
//    if (!newVC.view.superview) {
//        [self.view addSubview:newVC.view];
//        newVC.view.frame = self.view.bounds;
//    }
//    
//    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
//    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
//    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
//    
//    [self.view insertSubview:newVC.view belowSubview:self.navView];
//    if (offsetY <= headerImgHeight - topBarHeight) {
//        [newVC.view addSubview:_headerView];
//        for (UIView *view in newVC.view.subviews) {
//            if ([view isKindOfClass:[UIImageView class]]) {
//                [newVC.view insertSubview:_headerView belowSubview:view];
//                break;
//            }
//        }
//        CGRect rect = self.headerView.frame;
//        rect.origin.y = 0;
//        self.headerView.frame = rect;
//    }  else {
//        [self.view insertSubview:_headerView belowSubview:_navView];
//        CGRect rect = self.headerView.frame;
//        rect.origin.y = topBarHeight - headerImgHeight;
//        self.headerView.frame = rect;
//    }
//    _showingVC = newVC;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self.navigationController setNavigationBarHidden:YES];
//    self.title = self.userInfoDic[@"nickname"];
    
    [self configNav];
    [self addHeadView];
    [self addController];
    [self.view addSubview:self.mineView];
    
    // Do any additional setup after loading the view.
}

// 创建分段控件
- (void)createSegmentControl {
    self.segControl.sectionTitles = @[@"能量贴                    ",@"PK记录                    "];
    // 横线的高度
    self.segControl.selectionIndicatorHeight = 2.0f;
    // 背景颜色
    self.segControl.backgroundColor = [UIColor clearColor];
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
    self.segControl.selectedSegmentIndex = 0;
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
