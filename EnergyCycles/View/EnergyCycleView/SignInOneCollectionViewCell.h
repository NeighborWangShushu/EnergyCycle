//
//  SignInOneCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SignInModel.h"

@interface SignInOneCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLeftAutoLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewRightAutoLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneImageAutoLayoutLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoImageAutoLayoutLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneButtonAutoLayoutLeft;

//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;

@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;

@property (weak, nonatomic) IBOutlet UIImageView *fourImageView;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;

@property (weak, nonatomic) IBOutlet UIImageView *fiveImageView;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;

@property (weak, nonatomic) IBOutlet UIImageView *sixImageView;
@property (weak, nonatomic) IBOutlet UIButton *sixButton;

@property (weak, nonatomic) IBOutlet UIImageView *sevenImageView;
@property (weak, nonatomic) IBOutlet UIButton *sevenButton;

@property (weak, nonatomic) IBOutlet UIImageView *eightImageView;
@property (weak, nonatomic) IBOutlet UIButton *eightButton;

@property (weak, nonatomic) IBOutlet UIImageView *nineImageView;
@property (weak, nonatomic) IBOutlet UIButton *nineButton;

@property (weak, nonatomic) IBOutlet UIImageView *tenImageView;
@property (weak, nonatomic) IBOutlet UIButton *tenButton;

@property (weak, nonatomic) IBOutlet UIImageView *elevenImageView;
@property (weak, nonatomic) IBOutlet UIButton *elevenButton;


//签到点击事件
@property (nonatomic, copy) void(^signInButtonClcik)(void);

//填充数据
- (void)signInCollectionViewWithDataWithIndex:(NSInteger)index withMonthDay:(NSInteger)days withArr:(NSArray *)getArr withToday:(NSString *)today withNow:(NSString *)nowDay;


@end
