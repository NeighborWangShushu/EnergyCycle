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

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) UIViewController *showVC;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个列表在Y轴的偏移量

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
//    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = NO;
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] size:CGSizeMake(kScreenWidth, 64)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    if (offsetY > kHeaderImgHeight - kNavigationHeight) {
        if (![self.mineView.superview isEqual:self.view]) {
            [self.view insertSubview:self.mineView belowSubview:self.navigationController.navigationBar];
        }
        CGRect rect = self.mineView.frame;
        rect.origin.y = kNavigationHeight - kHeaderImgHeight;
        self.mineView.frame = rect;
    } else {
        if (![self.mineView.superview isEqual:tableView]) {
            for (UIView *view in tableView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [tableView insertSubview:self.mineView belowSubview:view];
                    break;
                }
            }
        }
        CGRect rect = self.mineView.frame;
        rect.origin.y = 0;
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
    EnergyPostTableViewController *energyVC = [[EnergyPostTableViewController alloc] init];
    energyVC.tableView.showsVerticalScrollIndicator = NO;
    energyVC.delegate = self;
    PKRecordTableViewController *pkVC = [[PKRecordTableViewController alloc] init];
    pkVC.tableView.showsVerticalScrollIndicator = NO;
    pkVC.delegate = self;
    
    [self addChildViewController:energyVC];
    [self addChildViewController:pkVC];
    
}

- (void)addHeadView {
    MineHomePageHeadView *mineView = [[NSBundle mainBundle] loadNibNamed:@"MineHomePageHeadView" owner:nil options:nil].lastObject;
    mineView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderImgHeight + kSegmentedHeight);
    [mineView getdateDataWithBackgroundImage:self.userInfoDic[@"BackgroundImg"] headImage:self.userInfoDic[@"photourl"] name:self.userInfoDic[@"nickname"] sex:self.userInfoDic[@"sex"] signIn:0 address:self.userInfoDic[@"city"] intro:self.userInfoDic[@"Brief"] attention:0 fans:0];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.userInfoDic[@"nickname"];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel sizeToFit];
    self.titleLabel.hidden = YES;
    self.navigationItem.titleView = self.titleLabel;
    
    self.mineView = mineView;
    self.segControl = mineView.segControl;
    [self createSegmentControl];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    [self.showVC.view removeFromSuperview];
    
    MineHomePageTableViewControllerProtocol *newVC = self.childViewControllers[sender.selectedSegmentIndex];
    if (!newVC.view.superview) {
        [self.view addSubview:newVC.view];
        newVC.view.frame = self.view.bounds;
    }
    
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
    
    [self.view insertSubview:newVC.view belowSubview:self.navigationController.navigationBar];
    if (offsetY <= kHeaderImgHeight - kNavigationHeight) {
        [newVC.view addSubview:self.mineView];
        for (UIView *view in newVC.view.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [newVC.view insertSubview:self.mineView belowSubview:view];
                break;
            }
        }
        CGRect rect = self.mineView.frame;
        rect.origin.y = 0;
        self.mineView.frame = rect;
    }  else {
        [self.view insertSubview:self.mineView belowSubview:self.navigationController.navigationBar];
        CGRect rect = self.mineView.frame;
        rect.origin.y = kNavigationHeight - kHeaderImgHeight;
        self.mineView.frame = rect;
    }
    self.showVC = newVC;

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
}

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    self.mineView.userInteractionEnabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] size:CGSizeMake(kScreenWidth, 64)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self addHeadView];
    [self addController];
    [self segmentedControlChangedValue:self.segControl];
    
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
