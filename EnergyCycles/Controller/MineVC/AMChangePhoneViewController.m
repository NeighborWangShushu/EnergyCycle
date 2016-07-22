//
//  AMChangePhoneViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AMChangePhoneViewController.h"

@interface AMChangePhoneViewController ()


@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;


@end

@implementation AMChangePhoneViewController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (IBAction)changePhone:(id)sender {
    [self performSegueWithIdentifier:@"VerificationPasswordViewController" sender:nil];
}

- (IBAction)changePassword:(id)sender {
    [self performSegueWithIdentifier:@"ChangePasswordViewController" sender:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账号管理";
//    NSString *addCipher = [[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"];
//    self.phoneNumberLabel.text = [addCipher stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//    NSLog(@"phone number %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextAndPhone:) name:@"ChangePhoneNumber" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)changeTextAndPhone:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *addCipher = dic[@"phone"];
    self.phoneNumberLabel.text = [addCipher stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.textLabel.text = dic[@"text"];
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
