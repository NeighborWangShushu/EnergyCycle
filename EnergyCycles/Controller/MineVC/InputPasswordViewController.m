//
//  InputPasswordViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InputPasswordViewController.h"

@interface InputPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;

@property (weak, nonatomic) IBOutlet UIButton *passwordFieldEye;

@property (weak, nonatomic) IBOutlet UIButton *repeatPasswordFieldEye;

@end

@implementation InputPasswordViewController

- (IBAction)passwordFieldEye:(id)sender {
    if (self.passwordField.secureTextEntry) {
        [sender setImage:[UIImage imageNamed:@"loginxianshi.png"] forState:UIControlStateNormal];
        self.passwordField.secureTextEntry = NO;
    } else {
        [sender setImage:[UIImage imageNamed:@"loginyincang.png"] forState:UIControlStateNormal];
        self.passwordField.secureTextEntry = YES;
    }
}

- (IBAction)repeatPasswordFieldEye:(id)sender {
    if (self.repeatPasswordField.secureTextEntry) {
        [sender setImage:[UIImage imageNamed:@"loginxianshi.png"] forState:UIControlStateNormal];
        self.repeatPasswordField.secureTextEntry = NO;
    } else {
        [sender setImage:[UIImage imageNamed:@"loginyincang.png"] forState:UIControlStateNormal];
        self.repeatPasswordField.secureTextEntry = YES;
    }
}


- (IBAction)bound:(id)sender {
    
    if ([self.passwordField.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
    } else if ([self.repeatPasswordField.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入确认密码"];
    } else if (![[AppHelpManager sharedInstance] isValidPassword:self.passwordField.text]) {
        [SVProgressHUD showImage:nil status:@"密码由6到16位数字或字母组成"];
    } else if (![self.passwordField.text isEqualToString:self.repeatPasswordField.text]) {
        [SVProgressHUD showImage:nil status:@"两次输入密码不一致"];
    } else {
        [[AppHttpManager shareInstance] changePasswordWithUserid:[User_ID intValue] Token:User_TOKEN Pwd:[self md5StringForString:self.passwordField.text] Phone:self.phoneNumber PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"绑定成功"];
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumber forKey:@"PHONE"];
                [[NSUserDefaults standardUserDefaults] setObject:[self md5StringForString:self.passwordField.text] forKey:@"PASSWORD"];
                [self performSegueWithIdentifier:@"BoundSuccessViewController" sender:nil];
            } else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"]];
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
    [self setupLeftNavBarWithimage:@"loginfanhui"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账号管理";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    self.passwordField.secureTextEntry = YES;
    self.repeatPasswordField.secureTextEntry = YES;
    
    self.passwordField.delegate = self;
    self.repeatPasswordField.delegate = self;
    
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
