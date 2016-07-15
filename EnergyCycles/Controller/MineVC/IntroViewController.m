//
//  IntroViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()<UITextViewDelegate>

@property (nonatomic, strong) NSString *updateIntroString;
// 修改
@property (nonatomic, strong) UIButton *changeButton;

@end

@implementation IntroViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"简介";
    
    self.introTextView.placehoder = @"可输入200字";
    
    
    self.introTextView.backgroundColor = [UIColor whiteColor];
    self.introTextView.layer.borderWidth = 1.f;
    self.introTextView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    self.introTextView.layer.masksToBounds = YES;
    self.introTextView.layer.cornerRadius = 2.f;
    self.introTextView.delegate = self;
    
    self.changeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.changeButton.frame = CGRectMake(0, 0, 35, 30);
    [self.changeButton setTitle:@"修改" forState:UIControlStateNormal];
    [self.changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.changeButton setTintColor:[UIColor whiteColor]];
    [self.changeButton addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.changeButton];
    self.navigationItem.rightBarButtonItem = item;
    
    if (![self.introString isEqualToString:@""]) {
        self.introTextView.text = self.introString;
        self.changeButton.enabled = NO;
        [self.changeButton setTitleColor:[UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:0.8] forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view.
}

- (void)changeAction {
    if (self.updateIntroString.length > 200) {
        [SVProgressHUD showImage:nil status:@"请将字数限制在200字以内"];
    } else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"提交中.."];
        
        [[AppHttpManager shareInstance] changeBriefWithUserid:[User_ID intValue] Token:User_TOKEN Brief:self.updateIntroString PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
            }
        } failure:^(NSString *str) {
            [SVProgressHUD showImage:nil status:@"请检查您的网络"];
        }];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.introString isEqualToString:textView.text]) {
        self.changeButton.enabled = NO;
        [self.changeButton setTitleColor:[UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:0.8] forState:UIControlStateNormal];
    } else {
        self.changeButton.enabled = YES;
        [self.changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.updateIntroString = textView.text;
    }
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
