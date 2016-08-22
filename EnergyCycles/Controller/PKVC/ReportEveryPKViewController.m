//
//  ReportEveryPKViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ReportEveryPKViewController.h"

#import "ReportOneTableViewCell.h"
#import "ReportTwoTableViewCell.h"
#import "ReportThrTableViewCell.h"
#import "ReportPostingTableViewCell.h"
#import "ReportShareTableViewCell.h"

#import "ReportOneCollectionViewCell.h"
#import "EnergyPostCollectionViewCell.h"
#import "SelectTheProjectViewController.h"
#import "PKSelectedModel.h"

#import "ZYQAssetPickerController.h"
#import "XMTwoShareView.h"

#import "XHImageViewer.h"
#import "UIImageView+XHURLDownload.h"

#import "ShareModel.h"
#import "ShareSDKManager.h"

@interface ReportEveryPKViewController () <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,XHImageViewerDelegate> {
    UIButton *rightButton;
    UICollectionView *oneCellCollectionView;
    
    NSMutableDictionary *postDict;
    NSMutableArray *_xianmuArr;
    NSMutableArray *_selectImgArray;
    NSMutableArray *_selectImgArrayLocal;
    NSInteger _tempIndex;
    NSMutableDictionary *subPostDict;
    
    NSMutableArray *_imageUrlArr;
    
    XMTwoShareView *shareView;
    
    UIAlertView *delAlertView;
    
    NSMutableArray *sharesArray;
    
    BOOL onPost;
    BOOL onQQ;
    BOOL onWecha;
    BOOL onMoments;
    BOOL onWeibo;
}

@end

@implementation ReportEveryPKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"汇报";
    
    sharesArray = [[NSMutableArray alloc] init];
    
    _imageUrlArr = [[NSMutableArray alloc] init];
    postDict = [[NSMutableDictionary alloc] init];
    subPostDict = [[NSMutableDictionary alloc] init];
    _xianmuArr = [[NSMutableArray alloc] init];
    _selectImgArray = [[NSMutableArray alloc] init];
    _selectImgArrayLocal = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:240/255.0 alpha:1];
    
    reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    reportTableView.showsHorizontalScrollIndicator = NO;
    reportTableView.showsVerticalScrollIndicator = NO;
    
    //尾视图
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 80)];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 27, 22, 22)];
    leftImageView.image = [UIImage imageNamed:@"help.png"];
    [tableHeadView addSubview:leftImageView];
    
    UILabel *biaozhuLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+22+5, 11, Screen_width-12-22-5-12, 55)];
    biaozhuLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    biaozhuLabel.numberOfLines = 3;
    biaozhuLabel.font = [UIFont systemFontOfSize:14];
    [tableHeadView addSubview:biaozhuLabel];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"请确认汇报当日数据（非累计数据），否则积分清零\n如有阅读汇报，请上传书籍封面"];
    NSRange range1 = [[hintString string]rangeOfString:@"请确认汇报当日真实数据(非累计数据),否则积分清零"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[[UIColor blackColor] colorWithAlphaComponent:0.4] range:range1];
    
    NSRange range2 = [[hintString string]rangeOfString:@"如有阅读汇报，请上传书籍封面"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] range:range2];
    biaozhuLabel.attributedText = hintString;
    
    
    reportTableView.tableFooterView = tableHeadView;
    
    //左按键
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    //右按键
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    //    [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReportEveryPKView:) name:@"isReportEveryPKView" object:nil];
    
    
    NSData *chooseData = [[NSUserDefaults standardUserDefaults] objectForKey:@"chooseDict"];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:chooseData];
    for (NSDictionary *subDict in dict.allValues) {
        PKSelectedModel *model = [[PKSelectedModel alloc] init];
        model.unit = subDict[@"unit"];
        model.myId = subDict[@"myId"];
        model.picUrl = subDict[@"picUrl"];
        model.name = subDict[@"name"];
        
        [_xianmuArr addObject:model];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePost:) name:@"ReportPostSwitch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQQ:) name:@"ReportQQSwitch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWecha:) name:@"ReportWechaSwitch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMoments:) name:@"ReportMomentsSwitch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeibo:) name:@"ReportWeiboSwitch" object:nil];

    
    //增加消息中心,移除分享界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShareView:) name:@"NotificationRemoveShareView" object:nil];
}

