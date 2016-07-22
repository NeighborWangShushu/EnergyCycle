//
//  VerificationPasswordViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VerificationPasswordViewController.h"

@interface VerificationPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *passwordFieldEye;

@end

@implementation VerificationPasswordViewController

- (IBAction)passwordFieldEye:(id)sender {
    if (self.passwordField.secureTextEntry) {
        [sender setImage:[UIImage imageNamed:@"loginxianshi.png"] forState:UIControlStateNormal];
        self.passwordField.secureTextEntry = NO;
    } else {
        [sender setImage:[UIImage imageNamed:@"loginyincang.png"] forState:UIControlStateNormal];
        self.passwordField.secureTextEntry = YES;
    }
}

- (IBAction)verificationPassword:(id)sender {
    if ([self.passwordField.text length] == 0) {
        [SVProgressHUD showImage:nil status:@"请输入密码"];
    } else if (![[AppHelpManager sharedInstance] isValidPassword:self.passwordField.text]) {
        [SVProgressHUD showImage:nil status:@"密码由6到16位数字或字母组成"];
    } else if (![[self md5StringForString:self.passwordField.text] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"]]) {
        [SVProgressHUD showImage:nil status:@"密码不正确"];
//        NSLog(@"%@\n%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"], [self md5StringForString:self.passwordField.text]);
    } else {
        [self performSegueWithIdentifier:@"NewVerificationPhoneViewController" sender:nil];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账号管理";
    
    self.passwordField.secureTextEntry = YES;
    self.passwordField.delegate = self;
    
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
