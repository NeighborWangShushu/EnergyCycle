//
//  MyNewsViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MyNewsViewController.h"

#import "NewsCollectionViewCell.h"
#import "NewsTwoCollectionViewCell.h"

#import "NewDetailViewController.h"
#import "ChatViewController.h"
#import "ActiveDetailViewController.h"

@interface MyNewsViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    UIView *lineView;
    NSMutableArray *_btnArr;
    NSInteger touchIndex;
    
    InformationModel *myInforModel;
    MessageModel *myMessageModel;
    NSString *type;
    NSString *touchIndexStr;
    
    UIView *pointView1;
    UIView *pointView2;
    UIView *pointView3;
}

@end

@implementation MyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的消息";
    _btnArr = [[NSMutableArray alloc] init];
    touchIndex = 0;
    
    UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
    [showBackLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    showBackLayout.minimumInteritemSpacing = 0.f;
    showBackLayout.minimumLineSpacing = 0.f;
    myNewsCollectionView.collectionViewLayout = showBackLayout;
    myNewsCollectionView.backgroundColor = [UIColor whiteColor];
    [myNewsCollectionView registerNib:[UINib nibWithNibName:@"NewsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NewsCollectionViewCellId"];
    [myNewsCollectionView registerNib:[UINib nibWithNibName:@"NewsTwoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NewsTwoCollectionViewCellID"];
    
    myNewsCollectionView.showsHorizontalScrollIndicator = NO;
    myNewsCollectionView.bounces = NO;
    myNewsCollectionView.pagingEnabled = YES;
    myNewsCollectionView.scrollEnabled = NO;
    
    //
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    [self creatUpButton];
    
    //消息中心,监听是否收到推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsAppGetJPush:) name:@"isAppGetJPush" object:nil];
}

- (void)newsAppGetJPush:(NSNotification *)notigfication {
    NSDictionary *dict = [notigfication object];
    if ([dict[@"type"] integerValue] == 1) {//通知
        if (touchIndex == 0) {//刷新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isNewsRefresh" object:nil];
        }else {
            pointView1.backgroundColor = [UIColor redColor];
        }
    }else if ([dict[@"type"] integerValue] == 2) {//活动
        if (touchIndex == 2) {//刷新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isNewsRefresh" object:nil];
        }else {
            pointView2.backgroundColor = [UIColor redColor];
        }
    }else {//私信
        if (touchIndex == 1) {//刷新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isNewsRefresh" object:nil];
        }else {
            pointView3.backgroundColor = [UIColor redColor];
        }
    }
    
    EnetgyCycle.isHaveJPush = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    EnetgyCycle.isAtInformationView = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    EnetgyCycle.isAtInformationView = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)creatUpButton {
    NSArray *titleArr = @[@"通知",@"私信",@"活动"];
    
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
        
        [self.headBackView addSubview:button];
        [_btnArr addObject:button];
        
        if (i == 0) {
            pointView1 = [[UIView alloc] initWithFrame:CGRectMake(space-(40*Screen_width/375), 15, 8, 8)];
            pointView1.backgroundColor = [UIColor whiteColor];
            pointView1.layer.masksToBounds = YES;
            pointView1.layer.cornerRadius = 4.f;
            [button addSubview:pointView1];
        }else if (i == 1) {
            pointView3 = [[UIView alloc] initWithFrame:CGRectMake(space-(40*Screen_width/375), 15, 8, 8)];
            pointView3.backgroundColor = [UIColor whiteColor];
            pointView3.layer.masksToBounds = YES;
            pointView3.layer.cornerRadius = 4.f;
            [button addSubview:pointView3];
        }else {
            pointView2 = [[UIView alloc] initWithFrame:CGRectMake(space-(40*Screen_width/375), 15, 8, 8)];
            pointView2.backgroundColor = [UIColor whiteColor];
            pointView2.layer.masksToBounds = YES;
            pointView2.layer.cornerRadius = 4.f;
            [button addSubview:pointView2];
        }
        
        NSArray *typeArr = [[NSString stringWithFormat:@"%@",self.pushType] componentsSeparatedByString:@","];
        NSMutableDictionary *typeDict = [[NSMutableDictionary alloc] init];
        for (NSString *str in typeArr) {
            [typeDict setObject:str forKey:str];
        }
        for (NSString *str in typeDict.allValues) {
            if ([str integerValue] == 1) {
//                pointView1.backgroundColor = [UIColor redColor];
            }else if ([str integerValue] == 2) {
                pointView2.backgroundColor = [UIColor redColor];
            }else if ([str integerValue] == 3) {
                pointView3.backgroundColor = [UIColor redColor];
            }
        }
    }
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, space, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    [self.headBackView addSubview:lineView];
    
    UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, Screen_width, 0.5)];
    downLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    [self.headBackView addSubview:downLineView];
}