- (void)updatePost:(NSNotification *)notification {
    NSString *string = notification.object;
    if ([string isEqualToString:@"YES"]) {
        onPost = YES;
    } else if ([string isEqualToString:@"NO"]) {
        onPost = NO;
    }
}

- (void)updateQQ:(NSNotification *)notification {
    NSString *string = notification.object;
    if ([string isEqualToString:@"YES"]) {
        onQQ = YES;
        [sharesArray addObject:@"0"];
    } else if ([string isEqualToString:@"NO"]) {
        onQQ = NO;
        [sharesArray removeObject:@"0"];
    }
}

- (void)updateWecha:(NSNotification *)notification {
    NSString *string = notification.object;
    if ([string isEqualToString:@"YES"]) {
        onWecha = YES;
        [sharesArray addObject:@"1"];
    } else if ([string isEqualToString:@"NO"]) {
        onWecha = NO;
        [sharesArray removeObject:@"1"];
    }
}

- (void)updateMoments:(NSNotification *)notification {
    NSString *string = notification.object;
    if ([string isEqualToString:@"YES"]) {
        onMoments = YES;
        [sharesArray addObject:@"2"];
    } else if ([string isEqualToString:@"NO"]) {
        onMoments = NO;
        [sharesArray removeObject:@"2"];
    }
}

- (void)updateWeibo:(NSNotification *)notification {
    NSString *string = notification.object;
    if ([string isEqualToString:@"YES"]) {
        onWeibo = YES;
        [sharesArray addObject:@"3"];
    } else if ([string isEqualToString:@"NO"]) {
        onWeibo = NO;
        [sharesArray removeObject:@"3"];
    }
}

