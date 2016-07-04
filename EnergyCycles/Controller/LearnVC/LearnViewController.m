//
//  LearnViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LearnViewController.h"

#import "LearnShowCollectionViewCell.h"
#import "LearnShowTwoCollectionViewCell.h"
#import "LearnViewShowModel.h"
#import "LearnTabModel.h"

#import "OtherUserReportViewController.h"
#import "OtherUesrViewController.h"
#import "LearnDetailViewController.h"
#import "HMSegmentedControl.h"


@interface LearnViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate> {
    
    UIView *headLineView;
    NSMutableArray *_btnArr;
    CGFloat space;
    CGFloat kong;
    NSMutableArray *tabArr;
    NSMutableArray * _zanArray;
    NSMutableArray * _caiArray;
    NSMutableArray * items;
}

@property (nonatomic,strong)HMSegmentedControl * segmentController;

@end


@implementation LearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnArr = [[NSMutableArray alloc] init];
    tabArr = [[NSMutableArray alloc] init];
    _zanArray=[NSMutableArray array];
    _caiArray=[NSMutableArray array];
    space = 55.f;
    kong = (Screen_width - 55*4)/8;
    
    
    UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
    [showBackLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    showBackLayout.minimumInteritemSpacing = 0.f;
    showBackLayout.minimumLineSpacing = 0.f;
    self.learnShowCollectionView.collectionViewLayout = showBackLayout;
    self.learnShowCollectionView.backgroundColor = [UIColor whiteColor];
    [self.learnShowCollectionView registerNib:[UINib nibWithNibName:@"LearnShowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LearnShowCollectionViewCellID"];
    [self.learnShowCollectionView registerNib:[UINib nibWithNibName:@"LearnShowTwoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LearnShowTwoCollectionViewCellID"];
    
    self.learnShowCollectionView.showsHorizontalScrollIndicator = NO;
    self.learnShowCollectionView.bounces = NO;
    self.learnShowCollectionView.pagingEnabled = YES;
    self.learnShowCollectionView.scrollEnabled = NO;
    
    //创建右按键
    NSArray *imageArr = @[@"yuedu_.png",@"sousuo_.png"];
    items = [NSMutableArray arrayWithArray:imageArr];
    NSMutableArray *itemBtnArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<imageArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 35, 30);
        [button setImage:[[UIImage imageNamed:imageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        button.tag = 3101 + i;
        [button addTarget:self action:@selector(learnRightActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        [itemBtnArr addObject:item];
    }
    self.navigationItem.rightBarButtonItems = itemBtnArr;
    
    //
    [self getLearnTab];
    
//    [self setupScrollMenu];
}

- (void)setupScrollMenu {
    HMSegmentedControl *segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:items];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 60, Screen_width, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.backgroundColor = [UIColor clearColor];
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.verticalDividerEnabled = NO;
    [segmentedControl1 setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
        return attString;
    }];
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl1];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl*)segmentedControl {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getUserInformation];
    [UIView setAnimationsEnabled:YES];
}

#pragma mark - 查询基本资料
- (void)getUserInformation {
    if ([User_TOKEN length] > 0) {
        if (!(User_ID == nil || [User_ID isKindOfClass:[NSNull class]] || [User_ID isEqual:[NSNull null]])) {
            [[AppHttpManager shareInstance] getGetInfoByUseridWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                    if ([dict[@"Data"] count]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"jifen"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"jifen"] forKey:@"UserJiFen"];
                        [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"studyVal"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"studyVal"] forKey:@"UserStudyValues"];
                        [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"powerSource"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"powerSource"] forKey:@"UserPowerSource"];
                        [[NSUserDefaults standardUserDefaults] setObject:[dict[@"Data"][0][@"nickname"] isKindOfClass:[NSNull class]]?@"":dict[@"Data"][0][@"nickname"] forKey:@"UserNickName"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
        }
    }
}

#pragma mark - 右按键响应事件
- (void)learnRightActionWithBtn:(UIButton *)button {
    if (button.tag == 3101) {//课程
        [self performSegueWithIdentifier:@"LearnViewToCourseView" sender:nil];
    }else {//搜索
        [self performSegueWithIdentifier:@"LearnViewToSearchView" sender:nil];
    }
}

