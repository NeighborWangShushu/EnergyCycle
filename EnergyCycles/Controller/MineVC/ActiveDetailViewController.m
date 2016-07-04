//
//  ActiveDetailViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 16/1/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ActiveDetailViewController.h"

@interface ActiveDetailViewController () <UIWebViewDelegate> {
    UIActivityIndicatorView *_activityView;
}

@end

@implementation ActiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载网页
    self.showWebView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    
    NSString *loadStr = @"";
    if ([self.type isEqualToString:@"1"]) {
        self.title = @"通知详情";
        loadStr = [NSString stringWithFormat:@"%@/%@?id=%@",INTERFACE_URL,ActiveDetailAspx,self.model.NotifyId];
    }else {
        self.title = @"活动详情";
        loadStr = [NSString stringWithFormat:@"%@/%@?id=%@",INTERFACE_URL,ActiveDetailAspx,self.model.NotifyId];
    }
    [self.showWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadStr]]];

    
    self.showWebView.allowsInlineMediaPlayback = YES;
    self.showWebView.mediaPlaybackRequiresUserAction = NO;
    
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    EnetgyCycle.isAtInformationView = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isNewsDetailChange" object:@{@"type":@"0",@"index":self.touchIndex}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    EnetgyCycle.isAtInformationView = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
