//
//  EnergyCycleViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "EnergyCycleViewController.h"

#import "AppDelegate.h"
#import "EnergyShowBackCollectionCell.h"
#import "DetailViewController.h"
#import "AllTabModel.h"

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "OtherUesrViewController.h"

@interface EnergyCycleViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeneralDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate> {
    BMKGeoCodeSearch* _geocodesearch;
    
    UIView *headLineView;
    
    CGFloat space;
    CGFloat kong;
    
    NSMutableArray *_btnArr;
    NSMutableArray *tabArr;
    EnergyCycleShowCellModel *energyModel;
    NSInteger cellIndex;
    
    NSInteger indexTag;
}

@property (weak, nonatomic) IBOutlet UIView *energyHeadView;

@property (nonatomic, strong) BMKLocationService *locService;


@end

@implementation EnergyCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnArr = [[NSMutableArray alloc] init];
    tabArr = [[NSMutableArray alloc] init];
    space = 55.f;
    kong = (Screen_width - 55*4)/8;
    indexTag = 2001;
        
    UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
    [showBackLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    showBackLayout.minimumInteritemSpacing = 0.f;
    showBackLayout.minimumLineSpacing = 0.f;
    self.showBackCollectionView.collectionViewLayout = showBackLayout;
    self.showBackCollectionView.backgroundColor = [UIColor whiteColor];
    [self.showBackCollectionView registerNib:[UINib nibWithNibName:@"EnergyShowBackCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"EnergyShowBackCollectionCellId"];
    
    self.showBackCollectionView.showsHorizontalScrollIndicator = NO;
    self.showBackCollectionView.bounces = NO;
    self.showBackCollectionView.pagingEnabled = YES;
    
    [self.postButton setBackgroundImage:[UIImage imageNamed:@"write_normal.png"] forState:UIControlStateNormal];
    [self.postButton setBackgroundImage:[UIImage imageNamed:@"write_pressed.png"] forState:UIControlStateHighlighted];
    
    //创建右按键
    NSArray *imageArr = @[@"+user_normal.png",@"calendar_normal.png"];
    NSMutableArray *itemBtnArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<imageArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 32.5, 30);
        [button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        
        button.tag = 1001 + i;
        [button addTarget:self action:@selector(energyRightActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        [itemBtnArr addObject:item];
    }
    self.navigationItem.rightBarButtonItems = itemBtnArr;
    
    //获取tab的值
    [self getTabList];
    
    //百度地图
    BMKMapManager* _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"kcQGh9RZFYVnhyHtdF1mtqIj" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewBackButtonClick:) name:@"isLoginViewBackButtonClick" object:nil];
}

#pragma mark -
- (void)loginViewBackButtonClick:(NSNotification *)notification {
    for (NSInteger i=0; i<_btnArr.count; i++) {
        UIButton *ibtn = (UIButton *)_btnArr[i];
        [ibtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        
        if (i == 0) {
            [ibtn setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }

    [self headLineViewScrollWithIndex:0];
    [self.showBackCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:@"update"];
}

#pragma mark - 定位开始
- (void)willStartLocatingUser {
    NSLog(@"start locate");
}

#pragma mark - 获得到位置
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(!flag) {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - 定位失败
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"location error");
}

#pragma mark - 反向地址编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        NSString *addRessStr = @"";
        
        NSArray *itemArr = [item.title componentsSeparatedByString:@"区"];
        if ([itemArr[0] isEqualToString:@"新疆维吾尔族自治"] || [itemArr[0] isEqualToString:@"西藏自治"] || [itemArr[0] isEqualToString:@"内蒙古自治"] || [itemArr[0] isEqualToString:@"宁夏回族自治"] || [itemArr[0] isEqualToString:@"广西壮族自治"]) {
            if (itemArr.count > 2) {
                addRessStr = [NSString stringWithFormat:@"%@%@%@%@",itemArr.firstObject,@"区",itemArr[1],@"区"];
            }else if (itemArr.count == 2) {
                NSArray *subSubItemArr = [itemArr.lastObject componentsSeparatedByString:@"县"];
                if (subSubItemArr.count <= 1) {
                    subSubItemArr = [itemArr.lastObject componentsSeparatedByString:@"旗"];
                    if (itemArr.count <= 1) {
                        subSubItemArr = [itemArr.lastObject componentsSeparatedByString:@"市"];
                        addRessStr = [NSString stringWithFormat:@"%@%@%@%@",itemArr.firstObject,@"区",subSubItemArr.firstObject,@"市"];
                    }else {
                        addRessStr = [NSString stringWithFormat:@"%@%@%@%@",itemArr.firstObject,@"区",subSubItemArr.firstObject,@"旗"];
                    }
                }else {
                    addRessStr = [NSString stringWithFormat:@"%@%@%@%@",itemArr.firstObject,@"区",subSubItemArr.firstObject,@"县"];
                }
            }else {
                addRessStr = [NSString stringWithFormat:@"%@%@",itemArr.firstObject,@"区"];
            }
        }else {
            if (itemArr.count <= 1) {
                itemArr = [item.title componentsSeparatedByString:@"县"];
                if (itemArr.count <= 1) {
                    itemArr = [item.title componentsSeparatedByString:@"旗"];
                    if (itemArr.count <= 1) {
                        itemArr = [item.title componentsSeparatedByString:@"市"];
                        addRessStr = [NSString stringWithFormat:@"%@%@",itemArr.firstObject,@"市"];
                    }else {
                        addRessStr = [NSString stringWithFormat:@"%@%@",itemArr.firstObject,@"旗"];
                    }
                }else {
                    addRessStr = [NSString stringWithFormat:@"%@%@",itemArr.firstObject,@"县"];
                }
            }else {
                addRessStr = [NSString stringWithFormat:@"%@%@",itemArr.firstObject,@"区"];
            }
        }

        [[NSUserDefaults standardUserDefaults] setObject:addRessStr forKey:@"AddRessStr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]resignFirstResponder];

    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
}

#pragma  mark--获取网络数据
- (void)getTabList {
    [[AppHttpManager shareInstance] getGetTabOfArticleWithPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                AllTabModel *model = [[AllTabModel alloc] initWithDictionary:subDict error:nil];
                [tabArr addObject:model];
            }
            [self createHeadBackButtonWithArr:tabArr];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 创建顶部按键
- (void)createHeadBackButtonWithArr:(NSArray *)arr {
    NSMutableArray *titleArr = [[NSMutableArray alloc] init];
    for (AllTabModel *model in arr) {
        [titleArr addObject:model.name];
    }
    
    for (NSInteger i=0; i<titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(Screen_width/4 * i, 5, Screen_width/4, 32);
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        btn.tag = 2001 + i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        }
        
        [self.energyHeadView addSubview:btn];
        [_btnArr addObject:btn];
    }
    
    headLineView = [[UIView alloc] initWithFrame:CGRectMake(kong, 37, space, 2)];
    headLineView.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    [self.energyHeadView addSubview:headLineView];
    
    UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, Screen_width, 1)];
    grayLineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.energyHeadView addSubview:headLineView];
    [self.energyHeadView insertSubview:grayLineView aboveSubview:headLineView];
    
    [self.showBackCollectionView reloadData];
}

