//
//  BoundSuccessViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BoundSuccessViewController.h"

@interface BoundSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *boundSuccess;

@end

@implementation BoundSuccessViewController

- (IBAction)back:(id)sender {
    UIViewController *settingVC = [self.navigationController.viewControllers objectAtIndex:0];
    [self.navigationController popToViewController:settingVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账号管理";
    
    [self.boundSuccess.text stringByReplacingCharactersInRange:NSMakeRange(6, 11) withString:[[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE"]];
    [self.boundSuccess.text stringByReplacingCharactersInRange:NSMakeRange(9, 4) withString:@"****"];
    
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
