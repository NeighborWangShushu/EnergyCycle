//
//  AMBoundPhoneViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AMBoundPhoneViewController.h"

@interface AMBoundPhoneViewController ()

@end

@implementation AMBoundPhoneViewController

- (IBAction)verificationPhone:(id)sender {
    [self performSegueWithIdentifier:@"VerificationPhoneViewController" sender:nil];
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
