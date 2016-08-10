//
//  CoustomGiftView.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CoustomGiftView.h"

@interface CoustomGiftView () {
    UITextField *inputTextField;
    NSString *myNickName;
}

@end

@implementation CoustomGiftView

- (instancetype)initWithFrame:(CGRect)frame withNickName:(NSString *)nickName {
    self = [super initWithFrame:frame];
    if (self) {
        myNickName = nickName;
        [self showUI];
    }
    
    return self;
}

#pragma mark - 创建界面
- (void)showUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, Screen_Height/2-110, Screen_width-40, 220)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 3.f;
    [self addSubview:backView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width-40, 45)];
    headView.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    [backView addSubview:headView];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_width-40, 45)];
    headLabel.text = [NSString stringWithFormat:@"赠送积分给%@",myNickName];
    headLabel.font = [UIFont systemFontOfSize:17];
    headLabel.textColor = [UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:headLabel];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0+109*Screen_width/375, 64, 15, 18)];
    iconImageView.image = [UIImage imageNamed:@"yingbi.png"];
    [backView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(109*Screen_width/375+20, 62, Screen_width-40-109*Screen_width/375+20, 22)];
    titleLabel.text = [NSString stringWithFormat:@"我的积分%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserJiFen"]];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:titleLabel];
    
    inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(28, 103, Screen_width-40-56, 39)];
    inputTextField.placeholder = @"  填写赠送积分";
    inputTextField.layer.borderWidth = 1.f;
    inputTextField.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.15].CGColor;
    inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:inputTextField];
    
    UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 176, Screen_width-40, 1)];
    downLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    [backView addSubview:downLineView];
    
    NSArray *titleArr = @[@"取消",@"确定"];
    for (NSInteger i=0; i<titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((Screen_width-40)/2 * i, 176, (Screen_width-40)/2, 43);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        
        if (i == 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((Screen_width-40)/2, 176, 1, 44)];
            lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
            [backView addSubview:lineView];
        }
        button.tag = 4301+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backView addSubview:button];
    }
}

#pragma mark - button点击事件
- (void)buttonClick:(UIButton *)button {
    if (button.tag == 4302) {
        if (inputTextField.text.length <= 0) {
            [SVProgressHUD showImage:nil status:@"请输入积分"];
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserJiFen"] integerValue] < [inputTextField.text integerValue]) {
            [SVProgressHUD showImage:nil status:@"积分不足"];
        }else {
            _customGitView(inputTextField.text, button.tag-4301);
        }
    }else {
        _customGitView(@"0", button.tag-4301);
    }
}



@end
