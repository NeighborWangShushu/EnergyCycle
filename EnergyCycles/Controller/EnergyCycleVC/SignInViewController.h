//
//  SignInViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface SignInViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *signBackView;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
//
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *tianLabel;

//签到
@property (weak, nonatomic) IBOutlet UIButton *signButton;
- (IBAction)signButtonClick:(UIButton *)sender;



@end
