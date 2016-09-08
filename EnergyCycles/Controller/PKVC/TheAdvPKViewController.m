//
//  TheAdvPKViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/29.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TheAdvPKViewController.h"

#import "DetailViewController.h"
#import "TheAdvPKCollectionViewCell.h"
#import "ThePizeViewController.h"

#import "TheAdvTabModel.h"
#import "TheAdvMainModel.h"

#import "OtherUesrViewController.h"
#import "WebVC.h"
#import "MineHomePageViewController.h"

#import "WebVC.h"
#import "TheAdvPKDetailVC.h"

@interface TheAdvPKViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate> {
    UIView *headLineView;
    NSMutableArray *_btnArr;
    NSMutableArray *_dataArr;
    NSInteger _changPage;
    
    NSMutableArray *_tabArr;
    TheAdvMainModel *mainTouchModel;
    NSString *awarID;
    NSInteger cellIndex;
}

@end

@implementation TheAdvPKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"进阶PK";
    
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    _changPage=0;
    _btnArr = [[NSMutableArray alloc] init];
    _dataArr=[NSMutableArray array];
    _tabArr = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
    [showBackLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    showBackLayout.minimumInteritemSpacing = 0.f;
    showBackLayout.minimumLineSpacing = 0.f;
    
    self.theAdvPKCollectionView.collectionViewLayout = showBackLayout;
    self.theAdvPKCollectionView.dataSource = self;
    self.theAdvPKCollectionView.delegate = self;
    self.theAdvPKCollectionView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:240/255.0 alpha:1];
    [self.theAdvPKCollectionView registerNib:[UINib nibWithNibName:@"TheAdvPKCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TheAdvPKCollectionViewCellId"];
    
    self.theAdvPKCollectionView.showsHorizontalScrollIndicator = NO;
    self.theAdvPKCollectionView.bounces = NO;
    self.theAdvPKCollectionView.pagingEnabled = YES;
    self.theAdvPKCollectionView.scrollEnabled = NO;
    
    [self getTheAdvTabList];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 获取tab
- (void)getTheAdvTabList {
    [[AppHttpManager shareInstance] getGetTabOfPostWithPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                TheAdvTabModel *model = [[TheAdvTabModel alloc] initWithDictionary:subDict error:nil];
                [_tabArr addObject:model];
            }
            [self creatTableViewHeadViewWithTitleArr:_tabArr];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 创建视图
- (void)creatTableViewHeadViewWithTitleArr:(NSArray *)titleArr {
    UIView *oneBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 40)];
    oneBackView.backgroundColor = [UIColor whiteColor];
    [self.headBackView addSubview:oneBackView];
    
    for (NSInteger i=0; i<titleArr.count; i++) {
        TheAdvTabModel *model = (TheAdvTabModel *)titleArr[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(Screen_width/3*i, 5, Screen_width/3, 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        }
        btn.tag = 2201+i;
        [btn addTarget:self action:@selector(advpkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [oneBackView addSubview:btn];
        [_btnArr addObject:btn];
    }
    
    headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, Screen_width/3, 1.5)];
    headLineView.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    [self.headBackView addSubview:headLineView];
    
    UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, Screen_width, 0.5)];
    downLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.headBackView addSubview:downLineView];
    
    [self.theAdvPKCollectionView reloadData];
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
    self.headBackViewAutoLayoutContent.constant = 40.f;
    return CGSizeMake(Screen_width, Screen_Height-138+38);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TheAdvPKCollectionViewCellId = @"TheAdvPKCollectionViewCellId";
    TheAdvPKCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:TheAdvPKCollectionViewCellId forIndexPath:indexPath];
  
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TheAdvPKCollectionViewCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    [cell setNetAdvBack:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    
    //跳转到奖品界面
    [cell setGetAwardNameAndID:^(NSString *name, NSString *ID) {
        awarID = ID;
        [self performSegueWithIdentifier:@"TheAdvPKViewToThePrizeView" sender:nil];
    }];
    
    //进阶详情
    [cell setTheAdvPKCollectionView:^(TheAdvMainModel *model,NSInteger cellTouchIndex) {
        mainTouchModel = model;
        cellIndex = cellTouchIndex;

//        WebVC *webVC = MainStoryBoard(@"WebVC");
//        webVC.titleName = @"动态详情";
//       NSString *loadStr = [NSString stringWithFormat:@"%@/%@?postId=%@&userId=%@",INTERFACE_URL,PostDetailAspx,mainTouchModel.postId,User_ID];
//        webVC.url = loadStr;
//=======
//        [self performSegueWithIdentifier:@"TheAdvPKViewToDetailView" sender:nil];
        TheAdvPKDetailVC *detailVC = [[TheAdvPKDetailVC alloc] init];
        detailVC.titleName = @"进阶PK详情";
        detailVC.model = model;
        detailVC.url = [NSString stringWithFormat:@"%@%@?postId=%@&userId=%@",INTERFACE_URL,PostDetailAspx,model.postId,[NSString stringWithFormat:@"%@",model.userId]];

        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    
    //其他人信息
    [cell setJumpToOtherInformation:^(TheAdvMainModel *model) {
        MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
        mineVC.userId = model.userId;
        [self.navigationController pushViewController:mineVC animated:YES];
//        OtherUesrViewController *otherUserVC = MainStoryBoard(@"OtherUserInformationVCID");
//        otherUserVC.otherUserId = model.userId;
//        otherUserVC.otherName = model.nickName;
//        otherUserVC.otherPic = model.photoUrl;
//        [self.navigationController pushViewController:otherUserVC animated:YES];
    }];
    
    if (_tabArr.count) {
        TheAdvTabModel *model = (TheAdvTabModel *)_tabArr[indexPath.row];
        [cell advPKShowCollectionGetDataWithIndex:[model.myId intValue]];
    }
    
    return cell;
}

- (void)detailRightActionWithBtn {
    NSLog(@"testtesttesttest");
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
}

#pragma mark - UIScrollView实现协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {//减速到停止
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [self headLineViewAnimationWithIndex:scrollView.contentOffset.x/Screen_width];
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

#pragma mark - 头按键响应事件
- (void)advpkButtonClick:(UIButton *)btn {
    if (btn.tag == 2203) {
        if (User_TOKEN.length <= 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
            return;
        }
    }
    
    for (UIButton *button in _btnArr) {
        [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    }
    
    [btn setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [self headLineViewAnimationWithIndex:btn.tag-2201];
    [self.theAdvPKCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-2201 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - 线滑动
- (void)headLineViewAnimationWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.25 animations:^{
        headLineView.frame = CGRectMake(Screen_width/3*index, 38, Screen_width/3, 2);
    }];
}

#pragma mark - 跳转到发帖界面
- (IBAction)theAdvPostButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"PKViewToTheAdvPKPostView" sender:nil];
}

#pragma mark - Navigation 传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"TheAdvPKViewToDetailView"]) {
//        DetailViewController *detailVC = segue.destinationViewController;
//        detailVC.tabBarStr = @"pk";
//        detailVC.showTitle = mainTouchModel.title;
//        detailVC.showDetailId = mainTouchModel.postId;
//        detailVC.advModel = mainTouchModel;
//        detailVC.touchIndex = cellIndex;
//        detailVC.videoUrl = mainTouchModel.videoUrl;
//    }else
    if ([segue.identifier isEqualToString:@"TheAdvPKViewToThePrizeView"]) {
        ThePizeViewController *pizeVC = segue.destinationViewController;
        pizeVC.waradID = awarID;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
