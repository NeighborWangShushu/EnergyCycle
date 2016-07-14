//
//  tabbarView.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "TabbarView.h"
#import "Masonry.h"

@interface TabbarView ()
{
    UIButton * lastButton;
}

@property (nonatomic,strong)NSMutableArray * buttonDatas;

@end

@implementation TabbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
//        [self setBackgroundColor:[UIColor blueColor]];
        [self layoutView];
    }
    return self;
}

- (NSMutableArray*)buttonDatas {
    if (!_buttonDatas) {
        _buttonDatas = [NSMutableArray array];
    }
    return _buttonDatas;
}

-(void)layoutView
{
    [self layoutBtn];
}

-(void)layoutBtn
{
    _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_1 setImage:[UIImage imageNamed:@"tabbar_normal_1"] forState:UIControlStateNormal];
    [_button_1 setImage:[UIImage imageNamed:@"tabbar_pressed_1"] forState:UIControlStateDisabled];
    [_button_1 setImage:[UIImage imageNamed:@"tabbar_pressed_1"] forState:UIControlStateSelected];
    [_button_1 setImage:[UIImage imageNamed:@"tabbar_normal_1"] forState:UIControlStateHighlighted];
    [_button_1 setTag:0];
    [_button_1 setSelected:YES];
    [_button_1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setImage:[UIImage imageNamed:@"tabbar_normal_2"] forState:UIControlStateNormal];
    [_button_2 setImage:[UIImage imageNamed:@"tabbar_pressed_2"] forState:UIControlStateSelected];
    [_button_2 setImage:[UIImage imageNamed:@"tabbar_normal_2"] forState:UIControlStateHighlighted];
    [_button_4 setImage:[UIImage imageNamed:@"tabbar_pressed_2"] forState:UIControlStateDisabled];
    [_button_2 setTag:1];
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_center = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_center.adjustsImageWhenHighlighted = YES;
    [_button_center setBackgroundImage:[UIImage imageNamed:@"ec_center_button"] forState:UIControlStateNormal];
    [_button_center setBackgroundImage:[UIImage imageNamed:@"ec_center_button"] forState:UIControlStateHighlighted];
    [_button_center addTarget:self action:@selector(centerAction) forControlEvents:UIControlEventTouchUpInside];

    _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setImage:[UIImage imageNamed:@"tabbar_normal_3"] forState:UIControlStateNormal];
    [_button_3 setImage:[UIImage imageNamed:@"tabbar_pressed_3"] forState:UIControlStateSelected];
    [_button_3 setImage:[UIImage imageNamed:@"tabbar_normal_3"] forState:UIControlStateHighlighted];
    [_button_4 setImage:[UIImage imageNamed:@"tabbar_pressed_3"] forState:UIControlStateDisabled];
    [_button_3 setTag:2];
    [_button_3 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setImage:[UIImage imageNamed:@"tabbar_normal_4"] forState:UIControlStateNormal];
    [_button_4 setImage:[UIImage imageNamed:@"tabbar_pressed_4"] forState:UIControlStateSelected];
    [_button_4 setImage:[UIImage imageNamed:@"tabbar_normal_4"] forState:UIControlStateHighlighted];
    [_button_4 setImage:[UIImage imageNamed:@"tabbar_pressed_4"] forState:UIControlStateDisabled];
    [_button_4 setTag:3];
    [_button_4 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button_1];
    [self addSubview:_button_2];
    [self addSubview:_button_center];
    [self addSubview:_button_3];
    [self addSubview:_button_4];
    
    
    [_button_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(Screen_width/5));
        make.height.equalTo(@49);
    }];
    
    [_button_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button_1.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(Screen_width/5));
        make.height.equalTo(@49);
    }];
    
    [_button_center mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button_2.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(Screen_width/5));
        make.height.equalTo(@68);
    }];
    
    [_button_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button_center.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(Screen_width/5));
        make.height.equalTo(@49);
    }];
    
    [_button_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button_3.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@49);
    }];
    
    lastButton = _button_1;
    [self.buttonDatas addObject:_button_1];
    [self.buttonDatas addObject:_button_2];
    [self.buttonDatas addObject:_button_3];
    [self.buttonDatas addObject:_button_4];
}

- (void)centerAction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnergyCycleViewToPostView" object:nil];
}

-(void)btn1Click:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [lastButton setSelected:NO];
    [lastButton setUserInteractionEnabled:YES];
    [btn setSelected:YES];
    [btn setUserInteractionEnabled:NO];
    if ([self.delegate respondsToSelector:@selector(touchBtnAtIndex:)]) {
        [self.delegate touchBtnAtIndex:btn.tag];
    }
    lastButton = btn;
}

- (void)setSelectedIndex:(NSInteger)index {
    
    [lastButton setSelected:NO];
    [lastButton setUserInteractionEnabled:YES];
    UIButton*btn = (UIButton*)self.buttonDatas[index];
    [btn setSelected:YES];
    [btn setUserInteractionEnabled:NO];
    if ([self.delegate respondsToSelector:@selector(touchBtnAtIndex:)]) {
        [self.delegate touchBtnAtIndex:index];
    }
    lastButton = btn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
