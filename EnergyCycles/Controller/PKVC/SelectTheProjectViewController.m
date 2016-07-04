//
//  SelectTheProjectViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SelectTheProjectViewController.h"

#import "SelectProjectCollectionViewCell.h"
#import "PKSelectedModel.h"

@interface SelectTheProjectViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate> {
    UIButton *rightButton;
    
    NSMutableArray *_dataArr;
    NSMutableArray *_biaojiArr;
}

@end

@implementation SelectTheProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择项目";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:240/255.0 alpha:1];
    _dataArr = [[NSMutableArray alloc] init];
    _biaojiArr = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 0.f;
    
    self.selectProjectCollectionView.collectionViewLayout = layout;
    self.selectProjectCollectionView.backgroundColor = [UIColor clearColor];
    [self.selectProjectCollectionView registerNib:[UINib nibWithNibName:@"SelectProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SelectProjectCollectionViewCellId"];
    self.selectProjectCollectionView.showsVerticalScrollIndicator = NO;
    self.selectProjectCollectionView.showsHorizontalScrollIndicator = NO;
    
    //左按键
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    //右按键
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    [self getSelectProject];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 获取项目列表
- (void)getSelectProject {
    [[AppHttpManager shareInstance] getGetProjectWithPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                PKSelectedModel *model = [[PKSelectedModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            for (NSInteger i=0; i<_dataArr.count; i++) {
                [_biaojiArr addObject:@"0"];
                if (self.getChooseArr.count) {
                    PKSelectedModel *model = (PKSelectedModel *)_dataArr[i];
                    for (PKSelectedModel *subModel in self.getChooseArr) {
                        if ([subModel.myId isEqualToString:model.myId]) {
                            [_biaojiArr replaceObjectAtIndex:i withObject:@"1"];
                        }
                    }
                }
            }
            
            [self.selectProjectCollectionView reloadData];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 提交按键响应事件
- (void)rightAction {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *_chooseArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<_biaojiArr.count; i++) {
        if ([_biaojiArr[i] isEqualToString:@"1"]) {
            [_chooseArr addObject:_dataArr[i]];
        }
    }
    
    if (_chooseArr.count <= 0) {
        [SVProgressHUD showImage:nil status:@"至少选择一项"];
    }else {
        [dict setObject:_chooseArr forKey:@"dict"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isReportEveryPKView" object:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    return CGSizeMake(98, 110);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 20, 10);
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SelectProjectCollectionViewCellId = @"SelectProjectCollectionViewCellId";
    SelectProjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SelectProjectCollectionViewCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SelectProjectCollectionViewCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = 2401+indexPath.row;
    
    if (_dataArr.count) {
        PKSelectedModel *model = (PKSelectedModel *)_dataArr[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.picUrl]]];
        cell.titleLabel.text = model.name;
        cell.selectedImageView.image = [UIImage imageNamed:@""];
        if (self.getChooseArr.count) {
            for (PKSelectedModel *subModel in self.getChooseArr) {
                if ([model.myId isEqualToString:subModel.myId]) {
                    cell.selectedImageView.image = [UIImage imageNamed:@"31xuanze_.png"];
                }
            }
        }
    }
    
    return cell;
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//UICollectionView点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectProjectCollectionViewCell *cell = (SelectProjectCollectionViewCell *)[self.selectProjectCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    NSInteger touchuCellTag = cell.tag - 2401;
    if ([_biaojiArr[touchuCellTag] isEqualToString:@"0"]) {
        [_biaojiArr replaceObjectAtIndex:touchuCellTag withObject:@"1"];
        cell.selectedImageView.image = [UIImage imageNamed:@"31xuanze_.png"];
    }else {
        [_biaojiArr replaceObjectAtIndex:touchuCellTag withObject:@"0"];
        cell.selectedImageView.image = [UIImage imageNamed:@""];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
