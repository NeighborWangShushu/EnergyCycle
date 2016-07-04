//
//  CoursesInputViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface CoursesInputViewController : BaseViewController

//
@property (nonatomic, copy) void(^inputInformation)(NSString *inputStr,NSInteger touSec,NSInteger touIndex);

//传值
@property (nonatomic, strong) NSString *inputLeftStr;
//
@property (nonatomic, strong) NSString *touchuSection;
//
@property (nonatomic, strong) NSString *touchuIndex;

//背景
@property (weak, nonatomic) IBOutlet UIView *backView;
//
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
//
@property (weak, nonatomic) IBOutlet UIButton *delButton;
//
- (IBAction)delButtonClick:(id)sender;


@end
