//
//  WebVC.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface WebVC : BaseViewController


- (instancetype)initWithURL:(NSString*)url;

@property (nonatomic,strong)NSString * url;

@end
