//
//  EveryDayPKViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "EveryDayPKViewController.h"

#import "PkEveryDayViewCell.h"
#import "PkEveryDayHeadViewCell.h"

#import "EveryDayPKModel.h"
#import "EveryDPKPMModel.h"

#import "OtherUesrViewController.h"
#import "OtherUserReportViewController.h"
#import "MineEveryDayPKViewController.h"
#import "MineHomePageViewController.h"

@interface EveryDayPKViewController ()  <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate> {
    UIView *headLineView;
    UIView *everyPKShowHeadView;
    UICollectionView *headCollectionView;
    UIButton *rightButton;
    NSInteger touchIndex;
    
    //显示的collectionView
    UICollectionView *pkShowCollectionView;
    
    NSMutableArray *_headDataArr;
    EveryDPKPMModel *pushModel;
}

@end

@implementation EveryDayPKViewController

static BOOL isShowAll = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"每日PK";
    touchIndex = 0;
    
    _headDataArr = [[NSMutableArray alloc] init];
    
    [self setupRightNavBarWithimage:@"35pen_.png"];
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    [self creatHeadCollectionView];
    
    
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    
    [self getHeadCollectionViewData];
}

#pragma mark - 获取头 分类 网络数据
- (void)getHeadCollectionViewData {
    [[AppHttpManager shareInstance] getGetProjectWithPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"IsSuccess"] integerValue] == 1 || [dict[@"Code"] integerValue] == 200) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                EveryDayPKModel *model = [[EveryDayPKModel alloc] initWithDictionary:subDict error:nil];
                [_headDataArr addObject:model];
            }
        }
        [headCollectionView reloadData];
        
        UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
        [showBackLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        showBackLayout.minimumInteritemSpacing = 0.f;
        showBackLayout.minimumLineSpacing = 0.f;
        pkShowCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, Screen_width, Screen_Height-104)collectionViewLayout:showBackLayout];
        pkShowCollectionView.backgroundColor = [UIColor whiteColor];
        [pkShowCollectionView registerNib:[UINib nibWithNibName:@"PkEveryDayViewCell" bundle:nil] forCellWithReuseIdentifier:@"PkEveryDayViewCellId"];
        pkShowCollectionView.delegate = self;
        pkShowCollectionView.dataSource = self;
        pkShowCollectionView.showsHorizontalScrollIndicator = NO;
        pkShowCollectionView.bounces = NO;
        pkShowCollectionView.pagingEnabled = YES;
        pkShowCollectionView.scrollEnabled = NO;
        [self.view addSubview:pkShowCollectionView];
        
        [self.view insertSubview:everyPKShowHeadView atIndex:self.view.subviews.count-1];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark -
- (void)creatHeadCollectionView {
    everyPKShowHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 40)];
    everyPKShowHeadView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:everyPKShowHeadView];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(Screen_width-45, 0, 40, 40);
    [rightButton setImage:[[UIImage imageNamed:@"xiangxiajiantou.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [everyPKShowHeadView addSubview:rightButton];
    
    UICollectionViewFlowLayout *showHeadLayout = [[UICollectionViewFlowLayout alloc] init];
    [showHeadLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    showHeadLayout.minimumInteritemSpacing = 0.f;
    showHeadLayout.minimumLineSpacing = 0.f;
    
    headCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_width-50, 40) collectionViewLayout:showHeadLayout];
    headCollectionView.backgroundColor = [UIColor clearColor];
    headCollectionView.tag = 2201;
    headCollectionView.dataSource = self;
    headCollectionView.delegate = self;
    
    [headCollectionView registerNib:[UINib nibWithNibName:@"PkEveryDayHeadViewCell" bundle:nil] forCellWithReuseIdentifier:@"PkEveryDayHeadViewCellId"];
    
    headCollectionView.showsHorizontalScrollIndicator = NO;
    headCollectionView.bounces = YES;
    headCollectionView.pagingEnabled = NO;
    [everyPKShowHeadView addSubview:headCollectionView];
    
    headLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, (Screen_width-50)/5-20, 2)];
    headLineView.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    [headCollectionView addSubview:headLineView];
}