#pragma mark - 增加监听,选中提交的种类
- (void)ReportEveryPKView:(NSNotification *)notification {
    if (_xianmuArr.count) {
        [_xianmuArr removeAllObjects];
    }
    NSArray *chooseArr = [[notification object] objectForKey:@"dict"];
    for (PKSelectedModel *model in chooseArr) {
        [_xianmuArr addObject:model];
    }
    [reportTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    if ([subPostDict count] > 0 || _selectImgArrayLocal.count >0 || _xianmuArr.count > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认返回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else {
        [self back];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:delAlertView]) {
        if (buttonIndex == 1) {
            [_selectImgArray removeObjectAtIndex:delAlertView.tag];
            [_selectImgArrayLocal removeObjectAtIndex:delAlertView.tag];
            
            ReportThrTableViewCell *cell = [reportTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            [cell.showImageCollectionView reloadData];
        }
    }else {
        if (buttonIndex == 1) {
            [self back];
        }
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 提交按键响应事件
- (void)rightAction {
    //    if (subPostDict.count != _xianmuArr.count) {
    //        [SVProgressHUD showImage:nil status:@"要填写完整哟~"];
    //    }
    //    else {
    //        for (NSString *value in subPostDict.allValues) {
    //            if ([value floatValue] == 0.00) {
    //                [SVProgressHUD showImage:nil status:@"汇报的项目要填写且不能是0哦~"];
    //                return;
    //            }
    //        }
    //
    //        if(_selectImgArrayLocal.count){
    //            NSData * data = UIImageJPEGRepresentation(_selectImgArrayLocal[0], 0.05);
    //            [self submitImage:data];
    //        }else {
    //            [self getURLContext];
    //        }
    //    }
    //    if (subPostDict.count != _xianmuArr.count) {
    //        [SVProgressHUD showImage:nil status:@"要填写完整哟~"];
    //    }
    if (subPostDict.count <= 0) {
        [SVProgressHUD showImage:nil status:@"请填写汇报内容"];
    }
    for (NSString *value in subPostDict.allValues) {
        if ([value floatValue] == 0.00) {
            [SVProgressHUD showImage:nil status:@"汇报的项目要填写且不能是0哦~"];
            return;
        }
    }
    
    if(_selectImgArrayLocal.count){
        NSData * data = UIImageJPEGRepresentation(_selectImgArrayLocal[0], 0.05);
        [self submitImage:data];
    }else {
        [self getURLContext];
    }
    
}

- (void)getURLContext {
    if (subPostDict.count <= 0) {
        [SVProgressHUD showImage:nil status:@"请填写汇报内容"];
    }else {
        NSMutableArray *_inputArr = [[NSMutableArray alloc] init];
        NSArray *keyArr = subPostDict. allKeys;
        
        for (NSString *key in keyArr) {
            NSMutableDictionary *keyDict = [[NSMutableDictionary alloc] init];
            [keyDict setObject:key forKey:@"projectId"];
            [keyDict setValue:[subPostDict objectForKey:key] forKey:@"reportNum"];
            
            [_inputArr addObject:keyDict];
        }
        
        NSMutableArray *reportSubArr = [[NSMutableArray alloc] init];
        for (NSDictionary *subDict in _inputArr) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subDict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [reportSubArr addObject:jsonStr];
        }
        
        if (onPost) {
            NSString *shareStr = @"";
            NSString *contentStr = @"";
            for (NSInteger i=0; i<_xianmuArr.count; i++) {
                PKSelectedModel *model = (PKSelectedModel *)_xianmuArr[i];
                NSString *numStr = [subPostDict objectForKey:model.myId];
                
                if (i == _xianmuArr.count-1) {
                    contentStr = [NSString stringWithFormat:@"%@%@%@%@",contentStr,model.name,numStr,model.unit];
                }else {
                    contentStr = [NSString stringWithFormat:@"%@%@%@%@、",contentStr,model.name,numStr,model.unit];
                }
            }
            shareStr = [NSString stringWithFormat:@"我刚才完成了%@，欢迎到每日PK来挑战我！【来自每日PK】",contentStr];
            NSLog(@"%@", shareStr);
            [[AppHttpManager shareInstance] postAddArticleWithTitle:@"" Content:shareStr VideoUrl:@"" UserId:[User_ID intValue] token:User_TOKEN List:_imageUrlArr PostOrGet:@"post" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                    NSLog(@"能量帖发布成功!");
                }
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
        }
        
        [[AppHttpManager shareInstance] getAddReportWithUserid:User_ID Token:User_TOKEN ReportList:reportSubArr ImageList:_imageUrlArr PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
//                [self creatSuccessShareView];
                [self share:sharesArray];
                //
                NSMutableDictionary *choDict = [[NSMutableDictionary alloc] init];
                for (NSInteger i=0; i<_xianmuArr.count; i++) {
                    NSMutableDictionary *subDict = [[NSMutableDictionary alloc] init];
                    PKSelectedModel *model = (PKSelectedModel *)_xianmuArr[i];
                    [subDict setObject:model.unit forKey:@"unit"];
                    [subDict setObject:model.myId forKey:@"myId"];
                    [subDict setObject:model.picUrl forKey:@"picUrl"];
                    [subDict setObject:model.name forKey:@"name"];
                    
                    [choDict setObject:subDict forKey:@(i)];
                }
                
                NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:choDict];
                [[NSUserDefaults standardUserDefaults] setObject:jsonData forKey:@"chooseDict"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }else if ([dict[@"Code"] integerValue] == 10000) {
                [SVProgressHUD showImage:nil status:@"登录失效"];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"汇报失败 %@",str);
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)share:(NSMutableArray*)items {
    
    [SVProgressHUD showWithStatus:@""];
    if ([items count]) {
        NSNumber*num = items[0];
        [self shareByIndex:[num integerValue]];
    }else {
        [self shareCancel];
    }
}

- (void)shareByIndex:(NSInteger)index {
    
//    NSString * title = energyPostViewCell.informationTextView.text;
//    NSString* share_url = [NSString stringWithFormat:@"%@%@?aid=%@&is_Share=1",INTERFACE_URL,ArticleDetailAspx,[NSString stringWithFormat:@"%ld",(long)postIndex]];
    NSString *title = @"快来下载能量圈吧";
    NSString *share_url = @"https://itunes.apple.com/cn/app/neng-liang-quan/id1079791492?mt=8";
    switch (index) {
        case 0:
            [self shareToQQ:share_url title:title];
            break;
        case 1:
            [self shareToWechatTimeline:share_url title:title];
            break;
        case 2:
            [self shareToWechatSession:share_url title:title];
            break;
        case 3:
            [self shareToWeibo:share_url title:title];
            break;
            
        default:
            break;
    }
}

- (void)shareCancel {
    
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)shareToWechatTimeline:(NSString*)url title:(NSString*)title {
    
    
    __weak __typeof(self)weakSelf = self;
    
    ShareModel*model = [[ShareModel alloc] init];
    model.title = title;
    model.content = @"";
    model.shareUrl = url;
    [[ShareSDKManager shareInstance] shareClientToWeixinTimeLine:model block:^(SSDKResponseState state) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [weakSelf wechatTimeLineShareSuccess];
            }
                break;
            case SSDKResponseStateCancel:
                [weakSelf shareCancel];
                break;
                
            default:
                break;
        }
    }];
}

- (void)wechatTimeLineShareSuccess {
    
    [sharesArray removeObjectAtIndex:0];
    if ([sharesArray count]) {
        NSNumber*num = sharesArray[0];
        [self shareByIndex:[num integerValue]];
    }else {
        [self shareCancel];
    }
    
}

- (void)shareToWechatSession:(NSString*)url title:(NSString*)title {
    
    __weak __typeof(self)weakSelf = self;
    
    ShareModel*model = [[ShareModel alloc] init];
    model.title = title;
    model.content = @"";
    model.shareUrl = url;
    [[ShareSDKManager shareInstance] shareClientToWeixinSession:model block:^(SSDKResponseState state) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [weakSelf wechatSessionShareSuccess];
            }
                break;
            case SSDKResponseStateCancel:
                [weakSelf shareCancel];
                
                break;
                
            default:
                break;
        }
    }];
}

