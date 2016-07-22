//
//  IWillAdviseViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "IWillAdviseViewController.h"

@interface IWillAdviseViewController () <UITextViewDelegate> {
    NSMutableDictionary *postDict;
    UIButton *rightButton;
}

@end

@implementation IWillAdviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我要提建议";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    postDict = [[NSMutableDictionary alloc] init];
    
//    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    self.inputTextView.placehoder = @"可输入200字";
    self.inputTextView.backgroundColor = [UIColor whiteColor];
    self.inputTextView.layer.borderWidth = 1.f;
    self.inputTextView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.layer.cornerRadius = 2.f;
    self.inputTextView.delegate = self;
    
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTintColor:[UIColor whiteColor]];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.userInteractionEnabled = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
//}

//#pragma mark - 返回按键
//- (void)leftAction {
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
//}

#pragma mark - 提交按键响应事件
- (void)rightAction {
    if ([postDict[@"contents"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入建议内容."];
    } else if ([postDict[@"contents"] length] > 200) {
        [SVProgressHUD showImage:nil status:@"请将字数限制在200字以内"];
    } else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"提交中.."];
        
        [[AppHttpManager shareInstance] getMySuggestionWithUserid:[User_ID intValue] Contents:postDict[@"contents"] PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"谢谢您的宝贵意见"];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            [SVProgressHUD showImage:nil status:@"请检查您的网络"];
        }];
    }
}

#pragma mark - TextView值改变
- (void)textViewDidChange:(UITextView *)textView {
//    if (textView.text.length <= 0) {
//        [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:0.5] forState:UIControlStateNormal];
//        rightButton.userInteractionEnabled = NO;
//    }else {
//        [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
//        rightButton.userInteractionEnabled = YES;
//    }
    [postDict setObject:textView.text forKey:@"contents"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
