//
//  OtherUserReportViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "OtherUserReportViewController.h"

#import "OtherUserTableViewCell.h"
#import "OtherReportModel.h"
#import "WDScrollView.h"

#import "XHImageViewer.h"
#import "UIImageView+XHURLDownload.h"

@interface OtherUserReportViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,XHImageViewerDelegate> {
    UIButton *rightButton;
    
    NSMutableArray *_dataArr;
    BOOL isHeart;
    UIView *headView;
}

@end

@implementation OtherUserReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.otherName;
    
    _dataArr = [[NSMutableArray alloc] init];
    
    otherUserReportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    otherUserReportTableView.showsVerticalScrollIndicator = NO;
    otherUserReportTableView.showsHorizontalScrollIndicator = NO;
    
    //左按键
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    //右按键
    if ([self.otherUserId integerValue] != [User_ID integerValue]) {
        rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame = CGRectMake(0, 0, 70, 30);
        
        rightButton.layer.masksToBounds = YES;
        rightButton.layer.cornerRadius = 2.f;
        rightButton.layer.borderWidth = 1.f;
        rightButton.layer.borderColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1].CGColor;
        [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    [self getOtherUserInformation];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 170)];
    otherUserReportTableView.tableHeaderView = headView;
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

#pragma mark - 获取其他用户汇报数据
- (void)getOtherUserInformation {
    [[AppHttpManager shareInstance] getGetReportByUserWithUserid:[User_ID intValue] Token:User_TOKEN OUserId:[self.otherUserId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"][@"reportItemInfo"]) {
                OtherReportModel *model = [[OtherReportModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            
            if ([dict[@"Data"][@"isHeart"] integerValue] == 1) {//已关注
                [self changeButtonWithType:1];
            }else {
                [self changeButtonWithType:2];
            }
            [otherUserReportTableView reloadData];
            
            if ([dict[@"Data"][@"reportItemInfo"] count] <= 0) {
                [SVProgressHUD showImage:nil status:@"他还没有汇报哦"];
            }else {
                NSMutableArray *imageArr = [[NSMutableArray alloc] init];
                for (NSString *str in dict[@"Data"][@"reportPicList"]) {
                    [imageArr addObject:[NSURL URLWithString:str]];
                }
                
                if (imageArr.count) {
                    WDScrollView *scrollC = [[WDScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 170) andLayout:WDScrollViewLayoutTiltleTopLeftPageControlBottomCenter];
                    scrollC.imageArr = imageArr;
                    
                    //
                    NSMutableArray *sumImageArr = [[NSMutableArray alloc] init];
                    for (NSURL *imageUrl in imageArr) {
                        UIImageView *imageView = [[UIImageView alloc] init];
                        [imageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image) {
                                [sumImageArr addObject:imageView];
                            }
                        }];
                    }
                    [scrollC didClickedIndexBlock:^(NSInteger index) {
                        XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
                        imageViewer.delegate = self;
                        [imageViewer showWithImageViews:sumImageArr selectedView:sumImageArr[index]];
                    }];
                    
                    [headView addSubview:scrollC];
                }else {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 170)];
                    imageView.image = [UIImage imageNamed:@"placepic.png"];
                    [headView addSubview:imageView];
                }
            }
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - XHImageViewerDelegate
- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
    
}

#pragma mark - 提交按键响应事件
- (void)rightAction {
    if (!isHeart) {
        [self postIsGuanZhuWithType:1];
    }else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"确定取消关注%@?",self.otherName] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注" otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
}

- (void)changeButtonWithType:(int)type {
    if (type == 1) {
        isHeart = YES;
        [rightButton setBackgroundColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1]];
        [rightButton setImage:[[UIImage imageNamed:@"46gou_.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [rightButton setTitle:@"已关注" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        isHeart = NO;
        [rightButton setBackgroundColor:[UIColor whiteColor]];
        [rightButton setImage:[[UIImage imageNamed:@"45tianjia01.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [rightButton setTitle:@"关注" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self postIsGuanZhuWithType:2];
    }
}

#pragma mark - 提交网络数据
- (void)postIsGuanZhuWithType:(int)type {
    [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:type UserId:[User_ID intValue] Token:User_TOKEN OUserId:[self.otherUserId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if (type == 1) {
                [self changeButtonWithType:1];
                [SVProgressHUD showImage:nil status:@"关注成功"];
            }else {
                [self changeButtonWithType:2];
                [SVProgressHUD showImage:nil status:@"取消关注成功"];
            }
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *OtherUserTableViewCellId = @"OtherUserTableViewCellId";
    OtherUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OtherUserTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OtherUserTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count) {
        OtherReportModel *model = (OtherReportModel *)_dataArr[indexPath.row];
        
        [cell.userIconImageVoew sd_setImageWithURL:[NSURL URLWithString:model.RI_Pic]];
        cell.classLabel.text = model.RI_Name;
        cell.sourceLabel.text = [NSString stringWithFormat:@"%@ %@",model.RI_Num,model.RI_Unit];
        
        if ([model.hasLike integerValue] == 0) {
            [cell.zanButton setImage:[UIImage imageNamed:@"hxin.png"] forState:UIControlStateNormal];
        }else {
            [cell.zanButton setImage:[UIImage imageNamed:@"32xin02_.png"] forState:UIControlStateNormal];
        }
        cell.zanButton.tag = 30001+indexPath.row;
        [cell setZanButtonClick:^(NSInteger index) {
            OtherReportModel *model = (OtherReportModel *)_dataArr[index];
            [self touchZanWithModel:model withIndex:index];
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 170)];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 170)];
//    imageView.image = [UIImage imageNamed:@"2_1.jpg"];
//    [headBackView addSubview:imageView];
//    
//    return headBackView;
    return nil;
}

#pragma mark - 点赞,取消点赞
- (void)touchZanWithModel:(OtherReportModel *)model withIndex:(NSInteger)index {
    int type = 2;
    if ([model.hasLike integerValue] == 0) {
        type = 1;
    }else {
        type = 2;
    }
    
    [[AppHttpManager shareInstance] getZanReportItemWithType:type UserId:[User_ID intValue] Token:User_TOKEN RepItemId:[model.repItemId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            OtherReportModel *subModel = (OtherReportModel *)_dataArr[index];
            if (type == 2) {
                subModel.hasLike = @"0";
                [SVProgressHUD showImage:nil status:@"取消赞"];
            }else {
                subModel.hasLike = @"1";
                [SVProgressHUD showImage:nil status:@"点赞成功"];
            }
            
            [_dataArr replaceObjectAtIndex:index withObject:subModel];
            [otherUserReportTableView reloadData];
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