- (void)wechatSessionShareSuccess {
    
    [sharesArray removeObjectAtIndex:0];
    if ([sharesArray count]) {
        NSNumber*num = sharesArray[0];
        [self shareByIndex:[num integerValue]];
    }else {
        [self shareCancel];
    }
    
}

- (void)shareToWeibo:(NSString*)url title:(NSString*)title {
    
    __weak __typeof(self)weakSelf = self;
    
    ShareModel*model = [[ShareModel alloc] init];
    model.title = title;
    model.content = @"";
    model.shareUrl = url;
    [[ShareSDKManager shareInstance] shareClientToWeibo:model block:^(SSDKResponseState state) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [weakSelf weiboShareSuccess];
            }
                break;
            case SSDKResponseStateCancel:
                [weakSelf shareCancel];
                break;
                
            default:
                break;
        }
    }];
    
}

- (void)weiboShareSuccess {
    [sharesArray removeObjectAtIndex:0];
    if ([sharesArray count]) {
        NSNumber*num = sharesArray[0];
        [self shareByIndex:[num integerValue]];
    }else {
        [self shareCancel];
    }
}

- (void)shareToQQ:(NSString*)url title:(NSString*)title {
    
    __weak __typeof(self)weakSelf = self;
    
    ShareModel*model = [[ShareModel alloc] init];
    model.title = title;
    model.content = @"";
    model.shareUrl = url;
    [[ShareSDKManager shareInstance] shareClientToQQSession:model block:^(SSDKResponseState state) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [weakSelf QQShareSuccess];
            }
                break;
            case SSDKResponseStateCancel:
                [weakSelf shareCancel];
                
                break;
                
            default:
                break;
        }
    }];
    
}

