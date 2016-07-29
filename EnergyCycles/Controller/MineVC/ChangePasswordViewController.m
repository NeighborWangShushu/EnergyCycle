//
//  ChangePasswordViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *originalPasswordField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordField;

@property (weak, nonatomic) IBOutlet UIButton *originalPasswordFieldEye;

@property (weak, nonatomic) IBOutlet UIButton *passwordFieldEye;

@property (weak, nonatomic) IBOutlet UIButton *repeatPasswordFieldEye;

@end

@implementation ChangePasswordViewController


- (IBAction)originalPasswordFieldEye:(id)sender {
    if (self.originalPasswordField.secureTextEntry) {
        [sender setImage:[UIImage imageNamed:@"loginxianshi.png"] forState:UIControlStateNormal];
        self.originalPasswordField.secureTextEntry = NO;
    } else {
        [sender setImage:[UIImage imageNamed:@"loginyincang.png"] forState:UIControlStateNormal];
        self.originalPasswordField.secureTextEntry = YES;
    }
}

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

- (IBAction)changePassword:(id)sender {
    if ([self.originalPasswordField.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入原密码" maskType:SVProgressHUDMaskTypeClear];
    } else if ([self.passwordField.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入新密码" maskType:SVProgressHUDMaskTypeClear];
    } else if ([self.passwordField.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入确认密码" maskType:SVProgressHUDMaskTypeClear];
    } else if (![[self md5StringForString:self.originalPasswordField.text] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"]]) {
        [SVProgressHUD showImage:nil status:@"密码错误" maskType:SVProgressHUDMaskTypeClear];
    } else if (![[AppHelpManager sharedInstance] isValidPassword:self.passwordField.text]) {
        [SVProgressHUD showImage:nil status:@"密码由6到16位数字或字母组成" maskType:SVProgressHUDMaskTypeClear];
    } else if (![self.passwordField.text isEqualToString:self.repeatPasswordField.text]) {
        [SVProgressHUD showImage:nil status:@"两次输入密码不一致" maskType:SVProgressHUDMaskTypeClear];
    } else {
        [[AppHttpManager shareInstance] changePasswordWithUserid:[User_ID intValue] Token:User_TOKEN Pwd:[self md5StringForString:self.passwordField.text] Phone:[[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"修改成功" maskType:SVProgressHUDMaskTypeClear];
                [[NSUserDefaults standardUserDefaults] setObject:[self md5StringForString:self.passwordField.text] forKey:@"PASSWORD"];
                [self performSegueWithIdentifier:@"ModelToLoginNavController" sender:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
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
    
    self.originalPasswordField.secureTextEntry = YES;
    self.passwordField.secureTextEntry = YES;
    self.repeatPasswordField.secureTextEntry = YES;
    
    self.originalPasswordField.delegate = self;
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
