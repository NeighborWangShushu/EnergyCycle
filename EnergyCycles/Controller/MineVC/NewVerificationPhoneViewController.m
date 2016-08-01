//
//  NewVerificationPhoneViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NewVerificationPhoneViewController.h"
#import "AMChangePhoneViewController.h"

#define timeNumber 50

@interface NewVerificationPhoneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeField;

@property (weak, nonatomic) IBOutlet UIButton *getCode;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, assign) BOOL enabled;


@end

@implementation NewVerificationPhoneViewController

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
    [[AppHttpManager shareInstance] getVerificationCodeWithPhoneNo:self.phoneNumberField.text Type:1 PostOrGet:@"get" success:^(NSDictionary *dict) {
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


- (IBAction)VerificationSuccess:(id)sender {
    if ([self.phoneNumberField.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入手机号"];
    } else if (![[AppHelpManager sharedInstance] isPhoneNum:self.phoneNumberField.text]) {
        [SVProgressHUD showImage:nil status:@"请输入合法的手机号"];
    } else if ([self.verificationCodeField.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入验证码"];
    } else if (self.code != self.verificationCodeField.text) {
        [SVProgressHUD showImage:nil status:@"验证码错误"];
    } else {
        [[AppHttpManager shareInstance] changePhoneNumberWithUserid:[User_ID intValue] Token:User_TOKEN Phone:self.phoneNumberField.text PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"修改成功"];
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumberField.text forKey:@"PHONE"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangePhoneNumber" object:self userInfo:@{@"phone":self.phoneNumberField.text,@"text":@"您已成功绑定手机号"}];
                UIViewController *amVC = [self.navigationController.viewControllers objectAtIndex:2];
                [self.navigationController popToViewController:amVC animated:YES];
            } else {
                [SVProgressHUD showImage:nil status:@"修改失败"];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
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
    [self setupLeftNavBarWithimage:@"loginfanhui"];

    self.timeCount = timeNumber;
    self.enabled = NO;
    
    self.phoneNumberField.delegate = self;
    self.verificationCodeField.delegate = self;
    self.phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationCodeField.keyboardType = UIKeyboardTypeNumberPad;
    
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