- (void)QQShareSuccess {
    [sharesArray removeObjectAtIndex:0];
    if ([sharesArray count]) {
        NSNumber*num = sharesArray[0];
        [self shareByIndex:[num integerValue]];
    }else {
        [self shareCancel];
    }
}

#pragma mark - 创建View
- (void)creatSuccessShareView {
    [SVProgressHUD dismiss];
    
    //我今天阅读100页、跑步1KM(根据实际的汇报内容)，加入能量圈，和我一起PK吧！
    NSString *shareStr = @"";
    NSString *contentStr = @"";
    for (NSInteger i=0; i<_xianmuArr.count; i++) {
        PKSelectedModel *model = (PKSelectedModel *)_xianmuArr[i];
        NSString *numStr = [subPostDict objectForKey:model.myId];
        
        if (i == _xianmuArr.count-1) {
            contentStr = [NSString stringWithFormat:@"%@%@%@%@",contentStr,model.name,numStr,model.unit];
        }else {
            contentStr = [NSString stringWithFormat:@"%@%@%@%@、",contentStr,model.name,numStr,model.unit];
        }
    }
    shareStr = [NSString stringWithFormat:@"我今天%@，加入能量圈，和我一起PK吧！",contentStr];
    
    //分享
    shareView = [[XMTwoShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height) withTitle:@"今日汇报提交成功"];
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
    //    NSInteger index = [[[notification object] objectForKey:@"index"] integerValue];
    //    if (index == 1) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    [self.navigationController popViewControllerAnimated:YES];
    [shareView removeFromSuperview];
}

