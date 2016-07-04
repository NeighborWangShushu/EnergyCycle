//
//  ChangeProfileViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChangeProfileViewController.h"

@interface ChangeProfileViewController ()

@end

@implementation ChangeProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.showStr;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    //
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    //
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    self.titleLabel.text = self.showStr;
    
    if ([self.touchSection integerValue] == 2) {
        self.inputTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    }else if ([self.touchSection integerValue] == 1) {
        if ([self.touchIndex integerValue] == 1 || [self.touchIndex integerValue] == 3) {
            self.inputTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        }
    }else if ([self.showStr isEqualToString:@"电话"]) {
        self.inputTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
}

#pragma mark - 返回按键响应事件
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 完成按键响应事件
- (void)rightAction {
    if (self.inputTextFiled.text.length <= 0) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[NSString stringWithFormat:@"请输入%@",self.showStr]];
    }else {
        if (([self.showStr isEqualToString:@"电话"] || [self.showStr isEqualToString:@"父亲电话"] || [self.showStr isEqualToString:@"母亲电话"]) && ![AppHM isPhoneNum:self.inputTextFiled.text]) {
            [SVProgressHUD showImage:nil status:@"请输入合法手机号"];
        }else if ([self.showStr isEqualToString:@"邮箱"] && ![AppHM isEmail:self.inputTextFiled.text]) {
            [SVProgressHUD showImage:nil status:@"请输入合法邮箱"];
        }else if([self.showStr isEqualToString:@"姓名"] || [self.showStr isEqualToString:@"昵称"]){
            [self check];
        }
        else{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:self.touchIndex forKey:@"index"];
            [dict setObject:self.touchSection forKey:@"section"];
            [dict setObject:self.inputTextFiled.text forKey:@"text"];
            
            if ([self.changeProType isEqualToString:@"MyPro"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isChangeProfileDict" object:dict];
            }else if ([self.changeProType isEqualToString:@"OldStu"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isOldChangeProfileDict" object:dict];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//检查字符长度 长度不能大于10
- (void)check {
    if(self.inputTextFiled.text.length > 10){
        [SVProgressHUD showImage:nil status:@"名字过长，请重新输入"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
