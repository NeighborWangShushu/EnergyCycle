//
//  DrawCashViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

#import "MallModel.h"

@interface DrawCashViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *showWebView;

//底部button
@property (weak, nonatomic) IBOutlet UIButton *downButton;
- (IBAction)downButtonClick:(id)sender;

//传值
@property (nonatomic, strong) MallModel *getMallModel;

//标题
@property (nonatomic, strong) NSString *selfTitle;


@end