-(void)submitImage:(NSData*)imageData{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"提交中.."];
    
    [[AppHttpManager shareInstance] postPostFileWithImageData:imageData PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            _tempIndex++;
            NSString * imgURL=[dict[@"Data"] firstObject];
            [_imageUrlArr addObject:imgURL];
            if (_selectImgArrayLocal.count) {// 九张
                if(_tempIndex<_selectImgArrayLocal.count){
                    NSData * data=UIImageJPEGRepresentation(_selectImgArrayLocal[_tempIndex], 0.05);
                    [self submitImage:data];
                }else{
                    // 提交数据
                    [self getURLContext];
                }
            }
        }else {
            // 网络出错
            [SVProgressHUD showImage:nil status:@"请检查网络"];
        }
    } failure:^(NSString *str) {
        NSLog(@"错误：%@",str);
        [SVProgressHUD dismiss];
    }];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _xianmuArr.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120.f;
    }else if (indexPath.section == 1) {
        return 50.f;
    }else if (indexPath.section == 3 || indexPath.section == 4) {
        return 45.f;
    }
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *ReportOneTableViewCellId = @"ReportOneTableViewCellId";
        ReportOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReportOneTableViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ReportOneTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumInteritemSpacing = 0.f;
        layout.minimumLineSpacing = 0.f;
        
        oneCellCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 120) collectionViewLayout:layout];
        oneCellCollectionView.tag = 2301;
        oneCellCollectionView.backgroundColor = [UIColor whiteColor];
        [oneCellCollectionView registerNib:[UINib nibWithNibName:@"ReportOneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ReportOneCollectionViewCellId"];
        
        oneCellCollectionView.dataSource = self;
        oneCellCollectionView.delegate = self;
        oneCellCollectionView.showsHorizontalScrollIndicator = NO;
        oneCellCollectionView.showsVerticalScrollIndicator = NO;
        
        [cell addSubview:oneCellCollectionView];
        
        return cell;
    }else if (indexPath.section == 1) {
        static NSString *ReportTwoTableViewCellId = @"ReportTwoTableViewCellId";
        ReportTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReportTwoTableViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ReportTwoTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_xianmuArr.count) {
            PKSelectedModel *model = (PKSelectedModel *)_xianmuArr[indexPath.row];
            cell.titleLabel.text = model.name;
            cell.danweiLabel.text = model.unit;
            //            cell.inputTextField.text = @"0";
        }
        cell.inputTextField.tag = 2311+indexPath.row;
        [cell.inputTextField addTarget:self action:@selector(cellInputTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
        
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *ReportThrTableViewCellId = @"ReportThrTableViewCellId";
        ReportThrTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReportThrTableViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ReportThrTableViewCell" owner:self options:nil].lastObject;
        }
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumInteritemSpacing = 10.f;
        layout.minimumLineSpacing = 10.f;
        cell.showImageCollectionView.collectionViewLayout = layout;
        cell.showImageCollectionView.backgroundColor = [UIColor clearColor];
        [cell.showImageCollectionView registerNib:[UINib nibWithNibName:@"EnergyPostCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EnergyPostCollectionViewCellId"];
        cell.showImageCollectionView.tag = 2302;
        cell.showImageCollectionView.dataSource = self;
        cell.showImageCollectionView.delegate = self;
        
        cell.showImageCollectionView.showsHorizontalScrollIndicator = NO;
        cell.showImageCollectionView.showsVerticalScrollIndicator = NO;
        
        return cell;
    } else if (indexPath.section == 3) {
        static NSString *reportPostingTableViewCell = @"reportPostingTableViewCell";
        ReportPostingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reportPostingTableViewCell];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ReportPostingTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateData];
        return cell;
    } else if (indexPath.section == 4) {
        static NSString *reportShareTableViewCell = @"reportShareTableViewCell";
        ReportShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reportShareTableViewCell];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ReportShareTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateData];
        return cell;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3 || section == 4) {
        return 20.f;
    }
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 17, 100, 17)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    if (section == 0) {
        label.text = @"项目";
    }else if (section == 1) {
        label.text = @"今日共完成";
    }else {
        label.text = @"添加照片";
    }
    [headView addSubview:label];
    
    if (section == 3 || section == 4) {
        return nil;
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark -
- (void)cellInputTextFieldChange:(UITextField *)textField {
    PKSelectedModel *model = (PKSelectedModel *)_xianmuArr[textField.tag-2311];
    
    CGFloat textFloatValue = [textField.text floatValue];
    if ([model.name isEqualToString:@"跑步"] || [model.name isEqualToString:@"骑行"]) {
        [subPostDict setObject:[NSString stringWithFormat:@"%.1f",textFloatValue] forKey:model.myId];
    }else {
        [subPostDict setObject:[NSString stringWithFormat:@"%.0f",textFloatValue] forKey:model.myId];
    }
}

#pragma mark - 实现UIcollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 2302) {
        return _selectImgArrayLocal.count>0?(_selectImgArrayLocal.count<9?_selectImgArrayLocal.count+1:_selectImgArrayLocal.count):1;
    }
    return _xianmuArr.count>0?_xianmuArr.count+1:1;
}

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 2302) {
        return CGSizeMake(80, 80);
    }
    return CGSizeMake(90, 120);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 2302) {
        return UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return UIEdgeInsetsMake(0, 11, 0, 0);
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 2302) {
        static NSString *EnergyPostCollectionViewCellId = @"EnergyPostCollectionViewCellId";
        EnergyPostCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EnergyPostCollectionViewCellId forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EnergyPostCollectionViewCell" owner:self options:nil] lastObject];
        }
        cell.backgroundColor = [UIColor whiteColor];
        
        if (_selectImgArrayLocal.count == 0) {
            [cell.showJiaImageView setImage:[UIImage imageNamed:@"jia_normal.png"]];
            [cell.showImageView setImage:[UIImage imageNamed:@"Rectangle .png"]];
        }else{
            [cell.showJiaImageView setImage:[UIImage imageNamed:@""]];
        }
        
        if (_selectImgArrayLocal.count) {
            if (_selectImgArrayLocal.count < 9) {
                if (indexPath.item == _selectImgArrayLocal.count) {
                    [cell.showJiaImageView setImage:[UIImage imageNamed:@"jia_normal.png"]];
                    [cell.showImageView setImage:[UIImage imageNamed:@"Rectangle .png"]];
                }else{
                    [cell.showImageView setImage:_selectImgArrayLocal[indexPath.item]];
                }
            }else {
                //最后一张是图片
                [cell.showImageView setImage:_selectImgArrayLocal[indexPath.item]];
            }
        }
        
        //添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:longPress];
        
        return cell;;
    }
    
    static NSString *ReportOneCollectionViewCellId = @"ReportOneCollectionViewCellId";
    ReportOneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReportOneCollectionViewCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReportOneCollectionViewCell" owner:self options:nil] lastObject];
    }
    
    cell.titleLabel.text = nil;
    if (_xianmuArr.count) {
        if (indexPath.row == _xianmuArr.count) {
            cell.iconImageView.image = [UIImage imageNamed:@"41tianjia_.png"];
        }else {
            PKSelectedModel *model = (PKSelectedModel *)_xianmuArr[indexPath.row];
            [cell updateCollectionViewDataWithModel:model];
        }
    }else {
        cell.iconImageView.image = [UIImage imageNamed:@"41tianjia_.png"];
    }
    
    return cell;
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//UICollectionView点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //选择项目
    if (collectionView.tag == 2301) {
        if (indexPath.row == _xianmuArr.count) {
            [self performSegueWithIdentifier:@"ReportViewToSelectTheProjectView" sender:nil];
        }
    }else {
        if (indexPath.row == _selectImgArrayLocal.count) {
            [self clickToShow];
        }else {//图片浏览
            NSMutableArray *sumImageArr = [[NSMutableArray alloc] init];
            for (UIImage *getImage in _selectImgArrayLocal) {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = getImage;
                [sumImageArr addObject:imageView];
            }
            XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
            imageViewer.delegate = self;
            [imageViewer showWithImageViews:sumImageArr selectedView:sumImageArr[indexPath.row]];
        }
    }
}

