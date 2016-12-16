//
//  HttpsWebViewProtocol.h
//  EnergyCycles
//
//  Created by vj on 2016/12/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpsWebViewProtocol : NSObject

+ (BOOL)canInitWithRequest:(NSURLRequest *)request;

@property (nonatomic,strong)NSURLRequest * request;

@end
