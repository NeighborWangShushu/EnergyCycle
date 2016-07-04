//
//  OtherUesrViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/24.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface OtherUesrViewController : BaseViewController

//返回按键
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonClick:(id)sender;

//
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

//
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//
@property (weak, nonatomic) IBOutlet UILabel *guanzhuLabel;
//查看当前用户的关注的人
@property (weak, nonatomic) IBOutlet UIButton *guanzhuNumButton;
- (IBAction)guanzhuNumButtonClick:(UIButton *)sender;

//
@property (weak, nonatomic) IBOutlet UILabel *fensiLabel;
//查看当前用户的粉丝
@property (weak, nonatomic) IBOutlet UIButton *fensiNumButton;
- (IBAction)fensiNumButtonClick:(UIButton *)sender;

//关注按键
@property (weak, nonatomic) IBOutlet UIButton *guanzhuButton;
- (IBAction)guanzhuButtonClick:(id)sender;

//发私信
@property (weak, nonatomic) IBOutlet UIButton *fasixinButton;
- (IBAction)fasixinButtonClick:(id)sender;

//
@property (weak, nonatomic) IBOutlet UIButton *nengButton;
//
@property (weak, nonatomic) IBOutlet UIButton *meiButton;
//
@property (weak, nonatomic) IBOutlet UIButton *jinButton;
//
@property (weak, nonatomic) IBOutlet UIButton *tuijianButton;

//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nengButtonAutoLayoutWith;
//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nengButtonAutoLayoutHight;
//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nengLabelAutoLayoutWith;

//
@property (nonatomic, strong) NSString *otherUserId;
@property (nonatomic, strong) NSString *otherName;
@property (nonatomic, strong) NSString *otherPic;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneButtonHeadHightAutoLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teoButtonHeadHightAutoLayout;


@end