#pragma mark - 获取Tab
- (void)getLearnTab {
    [[AppHttpManager shareInstance] getGetStudyTabListWithPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                LearnTabModel *model = [[LearnTabModel alloc] initWithDictionary:subDict error:nil];
                [tabArr addObject:model];
            }
        }
        
        if (tabArr.count) {
            [self creatHeadButton];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

- (void)creatHeadButton {
    for (NSInteger i=0; i<tabArr.count; i++) {
        LearnTabModel *model = (LearnTabModel *)tabArr[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(Screen_width/4 * i, 5, Screen_width/4, 32);
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:model.T_NAME forState:UIControlStateNormal];
        [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        btn.tag = 2001 + i;
        [btn addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        }
        
        [self.headBackView addSubview:btn];
        [_btnArr addObject:btn];
    }
    
    headLineView = [[UIView alloc] initWithFrame:CGRectMake(kong, 37, space, 2)];
    headLineView.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    [self.headBackView addSubview:headLineView];
    
    UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, Screen_width, 1)];
    grayLineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.headBackView addSubview:headLineView];
    [self.headBackView insertSubview:grayLineView aboveSubview:headLineView];
    
    self.learnShowCollectionView.dataSource = self;
    self.learnShowCollectionView.delegate = self;
}

#pragma mark - 顶部按键响应事件
- (void)headButtonClick:(UIButton *)button {
    if (button.tag == 2004) {
        if ([User_TOKEN length] <= 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
            return;
        }
    }
    for (NSInteger i=0; i<_btnArr.count; i++) {
        UIButton *ibtn = (UIButton *)_btnArr[i];
        [ibtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [self headLineViewScrollWithIndex:button.tag-2001];
    [self.learnShowCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:button.tag-2001 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - 顶部线移动,
- (void)headLineViewScrollWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.15 animations:^{
        headLineView.frame = CGRectMake(kong+space*index+kong*(2*index), 37, space, 2);
    }];
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
    if (indexPath.row == 3) {
        static NSString *LearnShowTwoCollectionViewCellID = @"LearnShowTwoCollectionViewCellID";
        LearnShowTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LearnShowTwoCollectionViewCellID forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"LearnShowTwoCollectionViewCell" owner:self options:nil].lastObject;
        }
        cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        if (tabArr.count) {
            LearnTabModel *model = (LearnTabModel *)tabArr[indexPath.row];
            [cell creatTwoCollectionViewWithIndex:model.T_NAME];
        }
        
        //跳转到其他个人中心
        [cell setLearnShowOtherSelect:^(UserModel *model) {
            OtherUesrViewController *otherUserVC = MainStoryBoard(@"OtherUserInformationVCID");
            otherUserVC.otherUserId = model.use_id;
            otherUserVC.otherName = model.nickname;
            otherUserVC.otherPic = model.photourl;
            [self.navigationController pushViewController:otherUserVC animated:YES];
        }];
        
        return cell;
    }
    static NSString *LearnShowCollectionViewCellID = @"LearnShowCollectionViewCellID";
    LearnShowCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:LearnShowCollectionViewCellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LearnShowCollectionViewCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    if (tabArr.count) {
        LearnTabModel *model = (LearnTabModel *)tabArr[indexPath.row];
        [cell creatCollectionViewWithIndex:model.T_NAME];
    }
    
    //学习详情
    [cell setLearnShowSelectCell:^(LearnViewShowModel *model, NSString *type,NSInteger touchIndex) {
        if ([User_TOKEN length] <= 0) {
//            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
        }else {
            LearnDetailViewController *learnVC = MainStoryBoard(@"LearnDetailVCID");
            learnVC.learnAtriID = model.learnId;
            learnVC.courseType = model.studyType;
            learnVC.learnTitle = model.title;
            learnVC.learnContent = model.contents;
            learnVC.touchIndex = touchIndex;
            
            [self.navigationController pushViewController:learnVC animated:YES];
        }
    }];
    
    //学霸搒 //跳转到其他汇报记录
    [cell setLearnBaShowSelectCell:^(UserModel *model, NSString *type) {
//        OtherUserReportViewController *otherVC = MainStoryBoard(@"OtherUserReportVCID");
//        otherVC.otherUserId = model.use_id;
//        otherVC.otherName = model.nickname;
//        [self.navigationController pushViewController:otherVC animated:YES];
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
