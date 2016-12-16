//
//  HttpsWebViewProtocol.m
//  EnergyCycles
//
//  Created by vj on 2016/12/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HttpsWebViewProtocol.h"
#import "AFSecurityPolicy.h"

@interface HttpsWebViewProtocol ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;


@end

@implementation HttpsWebViewProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *urlStr = request.URL.absoluteString;
    NSLog(@"----origin request url = %@", urlStr);
    NSRange range = [urlStr rangeOfString:@""];
    //这里是我们的拦截逻辑，需要自己实现的请求就return YES
    return range.length > 0;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *myRequest = [request mutableCopy];
    return myRequest;
}

- (void)startLoading {
    if (!self.session) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
    }
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:[HttpsWebViewProtocol canonicalRequestForRequest:self.request]];
    [task resume];
    
}

- (void)stopLoading {
    [self.session invalidateAndCancel];
    [self.session finishTasksAndInvalidate];
}

#pragma mark NSURLSession Delegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler{
    
//    [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    
}





@end