#pragma mark - 跳转到签到、邀请界面
- (void)energyRightActionWithBtn:(UIButton *)btn {
    if (btn.tag == 1002) {//签到
        if ([User_TOKEN length] <= 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
        }else {
            [self performSegueWithIdentifier:@"EnergyCycleViewToSignInView" sender:nil];
        }
    }else { //邀请
        [self performSegueWithIdentifier:@"EnergyCycleViewToInviteView" sender:nil];
    }
}

#pragma mark - 实现UIcollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_width, Screen_Height-64-40-49);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *EnergyShowBackCollectionCellId = @"EnergyShowBackCollectionCellId";
    EnergyShowBackCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EnergyShowBackCollectionCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EnergyShowBackCollectionCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:240/255.0 alpha:1];
    
    //判断跳转界面 详情界面
    [cell setEnergyCycleCellBlock:^(EnergyCycleShowCellModel *cellModel, NSInteger touchIndex) {
        energyModel = cellModel;
        cellIndex = touchIndex;
        [self performSegueWithIdentifier:@"EnergyCyclesViewToDetailView" sender:nil];
    }];
    
    //其他人信息
    [cell setEnergyCycleHeadBlock:^(EnergyMainModel *model) {
        OtherUesrViewController *otherUserVC = MainStoryBoard(@"OtherUserInformationVCID");
        otherUserVC.otherUserId = model.userId;
        otherUserVC.otherName = model.nickName;
        otherUserVC.otherPic = model.photoUrl;
        [self.navigationController pushViewController:otherUserVC animated:YES];
    }];
    
    
    if (tabArr.count) {
        AllTabModel *model = (AllTabModel *)tabArr[indexPath.row];
        if ([model.name isEqualToString:@"关注"]) {
            if ([User_TOKEN length] <= 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
            }else {
                [cell energyShowCollectionGetDataWithIndex:[model.enId integerValue]];
            }
        }else {
            [cell energyShowCollectionGetDataWithIndex:[model.enId integerValue]];
        }
    }
    
    return cell;
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UIScrollView实现协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {//减速到停止
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [self headLineViewScrollWithIndex:scrollView.contentOffset.x/Screen_width];
        
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

#pragma mark - 顶部线移动,
- (void)headLineViewScrollWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.15 animations:^{
        headLineView.frame = CGRectMake(kong+space*index+kong*(2*index), 37, space, 2);
    }];
}

#pragma mark - 顶部button点击响应事件
- (void)buttonClick:(UIButton *)btn {
    if (indexTag != btn.tag) {
        indexTag = btn.tag;
        for (NSInteger i=0; i<_btnArr.count; i++) {
            UIButton *ibtn = (UIButton *)_btnArr[i];
            [ibtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        [self headLineViewScrollWithIndex:btn.tag-2001];
        [self.showBackCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-2001 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:@"update"];
    }
}

#pragma mark - 发帖按键响应事件
- (IBAction)postButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"EnergyCycleViewToPostView" sender:nil];
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EnergyCyclesViewToDetailView"]) {
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.tabBarStr = @"home";
        detailVC.showTitle = energyModel.artTitle;
        detailVC.showDetailId = energyModel.artId;
        detailVC.touchIndex = cellIndex;
        detailVC.isMine = @"0";
        detailVC.videoUrl = energyModel.videoUrl;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
