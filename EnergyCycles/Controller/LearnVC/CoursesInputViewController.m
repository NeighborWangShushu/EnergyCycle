//
//  CoursesInputViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CoursesInputViewController.h"

@interface CoursesInputViewController () {
    UIButton *rightButton;
}

@end

@implementation CoursesInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程";
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    self.nameLabel.text = self.inputLeftStr;
    
    //
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    //
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    //
//    [self.inputTextField becomeFirstResponder];
    if (([self.inputLeftStr isEqualToString:@"电话"] || [self.inputLeftStr isEqualToString:@"父亲电话"] || [self.inputLeftStr isEqualToString:@"母亲电话"]) && ![AppHM isPhoneNum:self.inputTextField.text]) {
        self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)rightAction {
    if (self.inputTextField.text.length <= 0) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[NSString stringWithFormat:@"请输入%@",self.inputLeftStr]];
    }else {
        if (([self.inputLeftStr isEqualToString:@"电话"] || [self.inputLeftStr isEqualToString:@"父亲电话"] || [self.inputLeftStr isEqualToString:@"母亲电话"]) && ![AppHM isPhoneNum:self.inputTextField.text]) {
            [SVProgressHUD showImage:nil status:@"请输入合法手机号"];
        }else if ([self.inputLeftStr isEqualToString:@"邮箱"] && ![AppHM isEmail:self.inputTextField.text]) {
            [SVProgressHUD showImage:nil status:@"请输入合法邮箱"];
        }else {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:self.touchuIndex forKey:@"index"];
            [dict setObject:self.touchuSection forKey:@"section"];
            [dict setObject:self.inputTextField.text forKey:@"text"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isBaoMingChangeProfileDict" object:dict];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)delButtonClick:(id)sender {
    self.inputTextField.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
