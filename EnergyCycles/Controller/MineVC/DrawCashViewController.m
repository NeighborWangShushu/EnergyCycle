//
//  DrawCashViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DrawCashViewController.h"

#import "ShipAddressViewController.h"

#import "MallDetailViewCell.h"
#import "WDScrollView.h"

@interface DrawCashViewController () {
    UIView *zhongjiangView;
    
    UIActivityIndicatorView *_activityView;
}

@end

@implementation DrawCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.getMallModel.merchantType isEqualToString:@"抽奖"]) {
        self.title = @"抽奖";
        [self.downButton setTitle:@"立即抽奖" forState:UIControlStateNormal];
    }else {
        self.title = @"兑换";
        [self.downButton setTitle:@"立即兑换" forState:UIControlStateNormal];
    }
    
    //加载网页
    self.showWebView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.showWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?id=%@",INTERFACE_URL,MerchantDetailAspx,self.getMallModel.merchantid]]]];
    
    if ([self.getMallModel.counts integerValue] <= 0) {
        [self.downButton setBackgroundColor:[UIColor lightGrayColor]];
        self.downButton.userInteractionEnabled = NO;
        [self.downButton setTitle:@"抢光了" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 加载动画
- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        UIActivityIndicatorView *indicator =[[UIActivityIndicatorView alloc] init];
        indicator.tag = 10000;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityView =indicator;
        indicator.center =self.view.center;
        
        [self.view addSubview:indicator];
    }
    return _activityView;
}

#pragma mark - webView
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self activityView];
    [_activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityView stopAnimating];
}

#pragma mark - 底部button点击事件
- (IBAction)downButtonClick:(id)sender {
    if ([self.getMallModel.merchantType isEqualToString:@"抽奖"]) {//抽奖
        [[AppHttpManager shareInstance] getdoChouJiangWithUserid:[User_ID intValue] merchantId:[self.getMallModel.merchantid intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [self creatZhongJiangView];
                
                NSString *jifenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserJiFen"];
                int nowJiFen = [jifenStr intValue] - [self.getMallModel.jifen intValue];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",nowJiFen] forKey:@"UserJiFen"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else if ([dict[@"Code"] integerValue] == 202) {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                
                NSString *jifenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserJiFen"];
                int nowJiFen = [jifenStr intValue] - [self.getMallModel.jifen intValue];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",nowJiFen] forKey:@"UserJiFen"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }else {//兑换
        [self performSegueWithIdentifier:@"DuiHuanViewToAddressView" sender:nil];
    }
}

#pragma mark - 中奖View
- (void)creatZhongJiangView {
    zhongjiangView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
    zhongjiangView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:zhongjiangView];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(20, (Screen_Height-Screen_width-40)/2, Screen_width-40, Screen_width-40)];
    subView.backgroundColor = [UIColor whiteColor];
    subView.layer.masksToBounds = YES;
    subView.layer.cornerRadius = 5.f;
    [zhongjiangView addSubview:subView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, Screen_width-40, 24)];
    titleLabel.text = @"恭喜您中奖啦！";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [subView addSubview:titleLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, Screen_width-40, 28)];
    nameLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    nameLabel.font = [UIFont systemFontOfSize:20];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = self.getMallModel.name;
    [subView addSubview:nameLabel];
    
    UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_width/2-20-(160*(Screen_width/375))/2, 70+(17*(Screen_width/375)), 160*(Screen_width/375), 160*(Screen_width/375))];
    NSArray *imageArr = [self.getMallModel.img componentsSeparatedByString:@","];
    [showImageView sd_setImageWithURL:[NSURL URLWithString:imageArr.firstObject]];
    showImageView.layer.borderWidth = 1.f;
    showImageView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    showImageView.layer.masksToBounds = YES;
    showImageView.layer.cornerRadius = 1.f;
    [subView addSubview:showImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(18, Screen_width-40-10*(Screen_width/375)-50, Screen_width-40-36, 50);
    button.backgroundColor = [UIColor colorWithRed:247/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2.f;
    [button setTitle:@"领奖" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addTarget:self action:@selector(lingjiangButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:button];
}

#pragma mark - 领奖按键响应事件
- (void)lingjiangButtonClick:(UIButton *)button {
    [zhongjiangView removeFromSuperview];
    zhongjiangView = nil;
    
    [self performSegueWithIdentifier:@"DuiHuanViewToAddressView" sender:nil];
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DuiHuanViewToAddressView"]) {
        ShipAddressViewController *shipVC = segue.destinationViewController;
        shipVC.shangPinID = self.getMallModel.merchantid;
        
        if ([self.getMallModel.merchantType isEqualToString:@"抽奖"]) {
            shipVC.drawType = @"1";
        }else {
            shipVC.drawType = @"0";
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
