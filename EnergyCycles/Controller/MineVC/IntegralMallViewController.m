//
//  IntegralMallViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "IntegralMallViewController.h"

#import "InterMallCollectionViewCell.h"
#import "DrawCashViewController.h"

#import "MallModel.h"

@interface IntegralMallViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    int page;
    NSMutableArray *_dataArr;
    
    NSInteger collectionTouchIndex;
}

@end

@implementation IntegralMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分商城";
    page = 1;
    _dataArr = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
    [showBackLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    showBackLayout.minimumInteritemSpacing = 5.f;
    showBackLayout.minimumLineSpacing = 5.f;
    InterMallCollectionView.collectionViewLayout = showBackLayout;
    InterMallCollectionView.backgroundColor = [UIColor whiteColor];
    [InterMallCollectionView registerNib:[UINib nibWithNibName:@"InterMallCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"InterMallCollectionViewCellId"];
    
    InterMallCollectionView.showsVerticalScrollIndicator = NO;
    InterMallCollectionView.bounces = YES;
    InterMallCollectionView.pagingEnabled = NO;
    
    [self setCollectionMJRefresh];
    [self getNetDataWithPage:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.navigationController.navigationBarHidden = YES;
    
    //积分
    [self.numButton setTitle:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserJiFen"]] forState:UIControlStateNormal];
}

#pragma mark - 返回按键
- (IBAction)leftButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 兑换记录
- (IBAction)rightButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"InterMallViewToForRecordView" sender:nil];
}

#pragma mark - 我的积分
- (IBAction)numButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"InterMallViewToMyPointView" sender:nil];
}

#pragma mark - 集成刷新
- (void)setCollectionMJRefresh {
    // 上拉加载更多
    __unsafe_unretained __typeof(self) weakSelf = self;
    InterMallCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf getNetDataWithPage:page];
    }];
    // 默认先隐藏footer
    InterMallCollectionView.mj_footer.hidden = YES;
}

#pragma mark - 获取网络数据
- (void)getNetDataWithPage:(int)pages {
    [[AppHttpManager shareInstance] getGetMerchantListWithPage:pages PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                MallModel *model = [[MallModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            [InterMallCollectionView reloadData];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        
    }];
    [InterMallCollectionView.mj_footer endRefreshing];
}

#pragma mark - 实现UIcollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_width/2-12-2.5, 220);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 12, 10, 12);
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *InterMallCollectionViewCellId = @"InterMallCollectionViewCellId";
    InterMallCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:InterMallCollectionViewCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InterMallCollectionViewCell" owner:self options:nil] lastObject];
    }
    
    if (_dataArr.count) {
        MallModel *model = (MallModel *)_dataArr[indexPath.row];
        [cell creatCollectionViewWithModel:model];
    }
    
    cell.layer.borderWidth = 1.f;
    cell.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1].CGColor;
    
    return cell;
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - CollectionView点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    collectionTouchIndex = indexPath.row;
    [self performSegueWithIdentifier:@"MallViewToDrawCashView" sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MallViewToDrawCashView"]) {
        DrawCashViewController *drawCashVC = segue.destinationViewController;
        if (_dataArr.count) {
            MallModel *model = (MallModel *)_dataArr[collectionTouchIndex];
            drawCashVC.getMallModel = model;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
