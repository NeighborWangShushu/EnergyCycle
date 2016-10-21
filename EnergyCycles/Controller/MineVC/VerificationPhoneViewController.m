//
//  VerificationPhoneViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VerificationPhoneViewController.h"
#import "InputPasswordViewController.h"

#define timeNumber 50

@interface VerificationPhoneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (weak, nonatomic) IBOutlet UILabel *hint;

@property (weak, nonatomic) IBOutlet UITextField *verificationCode;

@property (weak, nonatomic) IBOutlet UIButton *getCode;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, assign) BOOL enabled;


@end

@implementation VerificationPhoneViewController

- (IBAction)getVerificationCode:(id)sender {
    if (self.enabled) {
        return;
    } else if ([self.phoneNumberField.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
    } else if (![[AppHelpManager sharedInstance] isPhoneNum:self.phoneNumberField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入合法的手机号"];
    } else {
        self.enabled = YES;
        
        [self.getCode setTitle:[NSString stringWithFormat:@"%lds",(long)self.timeCount] forState:UIControlStateNormal];
        [self.getCode setTitleColor:[UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1] forState:UIControlStateNormal];
        self.getCode.userInteractionEnabled = NO;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        
        [self getVerificationCodeMethod];
    }
}

// 停止验证码倒计时
- (void)stopTime {
    self.enabled = NO;
    [self.getCode setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.getCode setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8] forState:UIControlStateNormal];
    self.timeCount = timeNumber;
    [self.timer invalidate];
    self.getCode.userInteractionEnabled = YES;
}

// 获取验证码倒计时
- (void)timeFireMethod {
    self.timeCount--;
    if (self.timeCount == 0) {
        [self stopTime];
    } else {
        [self.getCode setTitle:[NSString stringWithFormat:@"%lds",(long)self.timeCount] forState:UIControlStateNormal];
    }
}

// 获取验证码
- (void)getVerificationCodeMethod {
    if (self.isOtherLogin) {
        [[AppHttpManager shareInstance] getTelCodeWithUserid:[User_ID intValue] Tel:self.phoneNumberField.text PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1)  {
                self.code = dict[@"Data"];
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            } else {
                self.enabled = NO;
                [self.getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getCode setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8] forState:UIControlStateNormal];
                self.getCode.userInteractionEnabled = YES;
                self.timeCount = timeNumber;
                [self.timer invalidate];
                
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    } else {
        [[AppHttpManager shareInstance] getVerificationCodeWithPhoneNo:self.phoneNumberField.text Type:2 PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1)  {
                self.code = dict[@"Data"];
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            } else {
                self.enabled = NO;
                [self.getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.getCode setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8] forState:UIControlStateNormal];
                self.getCode.userInteractionEnabled = YES;
                self.timeCount = timeNumber;
                [self.timer invalidate];
                
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    }

}

- (IBAction)verificationPhone:(id)sender {
    if ([self.phoneNumberField.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
    } else if (![[AppHelpManager sharedInstance] isPhoneNum:self.phoneNumberField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入合法的手机号"];
    } else if ([self.verificationCode.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入验证码"];
    } else if (![self.code isEqualToString:self.verificationCode.text]) {
        [SVProgressHUD showImage:nil status:@"验证码错误"];
    } else {
        if (self.isOtherLogin) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PhoneNumberChange" object:@{@"phoneNumber" : self.phoneNumberField.text}];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[AppHttpManager shareInstance] changePhoneNumberWithUserid:[User_ID intValue] Token:User_TOKEN Phone:self.phoneNumberField.text PostOrGet:@"post" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                    [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                    [self performSegueWithIdentifier:@"InputPasswordViewController" sender:nil];
                } else {
                    [SVProgressHUD showImage:nil status:dict[@"Msg"]];
                }
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
        }
    }
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"InputPasswordViewController"]) {
        InputPasswordViewController *inputVC = segue.destinationViewController;
        inputVC.phoneNumber = self.phoneNumberField.text;
    }
}

// 限制文本框输入的字符长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = textField.text.length + string.length - range.length;
    return newLength <= 19;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账号管理";
    if (self.isOtherLogin) {
        self.navigationItem.title = @"更改手机号";
    }
    if (self.havePhone) {
        self.hint.text = @"请输入新的绑定手机号";
    }
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    self.timeCount = timeNumber;
    self.enabled = NO;
    
    self.phoneNumberField.delegate = self;
    self.verificationCode.delegate = self;
    self.phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationCode.keyboardType = UIKeyboardTypeNumberPad;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
