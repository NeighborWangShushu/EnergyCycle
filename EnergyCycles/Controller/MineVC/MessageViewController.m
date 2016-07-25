//
//  MessageViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)commentClick:(id)sender {
    [self changeLineFrameAndTextColor:sender];
}

- (IBAction)likeClick:(id)sender {
    [self changeLineFrameAndTextColor:sender];
}

- (IBAction)messageClick:(id)sender {
    [self changeLineFrameAndTextColor:sender];
}

// 改变下划线的位置与按钮的颜色
- (void)changeLineFrameAndTextColor:(UIButton *)button {
    [self.commentButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.8] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.8] forState:UIControlStateNormal];
    [self.messageButton setTitleColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.8] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    self.underLine.frame = CGRectMake(button.frame.origin.x, self.underLine.frame.origin.y, self.underLine.frame.size.width, self.underLine.frame.size.height);
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
