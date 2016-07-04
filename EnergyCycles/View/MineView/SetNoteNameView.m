//
//  SetNoteNameView.m
//  EnergyCycles
//
//  Created by Adinnet on 16/3/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SetNoteNameView.h"

@interface SetNoteNameView () <UITextFieldDelegate> {
    UITextField *inputTextFiled;
    UIView *backView;
}

@property (nonatomic, assign) NSInteger getTag;


@end

@implementation SetNoteNameView


- (instancetype)initWithFrame:(CGRect)frame withTag:(NSInteger)tag {
    if (self == [super initWithFrame:frame]) {\
        
        self.getTag = tag;
        [self creatShowUI];
    }
    
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect rect = backView.frame;
    rect.origin.y = rect.origin.y-60;
    backView.frame = rect;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    CGRect rect = backView.frame;
    rect.origin.y = Screen_Height/2-110;
    backView.frame = rect;
    
    return YES;
}

#pragma mark - 创建界面
- (void)creatShowUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    backView = [[UIView alloc] initWithFrame:CGRectMake(20, Screen_Height/2-110, Screen_width-40, 220)];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 3.f;
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    //
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_width-40, 45)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设置备注名";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    [backView addSubview:titleLabel];
    
    //
    UIView *inputBackView = [[UIView alloc] initWithFrame:CGRectMake(28, 45+45, Screen_width-40-28*2, 50)];
    inputBackView.layer.borderWidth = 1.f;
    inputBackView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.15].CGColor;
    [backView addSubview:inputBackView];
    
    inputTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, Screen_width-40-28*2-20, 50)];
    inputTextFiled.placeholder = @"请填写备注名";
    inputTextFiled.delegate = self;
    [inputBackView addSubview:inputTextFiled];
    
    //
    UIView *downLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 220-45, Screen_width-40, 1)];
    downLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    [backView addSubview:downLineView];
    
    NSArray *titleArr = @[@"取消",@"确定"];
    for (NSInteger i=0; i<titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0+(Screen_width-40)/2*i, 220-44, (Screen_width-40)/2, 44);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        
        if (i == 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((Screen_width-40)/2, 176, 1, 44)];
            lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
            [backView addSubview:lineView];
        }
        button.tag = 4301+i;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backView addSubview:button];
    }
}

#pragma mark - 按键响应事件
- (void)buttonClick:(UIButton *)button {
    if (button.tag == 4302) {
        if (inputTextFiled.text.length <= 0) {
            [SVProgressHUD showImage:nil status:@"请输入备注名"];
        }else {
            if (_setNoteNameStr) {
                _setNoteNameStr(inputTextFiled.text,button.tag-4301);
            }
        }
    }else {
        if (_setNoteNameStr) {
            _setNoteNameStr(@"",button.tag-4301);
        }
    }
}



@end
