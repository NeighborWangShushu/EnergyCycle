//
//  ForgetPassWordViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface ForgetPassWordViewController : BaseViewController

//手机号
@property (weak, nonatomic) IBOutlet UITextField *forPhoneTextField;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *forVerifiTextField;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *forNewPassTextField;
//确认新密码
@property (weak, nonatomic) IBOutlet UITextField *againPassTextField;

//完成
@property (weak, nonatomic) IBOutlet UIButton *comButton;
- (IBAction)comButtonClick:(id)sender;

//获取短信验证码
@property (weak, nonatomic) IBOutlet UIButton *getVeifiButton;
- (IBAction)getVeifiButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *forIsMiWenButton;
- (IBAction)forIsMiWenButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *forAgainIsMiWenButton;
- (IBAction)forAgainIsMiWenButtonClick:(id)sender;

//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetTopImageAutoLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetTopTextFieldAutoLayout;



@end
