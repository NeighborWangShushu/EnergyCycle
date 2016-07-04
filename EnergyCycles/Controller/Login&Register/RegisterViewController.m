//
//  RegisterViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () {
    BOOL getTwoCode;
    NSTimer *countDownTimer;
    NSInteger secondsCountDown;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    self.registerTopAutoLayout.constant = 38*Screen_Height/667;
    self.registerTextFieldTopAutolayout.constant = 44*Screen_Height/667;
    secondsCountDown = 60;
    
    self.getVerificationCodeButton.layer.masksToBounds = YES;
    self.getVerificationCodeButton.layer.cornerRadius = 2.f;
    self.regIsMiWenButton.layer.masksToBounds = YES;
    self.regIsMiWenButton.layer.cornerRadius = 5.f;
    
    [self chageTextFieldWithTextField:self.nicknameTextField];
    [self chageTextFieldWithTextField:self.phoneTextField];
    [self chageTextFieldWithTextField:self.verificationCodeTextField];
    [self chageTextFieldWithTextField:self.onePassWordTextField];
    [self chageTextFieldWithTextField:self.againPassWordTextField];
    [self chageTextFieldWithTextField:self.energySourceTextField];
    
    [self.energySourceTextField addTarget:self action:@selector(eneryChanedTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)chageTextFieldWithTextField:(UITextField *)myTextField {
    [myTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [myTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    UIImage *image = [UIImage imageNamed:@"bg_tou.png"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark -
- (void)eneryChanedTextField:(UITextField *)textField {
    if (textField.text.length <=0) {
        self.showLabel.text = @"(向推荐人索取,输入后立获100积分)";
    }else {
        self.showLabel.text = nil;
    }
}

#pragma mark - 注册按键响应事件
- (IBAction)rigisterButtonClick:(id)sender {
    if ([self.nicknameTextField.text length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入昵称"];
    }else if ([self.phoneTextField.text length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
    }else if ([self.verificationCodeTextField.text length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入验证码"];
    }else if ([self.onePassWordTextField.text length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
    }else if ([self.againPassWordTextField.text length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入确认密码"];
    }else if (![[AppHelpManager sharedInstance] isValidPassword:self.onePassWordTextField.text]) {
        [SVProgressHUD showImage:nil status:@"密码由6到16位数字或字母组成"];
    }else if (![self.onePassWordTextField.text isEqualToString:self.againPassWordTextField.text]) {
        [SVProgressHUD showImage:nil status:@"两次输入密码不一致"];
    }else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"注册中.."];
        
        [[AppHttpManager shareInstance] getRegisterWithNickname:self.nicknameTextField.text PhoneNo:self.phoneTextField.text VerifyCode:self.verificationCodeTextField.text Pwd:[self md5StringForString:self.onePassWordTextField.text] PoweredSource:self.energySourceTextField.text PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - 获取短信验证码按键响应事件
- (IBAction)getVerificationCodeButtonClick:(id)sender {
    if (getTwoCode) {
        return;
    }
    if (![[AppHelpManager sharedInstance] isPhoneNum:self.phoneTextField.text]) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"请输入合法的手机号"];
        return;
    }
    
    getTwoCode=YES;
    [self.getVerificationCodeButton setTitle:[NSString stringWithFormat:@"%lds",(long)secondsCountDown] forState:UIControlStateNormal];
    
    [self.getVerificationCodeButton setTitleColor:[UIColor colorWithRed:80/255.0 green:170/255.0 blue:240/255.0 alpha:0.5] forState:UIControlStateNormal];
    
    [self.getVerificationCodeButton setBackgroundImage:[UIImage imageNamed:@"getYanZhenbg.png"] forState:UIControlStateNormal];
    self.getVerificationCodeButton.userInteractionEnabled = NO;
    countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [self getVerificationCodeMethod];
}

/**************停止验证码倒计时操作***************/
-(void)stopCountDown{
    getTwoCode=NO;
    [self.getVerificationCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.getVerificationCodeButton setTitleColor:[UIColor colorWithRed:80/255.0 green:170/255.0 blue:240/255.0 alpha:1] forState:UIControlStateNormal];
    secondsCountDown=60;
    [countDownTimer invalidate];
    self.getVerificationCodeButton.userInteractionEnabled=YES;
}
/**************验证码倒计时操作***************/
-(void)timeFireMethod{
    secondsCountDown--;
    if (secondsCountDown==0) {
        [self stopCountDown];
    }else{
        [self.getVerificationCodeButton setTitle:[NSString stringWithFormat:@"%lds",(long)secondsCountDown] forState:UIControlStateNormal];
    }
}
/**************获取验证码操作***************/
- (void)getVerificationCodeMethod {
    if (self.phoneTextField.text.length==0) {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
    }else if (![[AppHelpManager sharedInstance] isPhoneNum:self.phoneTextField.text]){
        [SVProgressHUD showImage:nil status:@"请输入合法的手机号"];
        return;
    }else {
        [[AppHttpManager shareInstance] postGetCodeWithPhoneNo:self.phoneTextField.text PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                NSLog(@"验证码：%@",dict);
            }else {
                getTwoCode=NO;
                [self.getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getVerificationCodeButton setTitleColor:[UIColor colorWithRed:80/255.0 green:170/255.0 blue:240/255.0 alpha:1] forState:UIControlStateNormal];
                secondsCountDown=60;
                [countDownTimer invalidate];
                self.getVerificationCodeButton.userInteractionEnabled=YES;
                
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }
}

#pragma mark - 密码 密文
- (IBAction)regIsMiWenButtonClick:(id)sender {
    static BOOL isShowMiWen = NO;
    
    if (!isShowMiWen) {
        [sender setImage:[UIImage imageNamed:@"loginxianshi.png"] forState:UIControlStateNormal];
        self.onePassWordTextField.secureTextEntry = NO;
        isShowMiWen = YES;
    }else {
        [sender setImage:[UIImage imageNamed:@"loginyincang.png"] forState:UIControlStateNormal];
        self.onePassWordTextField.secureTextEntry = YES;
        isShowMiWen = NO;
    }
}

#pragma mark - 确认密码 密文
- (IBAction)twoRegIsMiWenButtonClick:(id)sender {
    static BOOL isShowMiWen = YES;
    
    if (!isShowMiWen) {
        [sender setImage:[UIImage imageNamed:@"loginxianshi.png"] forState:UIControlStateNormal];
        self.againPassWordTextField.secureTextEntry = NO;
        isShowMiWen = YES;
    }else {
        [sender setImage:[UIImage imageNamed:@"loginyincang.png"] forState:UIControlStateNormal];
        self.againPassWordTextField.secureTextEntry = YES;
        isShowMiWen = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
