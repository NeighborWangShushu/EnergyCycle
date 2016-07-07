//
//  NewVerificationPhoneViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NewVerificationPhoneViewController.h"
#import "AMChangePhoneViewController.h"

@interface NewVerificationPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeField;

@property (nonatomic, strong) NSString *code;

@property (weak, nonatomic) IBOutlet UIButton *getCode;

@end

@implementation NewVerificationPhoneViewController

- (IBAction)getVerificationCode:(id)sender {
    [[AppHttpManager shareInstance] getVerificationCodeWithPhoneNo:self.phoneNumberField.text Type:1 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1)  {
            self.code = dict[@"Data"];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}


- (IBAction)VerificationSuccess:(id)sender {
    if (self.code == self.verificationCodeField.text) {
        [[AppHttpManager shareInstance] changePhoneNumberWithUserid:[User_ID intValue] Token:User_TOKEN Phone:self.phoneNumberField.text PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"修改成功"];
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumberField.text forKey:@"PHONE"];
                
                UIViewController *amVC = [self.navigationController.viewControllers objectAtIndex:1];
                [self.navigationController popToViewController:amVC animated:YES];
            } else {
                [SVProgressHUD showImage:nil status:@"修改失败"];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@",str);
        }];
    } else {
        [SVProgressHUD showImage:nil status:@"验证码错误"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账号管理";
    
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
