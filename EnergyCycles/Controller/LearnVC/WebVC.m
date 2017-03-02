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
#import "AFHTTPSessionManager.h"


@interface WebVC ()<WKScriptMessageHandler,WKUIDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate,WKNavigationDelegate> {
    NSString * _url;
    WKWebView * webview;
    NSURLRequest *request;
    NSMutableData *resultData;
}

@end

@implementation WebVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];

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
    
    resultData = [NSMutableData new];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftbutton.frame = CGRectMake(0, 0, 30, 30);
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
    [config.userContentController addScriptMessageHandler:self name:@"SaveImg"];
    
    
    
    webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webview.backgroundColor = [UIColor redColor];
    webview.UIDelegate = self;
    webview.navigationDelegate = self;
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-5);
    }];
    
    NSLog(@"%@",self.url);
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//    [webview loadRequest:request];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    // Do any additional setup after loading the view.
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    else
    {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [resultData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *htmlString = [[NSString alloc] initWithBytes:[resultData bytes] length:[resultData length] encoding:NSUTF8StringEncoding];
    [webview loadHTMLString:htmlString baseURL:[NSURL URLWithString:self.url]];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
#if DEBUG
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
#endif
        if ([securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            if (credential) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            }
            
        } else {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
        
    }
    completionHandler(disposition, credential);

}

//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//    NSURLCredential * credential = [[NSURLCredential alloc] initWithTrust:[challenge protectionSpace].serverTrust];
//    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
//}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"UserID"]) {
        NSLog(@"%@",[message.body class]);
        NSString*user_id = [message.body objectForKey:@"body"];
        MineHomePageViewController *home = MainStoryBoard(@"MineHomePageViewController");
        home.userId = user_id;
        [self.navigationController pushViewController:home animated:YES];
    }else if ([message.name isEqualToString:@"SaveImg"]) {
        NSString*img_id = (NSString*)[message.body objectForKey:@"body"];
        NSLog(@"%@",img_id);
        [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:img_id] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }];
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


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        [SVProgressHUD showImage:nil status:@"保存成功"];
    }
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
