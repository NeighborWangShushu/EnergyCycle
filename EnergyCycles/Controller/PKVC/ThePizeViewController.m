//
//  ThePizeViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ThePizeViewController.h"

@interface ThePizeViewController () <UIWebViewDelegate> {
    UIActivityIndicatorView *_activityView;
}

@end

@implementation ThePizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"本月奖品";
    
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    //加载网页
    self.showImageView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    self.showImageView.delegate = self;
    [self.showImageView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?awardId=%@",INTERFACE_URL,AwardDetailAspx,self.waradID]]]];
    self.showImageView.allowsInlineMediaPlayback = YES;
    self.showImageView.mediaPlaybackRequiresUserAction = NO;
    self.showImageView.scrollView.scrollEnabled=YES;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