#pragma mark - 长按手势响应事件
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress {
    if (longPress.view.tag != _selectImgArray.count) {
        if (longPress.state == UIGestureRecognizerStateEnded) {
            delAlertView = [[UIAlertView alloc] initWithTitle:@"确认移除照片吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            delAlertView.tag = longPress.view.tag;
            [delAlertView show];
        }
    }
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ReportViewToSelectTheProjectView"]) {
        SelectTheProjectViewController *selectVC = segue.destinationViewController;
        selectVC.getChooseArr = _xianmuArr;
    }
}

//点击选择图片 入口
-(void)clickToShow{
    [self.view endEditing:YES];
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: NSLocalizedString(@"从相册选择", nil), NSLocalizedString(@"拍照", nil),nil];
    [myActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        // 选择拍照
        [self takePhoto:UIImagePickerControllerSourceTypeCamera];
    }else if(buttonIndex==0){
        // 获取本地图片
        [self LocalPhoto];
    }
}

- (void)takePhoto:(NSInteger)type {
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = type;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: type]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        if (type == UIImagePickerControllerSourceTypeCamera) {
            picker.allowsEditing = YES;
        }
        //资源类型为照相机
        picker.sourceType = sourceType;
        //        [self presentViewController:picker animated:YES completion:nil];
        [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

- (void)LocalPhoto {
    NSInteger count = 0;
    if (_selectImgArray != nil && _selectImgArray.count > 0) {
        count =_selectImgArray.count;
    }
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.navigationBar.tintColor=[UIColor whiteColor];
    picker.navigationBar.translucent = NO;
    [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    picker.maximumNumberOfSelection = 9-count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    //    [self presentViewController:picker animated:YES completion:nil];
    [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_selectImgArrayLocal addObject:image];
    
    ReportThrTableViewCell *cell = [reportTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [cell.showImageCollectionView reloadData];
}

//相册
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if(assets!=nil&&assets.count>0){
        //创建临时存储目录
        for(int i=0;i<assets.count;i++){
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [_selectImgArrayLocal addObject:tempImg];
            [_selectImgArray addObject:tempImg];
        }
    }
    
    ReportThrTableViewCell *cell = [reportTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [cell.showImageCollectionView reloadData];
}

#pragma mark - XHImageViewerDelegate
- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
