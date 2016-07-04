//
//  RegisterViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController

//昵称
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
//密码
@property (weak, nonatomic) IBOutlet UITextField *onePassWordTextField;
//密码
@property (weak, nonatomic) IBOutlet UITextField *againPassWordTextField;
//能量源
@property (weak, nonatomic) IBOutlet UITextField *energySourceTextField;
//
@property (weak, nonatomic) IBOutlet UILabel *showLabel;


//注册
@property (weak, nonatomic) IBOutlet UIButton *rigisterButton;
- (IBAction)rigisterButtonClick:(id)sender;

//获取短信验证码
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeButton;
- (IBAction)getVerificationCodeButtonClick:(id)sender;

//密码密文
@property (weak, nonatomic) IBOutlet UIButton *regIsMiWenButton;
- (IBAction)regIsMiWenButtonClick:(id)sender;

//确认密码密文
@property (weak, nonatomic) IBOutlet UIButton *twoRegIsMiWenButton;
- (IBAction)twoRegIsMiWenButtonClick:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerTopAutoLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerTextFieldTopAutolayout;



@end
