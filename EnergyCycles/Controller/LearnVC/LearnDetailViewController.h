//
//  LearnDetailViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>


@interface LearnDetailViewController : BaseViewController {
    IBOutlet UITableView *learnDetailTableView;
    
    UIView *learnWabBackView;
    WKWebView *learnWebView;
}

//
@property (nonatomic, strong) NSString *learnAtriID;
@property (nonatomic, strong) NSString *courseType;

@property (nonatomic, strong) NSString *learnTitle;
@property (nonatomic, strong) NSString *learnContent;

@property (nonatomic, assign) NSInteger touchIndex;


@end
