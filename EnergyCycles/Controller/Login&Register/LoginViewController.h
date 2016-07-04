//
//  LoginViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

//账户
@property (weak, nonatomic) IBOutlet UITextField *loginPhoneTextField;
//密码
@property (weak, nonatomic) IBOutlet UITextField *loginPassWordTextField;

//返回按键
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonClick:(id)sender;

//忘记密码
@property (weak, nonatomic) IBOutlet UIButton *forgetPassWordButton;
- (IBAction)forgetPassWordButtonClick:(id)sender;

//登录按键
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonClick:(id)sender;

//注册按键
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)registerButtonClick:(id)sender;

//密文
@property (weak, nonatomic) IBOutlet UIButton *isMiWenButton;
- (IBAction)isMiWenButtonClick:(id)sender;

//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageViewAutoLayoutTop;


@end
