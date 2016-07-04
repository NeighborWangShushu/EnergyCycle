//
//  ForgetPassWordViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ForgetPassWordViewController.h"

@interface ForgetPassWordViewController () {
    BOOL getTwoCode;
    NSTimer *countDownTimer;
    NSInteger secondsCountDown;
}

@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    secondsCountDown = 60;
    self.forgetTopImageAutoLayout.constant = 38*Screen_Height/667;
    self.forgetTopTextFieldAutoLayout.constant = 44*Screen_Height/667;
    
    self.getVeifiButton.layer.masksToBounds = YES;
    self.getVeifiButton.layer.cornerRadius = 2.f;
    self.comButton.layer.masksToBounds = YES;
    self.comButton.layer.cornerRadius = 2.f;
    
    
    [self chageTextFieldWithTextField:self.forPhoneTextField];
    [self chageTextFieldWithTextField:self.forVerifiTextField];
    [self chageTextFieldWithTextField:self.forNewPassTextField];
    [self chageTextFieldWithTextField:self.againPassTextField];
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

#pragma mark - 完成按键响应事件
- (IBAction)comButtonClick:(id)sender {
    if (self.forPhoneTextField.text.length <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
    }else if (![[AppHelpManager sharedInstance] isPhoneNum:self.forPhoneTextField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入合法手机号"];
    }else if (self.forVerifiTextField.text.length <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入验证码"];
    }else if (self.forNewPassTextField.text.length <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
    }else if (self.againPassTextField.text.length <= 0) {
        [SVProgressHUD showImage:nil status:@"请输入确认密码"];
    }else if (![self.forNewPassTextField.text isEqualToString:self.againPassTextField.text]) {
        [SVProgressHUD showImage:nil status:@"两次密码不一致"];
    }else if (![[AppHelpManager sharedInstance] isValidPassword:self.forNewPassTextField.text]) {
        [SVProgressHUD showImage:nil status:@"密码由6到16位数字或字母组成"];
    }else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"提交中.."];
        
        [[AppHttpManager shareInstance] getFindPwdWithPhoneNo:self.forPhoneTextField.text verifyCode:self.forVerifiTextField.text pwd:[self md5StringForString:self.forNewPassTextField.text] PostOrGet:@"get" success:^(NSDictionary *dict) {
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

#pragma mark - 获取验证码
- (IBAction)getVeifiButtonClick:(id)sender {
    if (getTwoCode) {
        return;
    }
    if (![[AppHelpManager sharedInstance] isPhoneNum:self.forPhoneTextField.text]) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"请输入合法的手机号"];
        return;
    }
    
    getTwoCode=YES;
    [self.getVeifiButton setTitle:[NSString stringWithFormat:@"%lds",(long)secondsCountDown] forState:UIControlStateNormal];
    
    [self.getVeifiButton setTitleColor:[UIColor colorWithRed:80/255.0 green:170/255.0 blue:240/255.0 alpha:0.5] forState:UIControlStateNormal];
    
    [self.getVeifiButton setBackgroundImage:[UIImage imageNamed:@"getYanZhenbg.png"] forState:UIControlStateNormal];
    self.getVeifiButton.userInteractionEnabled = NO;
    countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [self getVerificationCodeMethod];
}

/**************停止验证码倒计时操作***************/
-(void)stopCountDown{
    getTwoCode=NO;
    [self.getVeifiButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.getVeifiButton setTitleColor:[UIColor colorWithRed:80/255.0 green:170/255.0 blue:240/255.0 alpha:1] forState:UIControlStateNormal];
    secondsCountDown=60;
    [countDownTimer invalidate];
    self.getVeifiButton.userInteractionEnabled=YES;
}
/**************验证码倒计时操作***************/
-(void)timeFireMethod{
    secondsCountDown--;
    if (secondsCountDown==0) {
        [self stopCountDown];
    }else{
        [self.getVeifiButton setTitle:[NSString stringWithFormat:@"%lds",(long)secondsCountDown] forState:UIControlStateNormal];
    }
}
/**************获取验证码操作***************/
- (void)getVerificationCodeMethod {
    if (self.forPhoneTextField.text.length==0) {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
    }else if (![[AppHelpManager sharedInstance] isPhoneNum:self.forPhoneTextField.text]){
        [SVProgressHUD showImage:nil status:@"请输入合法的手机号"];
    }else {
        [[AppHttpManager shareInstance] getSendPwdCodeWithPhoneNo:self.forPhoneTextField.text PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                NSLog(@"%@",dict);
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                
                getTwoCode=NO;
                [self.getVeifiButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getVeifiButton setTitleColor:[UIColor colorWithRed:80/255.0 green:170/255.0 blue:240/255.0 alpha:1] forState:UIControlStateNormal];
                secondsCountDown=60;
                [countDownTimer invalidate];
                self.getVeifiButton.userInteractionEnabled=YES;
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }
}

#pragma mark - 输入密码 密文
- (IBAction)forIsMiWenButtonClick:(id)sender {
    static BOOL isShowMiWen = NO;
    
    if (!isShowMiWen) {
        [sender setImage:[UIImage imageNamed:@"loginxianshi.png"] forState:UIControlStateNormal];
        self.againPassTextField.secureTextEntry = NO;
        isShowMiWen = YES;
    }else {
        [sender setImage:[UIImage imageNamed:@"loginyincang.png"] forState:UIControlStateNormal];
        self.forNewPassTextField.secureTextEntry = YES;
        isShowMiWen = NO;
    }
}

#pragma mark - 再次输入密码 密文
- (IBAction)forAgainIsMiWenButtonClick:(id)sender {
    static BOOL isShowMiWen = NO;
    
    if (!isShowMiWen) {
        [sender setImage:[UIImage imageNamed:@"loginxianshi.png"] forState:UIControlStateNormal];
        self.againPassTextField.secureTextEntry = NO;
        isShowMiWen = YES;
    }else {
        [sender setImage:[UIImage imageNamed:@"loginyincang.png"] forState:UIControlStateNormal];
        self.forNewPassTextField.secureTextEntry = YES;
        isShowMiWen = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
