//
//  SignInViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SignInViewController.h"

#import "SignInModel.h"
#import "SignInOneCollectionViewCell.h"

#import "SignRankingTableVC.h"


@interface SignInViewController () <UIScrollViewDelegate> {
    NSMutableArray *_dataArr;
    
    UIScrollView *backScrollView;
    NSInteger days;
    NSString *nowDay;
    NSString *yearAndMonth;
    
    BOOL _isSign;
}

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签到";
    
    _dataArr = [[NSMutableArray alloc] init];
    days = 30;
    
    self.dayLabel.text = @"";
    
    [self getYearMonthDay];
    //
    [self creatImageView];
    
    self.dayLabel.text = @"点我签到";
    self.dayLabel.font = [UIFont systemFontOfSize:27];
    self.jifenLabel.hidden = YES;
    self.oneLabel.hidden = YES;
    self.tianLabel.hidden = YES;
}

#pragma mark - 创建动态图片
- (void)creatImageView {
    self.showImageView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"QDDT00000.png"],
                                     [UIImage imageNamed:@"QDDT00001.png"],
                                     [UIImage imageNamed:@"QDDT00002.png"],
                                     [UIImage imageNamed:@"QDDT00003.png"],
                                     [UIImage imageNamed:@"QDDT00004.png"],
                                     [UIImage imageNamed:@"QDDT00005.png"],
                                     [UIImage imageNamed:@"QDDT00006.png"],
                                     [UIImage imageNamed:@"QDDT00007.png"],
                                     [UIImage imageNamed:@"QDDT00008.png"],
                                     [UIImage imageNamed:@"QDDT00009.png"],
                                     [UIImage imageNamed:@"QDDT00010.png"],
                                     [UIImage imageNamed:@"QDDT00011.png"],
                                     [UIImage imageNamed:@"QDDT00012.png"],
                                     [UIImage imageNamed:@"QDDT00013.png"],
                                     [UIImage imageNamed:@"QDDT00014.png"],
                                     [UIImage imageNamed:@"QDDT00015.png"],
                                     [UIImage imageNamed:@"QDDT00016.png"],
                                     [UIImage imageNamed:@"QDDT00017.png"],
                                     [UIImage imageNamed:@"QDDT00018.png"],
                                     [UIImage imageNamed:@"QDDT00019.png"],
                                     [UIImage imageNamed:@"QDDT00020.png"],
                                     [UIImage imageNamed:@"QDDT00021.png"],
                                     [UIImage imageNamed:@"QDDT00022.png"],
                                     [UIImage imageNamed:@"QDDT00023.png"],
                                     [UIImage imageNamed:@"QDDT00024.png"],
                                     [UIImage imageNamed:@"QDDT00025.png"],
                                     [UIImage imageNamed:@"QDDT00026.png"],
                                     [UIImage imageNamed:@"QDDT00027.png"],
                                     [UIImage imageNamed:@"QDDT00028.png"],
                                     [UIImage imageNamed:@"QDDT00029.png"],
                                     [UIImage imageNamed:@"QDDT00030.png"],
                                     [UIImage imageNamed:@"QDDT00031.png"],
                                     [UIImage imageNamed:@"QDDT00032.png"],
                                     [UIImage imageNamed:@"QDDT00033.png"],
                                     [UIImage imageNamed:@"QDDT00034.png"],
                                     [UIImage imageNamed:@"QDDT00035.png"],
                                     [UIImage imageNamed:@"QDDT00036.png"],
                                     [UIImage imageNamed:@"QDDT00037.png"],
                                     [UIImage imageNamed:@"QDDT00038.png"],
                                     [UIImage imageNamed:@"QDDT00039.png"],
                                     [UIImage imageNamed:@"QDDT00040.png"],
                                     [UIImage imageNamed:@"QDDT00041.png"],
                                     [UIImage imageNamed:@"QDDT00042.png"],
                                     [UIImage imageNamed:@"QDDT00043.png"],
                                     [UIImage imageNamed:@"QDDT00044.png"],
                                     [UIImage imageNamed:@"QDDT00045.png"],
                                     [UIImage imageNamed:@"QDDT00046.png"],
                                     [UIImage imageNamed:@"QDDT00047.png"],
                                     [UIImage imageNamed:@"QDDT00048.png"],
                                     [UIImage imageNamed:@"QDDT00049.png"],
                                     [UIImage imageNamed:@"QDDT00050.png"], nil];
    [self.showImageView setAnimationDuration:1.f];
    [self.showImageView setAnimationRepeatCount:0];
    [self.showImageView startAnimating];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 跳转到签到规则界面