#pragma mark - 选项按键响应事件
- (void)rightButtonClick:(UIButton *)button {
    if (!isShowAll) {
        [self anCollectionView];
    }else {
        [self closeCollectionView];
    }
}
//展开
- (void)anCollectionView {
    headLineView.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
    [showBackLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    showBackLayout.minimumInteritemSpacing = 0.f;
    showBackLayout.minimumLineSpacing = 0.f;
    headCollectionView.collectionViewLayout = showBackLayout;
    
    NSInteger hang = 0;
    hang = _headDataArr.count%5;
    if (hang == 0) {
        hang = _headDataArr.count/5;
    }else {
        hang = _headDataArr.count/5+1;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        everyPKShowHeadView.frame = CGRectMake(0, 0, Screen_width, hang*40);
        rightButton.transform = CGAffineTransformMakeRotation(M_PI);
        
        rightButton.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
        CGAffineTransform transform = rightButton.transform;
        transform = CGAffineTransformScale(transform, 1,1);
    }];
    
    headCollectionView.frame = CGRectMake(0, 0, Screen_width-50, hang*40);
    [headCollectionView reloadData];
    isShowAll = YES;
}
//关闭
- (void)closeCollectionView {
    headLineView.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    
    UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
    [showBackLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    showBackLayout.minimumInteritemSpacing = 0.f;
    showBackLayout.minimumLineSpacing = 0.f;
    headCollectionView.collectionViewLayout = showBackLayout;
    
    [UIView animateWithDuration:0.25 animations:^{
        everyPKShowHeadView.frame = CGRectMake(0, 0, Screen_width, 40);
        
        rightButton.transform = CGAffineTransformMakeRotation(0*M_PI/180);
        CGAffineTransform transform = rightButton.transform;
        transform = CGAffineTransformScale(transform, 1,1);
    }];
    
    headCollectionView.frame = CGRectMake(0, 0, Screen_width-50, 40);
    [headCollectionView reloadData];
    
    [headCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:touchIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    isShowAll = NO;
}

#pragma mark - 汇报
- (void)rightAction {
    [self performSegueWithIdentifier:@"EveryDayViewToReportView" sender:nil];
}

#pragma mark - 实现UIcollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _headDataArr.count;
}

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 2201) {
        return CGSizeMake((Screen_width-50)/5, 40);
    }
    return CGSizeMake(Screen_width, Screen_Height-64-40);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 2201) {
        static NSString *PkEveryDayHeadViewCellId = @"PkEveryDayHeadViewCellId";
        PkEveryDayHeadViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PkEveryDayHeadViewCellId forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PkEveryDayHeadViewCell" owner:self options:nil].lastObject;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        if (indexPath.row == touchIndex) {
            cell.titleLabel.textColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
        }
        
        if (_headDataArr.count) {
            EveryDayPKModel *model = (EveryDayPKModel *)_headDataArr[indexPath.row];
            cell.titleLabel.text = model.name;
        }
        
        return cell;
    }
    
    static NSString *PkEveryDayViewCellId = @"PkEveryDayViewCellId";
    PkEveryDayViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PkEveryDayViewCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PkEveryDayViewCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:240/255.0 alpha:1];
    
    if (_headDataArr.count) {
        EveryDayPKModel *model = (EveryDayPKModel *)_headDataArr[indexPath.row];
        [cell pkShowCollectionGetDataWithIndex:model];
    }
    
    [cell setNetBackEvery:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    
    //其他用户信息
    [cell setHeadButtonTouchu:^(EveryDPKPMModel *model) {
//        OtherUesrViewController *otherUserVC = MainStoryBoard(@"OtherUserInformationVCID");
//        otherUserVC.otherUserId = model.userId;
//        otherUserVC.otherName = model.nickname;
//        otherUserVC.otherPic = model.photourl;
//        [self.navigationController pushViewController:otherUserVC animated:YES];
        MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
        mineVC.userId = model.userId;
        [self.navigationController pushViewController:mineVC animated:YES];
    }];
    
    //其他用户汇报
    [cell setOtherCellTouch:^(EveryDPKPMModel *model) {
        MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
        mineVC.userId = model.userId;
        mineVC.isPK = YES;
        [self.navigationController pushViewController:mineVC animated:YES];
//        pushModel  = model;
//        [self performSegueWithIdentifier:@"EveryDayPKViewToOtherUserReportView" sender:nil];
    }];
    
    //跳转到当前用户的PK
    [cell setJumpToMineEveryDayPK:^{
        
        MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
        mineVC.userId = [NSString stringWithFormat:@"%@", User_ID];
        mineVC.isPK = YES;
        [self.navigationController pushViewController:mineVC animated:YES];
//        OtherUesrViewController *otherUserVC = MainStoryBoard(@"MineEveryDayPKVCID");
//        [self.navigationController pushViewController:otherUserVC animated:YES];
    }];
    
    return cell;
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 2201) {
        [self headLineViewScrollWithIndex:indexPath.row];
        touchIndex = indexPath.row;
        
        if (isShowAll) {
            [self closeCollectionView];
            [headCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }else {
            for (NSInteger i=0; i<_headDataArr.count; i++) {
                PkEveryDayHeadViewCell *cell = (PkEveryDayHeadViewCell *)[headCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
            }
            
            PkEveryDayHeadViewCell *cell = (PkEveryDayHeadViewCell *)[headCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            cell.titleLabel.textColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
        }
        
        [pkShowCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - UIScrollView实现协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {//减速到停止
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        if (scrollView.tag != 2201) {
            [self headLineViewScrollWithIndex:scrollView.contentOffset.x/Screen_width];
            [headCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrollView.contentOffset.x/Screen_width inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            
            for (NSInteger i=0; i<_headDataArr.count; i++) {
                PkEveryDayHeadViewCell *cell = (PkEveryDayHeadViewCell *)[headCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.titleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
            }
            
            touchIndex = scrollView.contentOffset.x/Screen_width;
            PkEveryDayHeadViewCell *cell = (PkEveryDayHeadViewCell *)[headCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:scrollView.contentOffset.x/Screen_width inSection:0]];
            cell.titleLabel.textColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
        }
    }
}

#pragma mark - 顶部线移动,
- (void)headLineViewScrollWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.15 animations:^{
        headLineView.frame = CGRectMake((Screen_width-50)/5*index+10, 30, (Screen_width-50)/5-20, 2);
    }];
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EveryDayPKViewToOtherUserReportView"]) {//其他用户汇报
        OtherUesrViewController *otherUserVC = segue.destinationViewController;
        otherUserVC.otherUserId = pushModel.userId;
        otherUserVC.otherName = pushModel.nickname;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
