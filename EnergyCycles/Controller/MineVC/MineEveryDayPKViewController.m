//
//  MineEveryDayPKViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineEveryDayPKViewController.h"

#import "MineEveryDayPKViewCell.h"
#import "MineEveryDayOneViewCell.h"
#import "MineEveryTwoViewCell.h"
#import "BrokenLineViewController.h"

#import "OtherReportModel.h"
#import "MyPkEveryModel.h"

#import "XMShareView.h"


@interface MineEveryDayPKViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    UITableView *oneTableView;
    UICollectionView *twoCollectionView;
    
    NSMutableArray *_dataArr;
    NSMutableArray *_historyArr;
    NSInteger touchCollectionIndex;
    
    UIImagePickerController *picker;
    
    XMShareView *shareView;
    
    UIButton *rightButton;
    BOOL _isLeft;
}

@end

@implementation MineEveryDayPKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的每日PK";
    
    _dataArr = [[NSMutableArray alloc] init];
    _historyArr = [[NSMutableArray alloc] init];
    
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
//    [self setupRightNavBarWithimage:@"fenxiang_blue.png"];
    
    EnetgyCycle.energyTabBar.tabBar.translucent = NO;
    
    UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
    [showBackLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    showBackLayout.minimumInteritemSpacing = 0.f;
    showBackLayout.minimumLineSpacing = 0.f;
    self.showCollectionView.collectionViewLayout = showBackLayout;
    self.showCollectionView.backgroundColor = [UIColor whiteColor];
    [self.showCollectionView registerNib:[UINib nibWithNibName:@"MineEveryDayPKViewCell" bundle:nil] forCellWithReuseIdentifier:@"MineEveryDayPKViewCellID"];
    
    self.showCollectionView.showsHorizontalScrollIndicator = NO;
    self.showCollectionView.bounces = NO;
    self.showCollectionView.pagingEnabled = YES;
    self.showCollectionView.scrollEnabled = NO;
    
    self.headBackView.backgroundColor = [UIColor clearColor];
    self.headImageButton.backgroundColor = [UIColor clearColor];
    
    [self getEveryDayPKData];
    
    //增加消息中心,移除分享界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShareView:) name:@"NotificationRemoveShareView" object:nil];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[[UIImage imageNamed:@"fenxiang_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightButton setImage:[[UIImage imageNamed:@"fenxiang_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightButton.hidden = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_isLeft) {
        self.backLineView.frame = CGRectMake(0, 213, Screen_width/2-0.5, 2);
    }
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    EnetgyCycle.energyTabBar.tabBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 分享按键响应事件
- (void)rightAction {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"1" forKey:@"shareSuccessCallType"];
    
    //我今天阅读100页、跑步1KM(根据实际的汇报内容)，加入能量圈，和我一起PK吧！
    NSString *shareStr = @"";
    NSString *contentStr = @"";
    for (NSInteger i=0; i<_dataArr.count; i++) {
        OtherReportModel *model = (OtherReportModel *)_dataArr[i];
        
        if (i == _dataArr.count-1) {
            contentStr = [NSString stringWithFormat:@"%@%@%@%@",contentStr,model.RI_Name,model.RI_Num,model.RI_Unit];
        }else {
            contentStr = [NSString stringWithFormat:@"%@%@%@%@、",contentStr,model.RI_Name,model.RI_Num,model.RI_Unit];
        }
    }
    shareStr = [NSString stringWithFormat:@"我今天%@，加入能量圈，和我一起PK吧！",contentStr];
    
    shareView = [[XMShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
    shareView.alpha = 0.0;
    shareView.shareTitle = shareStr;
    shareView.shareText = @"";
    shareView.shareUrl = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",MYJYAppId];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    [UIView animateWithDuration:0.25 animations:^{
        shareView.alpha = 1.0;
    }];
}

//实现消息中心方法
- (void)removeShareView:(NSNotification *)notification {
    [shareView removeFromSuperview];
}

