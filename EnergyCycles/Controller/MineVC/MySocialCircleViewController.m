//
//  MySocialCircleViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MySocialCircleViewController.h"

#import "SocialCollectionViewCell.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "OtherUesrViewController.h"

@interface MySocialCircleViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    NSMutableArray *_btnArr;
    UIView *lineView;
    
    NSInteger touchType;
    NSMutableArray *_dataArr;
    
    BOOL isRefresh;
}

@end

@implementation MySocialCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    self.title = @"我的社交圈";
    
    _btnArr = [[NSMutableArray alloc] init];
    _dataArr = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
    [showBackLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    showBackLayout.minimumInteritemSpacing = 0.f;
    showBackLayout.minimumLineSpacing = 0.f;
    mySocialCircleCollectionView.collectionViewLayout = showBackLayout;
    mySocialCircleCollectionView.backgroundColor = [UIColor whiteColor];
    [mySocialCircleCollectionView registerNib:[UINib nibWithNibName:@"SocialCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SocialCollectionViewCellId"];
    
    mySocialCircleCollectionView.showsHorizontalScrollIndicator = NO;
    mySocialCircleCollectionView.bounces = NO;
    mySocialCircleCollectionView.pagingEnabled = YES;
    mySocialCircleCollectionView.scrollEnabled = NO;
    
    //
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    [self creatUpButton];
    
    //
    if (![self.showType isEqualToString:@"关注"] && ![self.showType isEqualToString:@"粉丝"]) {
        isRefresh = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    
    if ([self.showType isEqualToString:@"关注"]) {
        [self getShowTypeShowWith:1];
    }else if ([self.showType isEqualToString:@"粉丝"]) {
        [self getShowTypeShowWith:2];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    isRefresh = YES;
    if ([self.showType isEqualToString:@"关注"]) {
        [mySocialCircleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else if ([self.showType isEqualToString:@"粉丝"]) {
        [mySocialCircleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)creatUpButton {
    NSArray *titleArr = @[@"好友",@"关注",@"粉丝"];
    
    CGFloat space = Screen_width/3;
    for (NSInteger i=0; i<titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(space*i, 0, space, 38);
        
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = 4011 + i;
        [button addTarget:self action:@selector(upButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.soicalHeadView addSubview:button];
        [_btnArr addObject:button];
    }
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, space, 1.5)];
    lineView.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    [self.soicalHeadView addSubview:lineView];
    
    UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, Screen_width, 0.5)];
    downLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    [self.soicalHeadView addSubview:downLineView];
}

#pragma mark -
- (void)upButtonClcik:(UIButton *)button {
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    
    [self newsLineMoveWithIndex:button.tag-4011];
    [mySocialCircleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:button.tag-4011 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark -
- (void)getShowTypeShowWith:(NSInteger)index {
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    }
    UIButton *btn = (UIButton *)[self.view viewWithTag:4011+index];
    [btn setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    
    [self newsLineMoveWithIndex:index];
}

- (void)newsLineMoveWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.15 animations:^{
        lineView.frame = CGRectMake(Screen_width/3*index, 38, Screen_width/3, 2);
    }];
}

#pragma mark - 实现UIcollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_width, Screen_Height-64-40);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SocialCollectionViewCellId = @"SocialCollectionViewCellId";
    SocialCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SocialCollectionViewCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SocialCollectionViewCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [cell updateDataWithType:indexPath.row withIsRefresh:isRefresh];
    
    [cell setSoicalTouchIndex:^(UserModel *model) {
        OtherUesrViewController *otherUserVC = MainStoryBoard(@"OtherUserInformationVCID");
        otherUserVC.otherUserId = model.use_id;
        otherUserVC.otherName = model.nickname;
        otherUserVC.otherPic = model.photourl;
        [self.navigationController pushViewController:otherUserVC animated:YES];
    }];
    
    return cell;
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UIScrollView实现协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {//减速到停止
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [self newsLineMoveWithIndex:scrollView.contentOffset.x/Screen_width];
        
        for (NSInteger i=0; i<_btnArr.count; i++) {
            UIButton *ibtn = (UIButton *)_btnArr[i];
            if (i == scrollView.contentOffset.x/Screen_width) {
                [ibtn setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
            }else {
                [ibtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