- (void)upButtonClcik:(UIButton *)button {
    for (UIButton *btn in _btnArr) {
        [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [self newsLineMoveWithIndex:button.tag-4011];
    touchIndex = button.tag-4011;
    
    //
    if (touchIndex == 0) {
        pointView1.backgroundColor = [UIColor whiteColor];
    }else if (touchIndex == 1) {
        pointView3.backgroundColor = [UIColor whiteColor];
    }else {
        pointView2.backgroundColor = [UIColor whiteColor];
    }
    
    [myNewsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:button.tag-4011 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
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
    if (indexPath.row == 1) {
        static NSString *NewsTwoCollectionViewCellID = @"NewsTwoCollectionViewCellID";
        NewsTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewsTwoCollectionViewCellID forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NewsTwoCollectionViewCell" owner:self options:nil].lastObject;
        }
        cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [cell creatInformationCollectionViewWithIndex:indexPath.row];
        
        [cell setNetTwoBack:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
        //私信界面
        [cell setMessageTwoShowSelectCell:^(MessageModel *model, NSInteger touIndex) {
            myMessageModel = model;
            touchIndexStr = [NSString stringWithFormat:@"%ld",(long)touIndex];
            [self performSegueWithIdentifier:@"MyNewsToChatView" sender:nil];
        }];
        
        return cell;
    }
    
    static NSString *NewsCollectionViewCellId = @"NewsCollectionViewCellId";
    NewsCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NewsCollectionViewCellId forIndexPath:indexPath];
    if (collectionCell == nil) {
        collectionCell = [[[NSBundle mainBundle] loadNibNamed:@"NewsCollectionViewCell" owner:self options:nil] lastObject];
    }
    collectionCell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [collectionCell creatInformationCollectionViewWithIndex:indexPath.row];
    
    [collectionCell setNetBack:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    //通知详情
    [collectionCell setInformationShowSelectCell:^(InformationModel *model, NSInteger touIndex) {
        myInforModel = model;
        type = @"1";
        touchIndexStr = [NSString stringWithFormat:@"%ld",(long)touIndex];
//        [self performSegueWithIdentifier:@"NewViewToDetailView" sender:nil];
        [self performSegueWithIdentifier:@"NewViewToActiveDetailView" sender:nil];
    }];
    
//    //私信界面
//    [collectionCell setMessageShowSelectCell:^(MessageModel *model, NSInteger touIndex) {
//        myMessageModel = model;
//        touchIndexStr = [NSString stringWithFormat:@"%ld",(long)touIndex];
//        [self performSegueWithIdentifier:@"MyNewsToChatView" sender:nil];
//    }];
    
    //活动详情
    [collectionCell setActiveShowSelectCell:^(InformationModel *model, NSInteger touIndex) {
        myInforModel = model;
        type = @"2";
        touchIndexStr = [NSString stringWithFormat:@"%ld",(long)touIndex];
        [self performSegueWithIdentifier:@"NewViewToActiveDetailView" sender:nil];
    }];
    
    return collectionCell;
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

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MyNewsToChatView"]) {
        ChatViewController *chatVC = segue.destinationViewController;
        chatVC.otherID = myMessageModel.MessagePeople;
        chatVC.otherName = myMessageModel.nickname;
        chatVC.otherPic = @"";
        chatVC.touchIndex = touchIndexStr;
    }else if ([segue.identifier isEqualToString:@"NewViewToDetailView"]) {
        NewDetailViewController *newDetailVC = segue.destinationViewController;
        newDetailVC.model = myInforModel;
    }else if ([segue.identifier isEqualToString:@"NewViewToActiveDetailView"]) {
        ActiveDetailViewController *activeVC = segue.destinationViewController;
        activeVC.model = myInforModel;
        activeVC.type = type;
        activeVC.touchIndex = touchIndexStr;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
