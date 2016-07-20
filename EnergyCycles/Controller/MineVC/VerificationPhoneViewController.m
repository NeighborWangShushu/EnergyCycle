//
//  VerificationPhoneViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VerificationPhoneViewController.h"
#import "InputPasswordViewController.h"

@interface VerificationPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (weak, nonatomic) IBOutlet UITextField *verificationCode;

@property (weak, nonatomic) IBOutlet UIButton *getCode;

@property (nonatomic, strong) NSString *code;

@end

@implementation VerificationPhoneViewController

- (IBAction)getVerificationCode:(id)sender {
    [[AppHttpManager shareInstance] getVerificationCodeWithPhoneNo:self.phoneNumberField.text Type:2 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1)  {
            self.code = dict[@"Data"];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

- (IBAction)verificationPhone:(id)sender {
//    if (self.code == self.verificationCode.text) {
//        [self performSegueWithIdentifier:@"InputPasswordViewController" sender:nil];
//    }
    [self performSegueWithIdentifier:@"InputPasswordViewController" sender:nil];
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"InputPasswordViewController"]) {
        InputPasswordViewController *inputVC = segue.destinationViewController;
        inputVC.phoneNumber = self.phoneNumberField.text;
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
