//
//  WebVC.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "WebVC.h"
#import "Masonry.h"
#import <WebKit/WebKit.h>
#import "MineHomePageViewController.h"


@interface WebVC ()<WKScriptMessageHandler,WKUIDelegate> {
    NSString * _url;
}

@end

@implementation WebVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftbutton.frame = CGRectMake(0, 0, 30, 35);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"whiteback_normal"] forState:UIControlStateNormal];
    leftbutton.tag = 1002;
    [leftbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftitem];
    
    
    self.title = self.titleName;
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"UserID"];
    
    WKWebView * webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webview.backgroundColor = [UIColor redColor];
    webview.UIDelegate = self;
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [webview loadRequest:request];
    
    // Do any additional setup after loading the view.
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"UserID"]) {
        NSLog(@"%@",[message.body class]);
        NSString*user_id = [message.body objectForKey:@"body"];
        MineHomePageViewController *home = MainStoryBoard(@"MineHomePageViewController");
        home.userId = user_id;
        [self.navigationController pushViewController:home animated:YES];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    NSLog(@"%@", message);
    
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    
}


- (void)back:(UIButton*)button {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