- (void)rightAction {
    [backScrollView removeFromSuperview];
    backScrollView = nil;
    
    [self performSegueWithIdentifier:@"SignInViewToSignInRulesView" sender:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    [self setupRightNavBarWithTitle:@"规则"];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"加载中.."];
    
    [[AppHttpManager shareInstance] getIsHasSignWithUserId:[User_ID intValue] Token:User_TOKEN PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if ([dict[@"Data"] integerValue] != 0) {
                _isSign = YES;
            }
            [self getSignInNetData];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",str);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [backScrollView removeFromSuperview];
    backScrollView = nil;
}

#pragma mark - 获取当前年、月、日
- (void)getYearMonthDay {
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    
    NSArray *timeArr = [locationString componentsSeparatedByString:@"-"];
    NSInteger year = [timeArr.firstObject integerValue];
    NSString *month = timeArr[1];
    nowDay = timeArr.lastObject;
    if ([month isEqualToString:@"02"]) {
        if((year%400 == 0) || ((year%4 == 0)&&(year%100 != 0))) {//闰年
            days = 29;
        }else {
            days = 28;
        }
    }else if ([month isEqualToString:@"01"] || [month isEqualToString:@"03"] || [month isEqualToString:@"05"] || [month isEqualToString:@"07"] || [month isEqualToString:@"08"] || [month isEqualToString:@"10"] || [month isEqualToString:@"12"]) {
        days = 31;
    }else {
        days = 30;
    }
    
    yearAndMonth = [NSString stringWithFormat:@"%@.%@",timeArr.firstObject,timeArr[1]];
}

#pragma mark - 获取签到网络数据
- (void)getSignInNetData {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"加载中.."];
    
    [[AppHttpManager shareInstance] getGetSignInfoWithUserid:User_ID token:User_TOKEN PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"][@"list"]) {
                SignInModel *model = [[SignInModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            
            //获取总积分
            self.jifenLabel.text = [NSString stringWithFormat:@"总积分 %@",dict[@"Data"][@"jifen"]];
            //连续签到天数
            SignInModel *subModel = (SignInModel *)_dataArr[_dataArr.count-1];
            if (_isSign) {
                self.dayLabel.font = [UIFont systemFontOfSize:54];
                self.dayLabel.text = [NSString stringWithFormat:@"%@",subModel.Continuons];
                
                self.jifenLabel.hidden = NO;
                self.oneLabel.hidden = NO;
                self.tianLabel.hidden = NO;
            }else {
                self.dayLabel.text = @"点我签到";
            }
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popViewControllerAnimated:NO];
        }else {
//            self.dayLabel.text = @"0";
//            self.jifenLabel.text = [NSString stringWithFormat:@"总积分 %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserJiFen"]];
        }
        
        [SVProgressHUD dismiss];
        [self creatScrollView];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 创建签到界面
- (void)creatScrollView {
    [backScrollView removeFromSuperview];
    backScrollView = nil;
    
    if (!backScrollView) {
        backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Screen_Height-300, Screen_width, 320)];
        backScrollView.backgroundColor = [UIColor clearColor];
        backScrollView.contentSize = CGSizeMake(510+480+420, 0);
        backScrollView.showsVerticalScrollIndicator = NO;
        backScrollView.showsHorizontalScrollIndicator = NO;
        
        backScrollView.contentOffset = CGPointMake(30*[nowDay integerValue], 0);
        
        for (NSInteger i=0; i<3; i++) {
            SignInOneCollectionViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"SignInOneCollectionViewCell" owner:self options:nil] lastObject];
            cell.backgroundColor = [UIColor clearColor];
            
            //新增需求修改
//            [cell setSignInButtonClcik:^(void) {
//                [self signInWithModel];
//            }];
            cell.userInteractionEnabled = NO;
            
            if (i == 0) {
                cell.frame = CGRectMake(0, 0, 510, 200);
            }else if (i == 1) {
                cell.frame = CGRectMake(510, 0, 480, 200);
            }else if (i == 2) {
                cell.frame = CGRectMake(510+480, 0, 415, 200);
            }
            
            [cell signInCollectionViewWithDataWithIndex:i withMonthDay:days withArr:_dataArr withToday:yearAndMonth withNow:nowDay];
            
            [backScrollView addSubview:cell];
            [backScrollView bringSubviewToFront:cell];
        }
        [self.view addSubview:backScrollView];
        
        NSMutableArray *timeDayArr = [[NSMutableArray alloc] init];
        for (SignInModel *model in _dataArr) {
            NSArray *timeArr = [model.DateTime componentsSeparatedByString:@" "];
            NSArray *subArr = [timeArr.firstObject componentsSeparatedByString:@"-"];
            
            [timeDayArr addObject:subArr.lastObject];
        }
        
        for (NSInteger i=0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            
            [btn setTitle:yearAndMonth forState:UIControlStateNormal];
            [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.3] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
            btn.titleLabel.font = [UIFont systemFontOfSize:7];
            
            btn.frame = CGRectMake(490, 108, 40, 40);
            btn.userInteractionEnabled = NO;
            if ([nowDay integerValue] == 12) {
                btn.userInteractionEnabled = YES;
            }
            [btn setBackgroundImage:[UIImage imageNamed:@"12_1.png"] forState:UIControlStateNormal];
            if (i == 1) {
                if ([nowDay integerValue] == 23) {
                    btn.userInteractionEnabled = YES;
                }
                btn.frame = CGRectMake(490+480, 108, 40, 40);
                [btn setBackgroundImage:[UIImage imageNamed:@"23_1.png"] forState:UIControlStateNormal];
            }
            
            //新增需求修改
//            [btn addTarget:self action:@selector(signInWithModel) forControlEvents:UIControlEventTouchUpInside];
            btn.userInteractionEnabled = NO;
            for (NSInteger j=0; j<timeDayArr.count; j++) {
                if ([timeDayArr[j] integerValue] == 12) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"12_2.png"] forState:UIControlStateNormal];
                }else if ([timeDayArr[j] integerValue] == 23) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"23_2.png"] forState:UIControlStateNormal];
                }
            }
            
            [backScrollView addSubview:btn];
        }
    }
}

#pragma mark - 签到
- (IBAction)signButtonClick:(UIButton *)sender {
    [self signInWithModel];
}

#pragma mark - 签到,提交数据
- (void)signInWithModel {
    static BOOL isQian = NO;
    if (!isQian) {
        isQian = YES;
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"加载中.."];
        [[AppHttpManager shareInstance] postArticleSignWithUserId:[User_ID intValue] Token:User_TOKEN PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"签到成功"];
                _isSign = YES;
                [self getSignInNetData];
            }else {
                isQian = NO;
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
            isQian = NO;
        }];
    }else {
        isQian = NO;
        [SVProgressHUD showImage:nil status:@"已经签过了"];
    }
}

#pragma mark - 签到排行榜
- (IBAction)signListClick:(UIButton *)sender {
    SignRankingTableVC *signRankingVC = [[SignRankingTableVC alloc] init];
    [self.navigationController pushViewController:signRankingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
