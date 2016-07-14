//
//  PKViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PKViewController.h"

#import "PKHomeViewCell.h"
#import "PkHomeCollectionViewCell.h"
#import "PKHomeModel.h"
#import "WDTwoScrollView.h"

@interface PKViewController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate> {
    UICollectionView *showCollectionView;
    
    NSMutableArray *_homeCollecctionArr;
}

@end

@implementation PKViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    
    //获取collectionView网络数据
    [self getPKHeadCollectionViewData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _homeCollecctionArr = [[NSMutableArray alloc] init];
    
    pkHomeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pkHomeTableView.showsVerticalScrollIndicator = NO;
    pkHomeTableView.showsHorizontalScrollIndicator = NO;
    pkHomeTableView.backgroundColor = [UIColor whiteColor];
    pkHomeTableView.bounces = YES;
}


#pragma mark - 获得网络数据
- (void)getPKHeadCollectionViewData {
    [[AppHttpManager shareInstance] getGetADVWithPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"IsSuccess"] integerValue] == 1 && [dict[@"Code"] integerValue] == 200) {
            [_homeCollecctionArr removeAllObjects];
            for (NSDictionary *subDict in dict[@"Data"]) {
                PKHomeModel *model = [[PKHomeModel alloc] initWithDictionary:subDict error:nil];
                [_homeCollecctionArr addObject:model];
            }
            
            [pkHomeTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else {
            
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 180)];
        backImageView.image = [UIImage imageNamed:@"placepic.png"];
        [cell addSubview:backImageView];
        
        if (_homeCollecctionArr.count) {
            NSMutableArray *urlArr = [[NSMutableArray alloc] init];
            for (PKHomeModel *model in _homeCollecctionArr) {
                [urlArr addObject:model.picUrl];
            }
            
            WDTwoScrollView *twoScrollView = [[WDTwoScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 180) andLayout:WDScrollViewLayoutTiltleTopLeftPageControlBottomCenter];
            twoScrollView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:240/255.0 alpha:1];
            NSMutableArray *imageArr = [[NSMutableArray alloc] init];
            for (NSString *str in urlArr) {
                [imageArr addObject:[NSURL URLWithString:str]];
            }
            twoScrollView.imageArr = imageArr;
            
            [cell addSubview:twoScrollView];
        }
//        UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
//        [showBackLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//        showBackLayout.minimumInteritemSpacing = 15.f;
//        showBackLayout.minimumLineSpacing = 15.f;
//        
//        showCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 170) collectionViewLayout:showBackLayout];
//        showCollectionView.dataSource = self;
//        showCollectionView.delegate = self;
//        showCollectionView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:240/255.0 alpha:1];
//        [showCollectionView registerNib:[UINib nibWithNibName:@"PkHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PkHomeCollectionViewCellId"];
//        
//        showCollectionView.showsHorizontalScrollIndicator = NO;
//        showCollectionView.bounces = YES;
//        showCollectionView.pagingEnabled = NO;
//        [cell addSubview:showCollectionView];
        
        return cell;
    } 
    
    PKHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PKHomeViewCelliD"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1) {
        cell.titleLabel.text = @"每日PK";
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.downBackImageView.image = [UIImage imageNamed:@"meirix.png"];
    }else {
        cell.titleLabel.text = @"进阶PK";
        cell.downBackImageView.image = [UIImage imageNamed:@"placepic.png"];
        cell.downBackImageView.image = [UIImage imageNamed:@"jinjiex.png"];
    }
    
    cell.touchuButton.tag = 2001 + indexPath.section;
    [cell.touchuButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 10)];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return nil;
}

#pragma mark - button点击事件
- (void)cellButtonClick:(UIButton *)button {
    if (button.tag == 2002) {//每日PK
        if (User_TOKEN.length > 0) {
            [self performSegueWithIdentifier:@"PKViewToEveryDayPKview" sender:nil];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
        }
    }else {//进阶PK
        [self performSegueWithIdentifier:@"PKViewToTheAdvPKView" sender:nil];
    }
}

#pragma mark - 实现UIcollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _homeCollecctionArr.count;
}

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(315, 150);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 10);
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PkHomeCollectionViewCellId = @"PkHomeCollectionViewCellId";
    PkHomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:PkHomeCollectionViewCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PkHomeCollectionViewCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    if (_homeCollecctionArr.count) {
        PKHomeModel *model = (PKHomeModel *)_homeCollecctionArr[indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.picUrl]] placeholderImage:[UIImage imageNamed:@"placepic.png"]];
    }
    
    return cell;
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