#pragma mark - 今日PK按键响应事件
- (IBAction)nowDayPKButtonClick:(UIButton *)sender {
    [self getEveryDayPKData];
    _isLeft = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.backLineView.frame = CGRectMake(0, 213, Screen_width/2-0.5, 2);
    }];
    [sender setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [self.historyButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    [self.showCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - 历史记录按键响应事件
- (IBAction)historyButtonClick:(UIButton *)sender {
    rightButton.hidden = YES;
    [self getHistoryData];
    _isLeft = YES;
    [UIView animateWithDuration:0.15 animations:^{
        self.backLineView.frame = CGRectMake(Screen_width/2+0.5, 213, Screen_width/2-0.5, 2);
    }];
    [sender setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [self.nowDayPKButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    [self.showCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - 获取每日PK数据
- (void)getEveryDayPKData {
    [[AppHttpManager shareInstance] getGetReportByUserWithUserid:[User_ID intValue] Token:User_TOKEN OUserId:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        [_dataArr removeAllObjects];
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if (![dict[@"Data"][@"pkImg"] isKindOfClass:[NSNull class]]) {
                [self.backImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"Data"][@"pkImg"]] placeholderImage:[UIImage imageNamed:@"placepic"]];
            }else {
                [self.headImageButton setBackgroundImage:[UIImage imageNamed:@"placepic"] forState:UIControlStateNormal];
            }
            
            for (NSDictionary *subDict in dict[@"Data"][@"reportItemInfo"]) {
                OtherReportModel *model = [[OtherReportModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            if (_dataArr.count) {
                rightButton.hidden = NO;
            }
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        
        [oneTableView reloadData];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 获取历史汇报项目
- (void)getHistoryData {
    [[AppHttpManager shareInstance] getGetMyPkHistoryProjectWithUserId:[User_ID intValue] Token:User_TOKEN PostOrGet:@"get" success:^(NSDictionary *dict) {
        [_historyArr removeAllObjects];
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                MyPkEveryModel *model = [[MyPkEveryModel alloc] initWithDictionary:subDict error:nil];
                [_historyArr addObject:model];
            }
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        [twoCollectionView reloadData];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 实现UIcollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 4201) {
        return _historyArr.count;
    }
    return 2;
}

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 4201) {
        return CGSizeMake(98, 120);
    }
    return CGSizeMake(Screen_width, Screen_Height-216-55);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 4201) {
        return UIEdgeInsetsMake(20, 10, 30, 10);
    }
    return UIEdgeInsetsZero;
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 4201) {
        static NSString *MineEveryTwoViewCellID = @"MineEveryTwoViewCellID";
        MineEveryTwoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MineEveryTwoViewCellID forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineEveryTwoViewCell" owner:self options:nil].lastObject;
        }
        cell.backgroundColor = [UIColor whiteColor];
        
        if (_historyArr.count) {
            MyPkEveryModel *model = (MyPkEveryModel *)_historyArr[indexPath.row];
            
            [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@""]];
            cell.titleLabel.text = model.name;
        }
        
        return cell;
    }
    
    static NSString *MineEveryDayPKViewCellID = @"MineEveryDayPKViewCellID";
    MineEveryDayPKViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MineEveryDayPKViewCellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineEveryDayPKViewCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 1) {
        UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
        [showBackLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        if ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) {
            showBackLayout.minimumInteritemSpacing = 0.f;
        }else {
            showBackLayout.minimumInteritemSpacing = 10.f;
        }
        showBackLayout.minimumLineSpacing = 0.f;
        
        twoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height-216-49) collectionViewLayout:showBackLayout];
        [twoCollectionView registerNib:[UINib nibWithNibName:@"MineEveryTwoViewCell" bundle:nil] forCellWithReuseIdentifier:@"MineEveryTwoViewCellID"];
        twoCollectionView.tag = 4201;
        twoCollectionView.backgroundColor = [UIColor whiteColor];
        twoCollectionView.dataSource = self;
        twoCollectionView.delegate = self;
        
        twoCollectionView.showsVerticalScrollIndicator = NO;
        twoCollectionView.bounces = YES;
        twoCollectionView.pagingEnabled = YES;
        
        [cell addSubview:twoCollectionView];
    }else {
        oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height-216-55) style:UITableViewStylePlain];
        oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        oneTableView.showsVerticalScrollIndicator = NO;
        oneTableView.showsHorizontalScrollIndicator = NO;
        oneTableView.dataSource = self;
        oneTableView.delegate = self;
        
        [cell addSubview:oneTableView];
    }
    
    return cell;
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//选择collectionView Cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 4201) {
        touchCollectionIndex = indexPath.row;
        [self performSegueWithIdentifier:@"MineEveryDayPKToBrokenLineView" sender:nil];
    }
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MineEveryDayOneViewCellID = @"MineEveryDayOneViewCellID";
    MineEveryDayOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineEveryDayOneViewCellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MineEveryDayOneViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count) {
        OtherReportModel *model = (OtherReportModel *)_dataArr[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.RI_Pic] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
        cell.titleLabel.text = model.RI_Name;
        cell.raceLabel.text = [NSString stringWithFormat:@"%@%@",model.RI_Num,model.RI_Unit];
        cell.paiLabel.text = model.orderNum;
    }
    
    return cell;
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MineEveryDayPKToBrokenLineView"]) {
        BrokenLineViewController *brokVC = segue.destinationViewController;
        if (_historyArr.count) {
            MyPkEveryModel *model = (MyPkEveryModel *)_historyArr[touchCollectionIndex];
            brokVC.projectID = model.pId;
            brokVC.showStr = model.name;
        }
    }
}

#pragma mark - 更换图片
- (IBAction)headImageButtonClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"拍照", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!picker) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
//        picker.allowsEditing=YES;
    }
    
    if (buttonIndex==0) {//从相册选择
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }else if (buttonIndex==1){//相机
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05);
    
    [_picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.backImageView.image = [UIImage imageWithData:imageData];
    [self.headImageButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self postBackImageViewWithData:imageData];
}

#pragma mark - 上传背景
- (void)postBackImageViewWithData:(NSData *)imageData {
    [[AppHttpManager shareInstance] postPostFileWithImageData:imageData PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"IsSuccess"] integerValue] == 1) {
            [[AppHttpManager shareInstance] getChangeMyPkImgWithUserId:[User_ID intValue] Token:User_TOKEN PkImg:dict[@"Data"] PostOrGet:@"post" success:^(NSDictionary *dict) {
                NSLog(@"%@",dict[@"Msg"]);
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
