//
//  tabbarView.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "TabbarView.h"



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

-(void)layoutView
{

    _tabbarViewCenter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_mainbtn_bg"]];

    _tabbarViewCenter.center = CGPointMake(self.center.x, self.bounds.size.height/2.0);
    
    [_tabbarViewCenter setUserInteractionEnabled:YES];
    
    _button_center = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_center.adjustsImageWhenHighlighted = YES;
    [_button_center setBackgroundImage:[UIImage imageNamed:@"tabbar_mainbtn"] forState:UIControlStateNormal];
    
    [_button_center setFrame:CGRectMake(0, 0, 46, 46)];
    
    _button_center.center =CGPointMake(_tabbarViewCenter.bounds.size.width/2.0, _tabbarViewCenter.bounds.size.height/2.0 + 5) ;
    
    [_tabbarViewCenter addSubview:_button_center];
    
    [self addSubview:_tabbarViewCenter];
    
    [self layoutBtn];

}

-(void)layoutBtn
{
    _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_1 setImage:[UIImage imageNamed:@"tabbar_normal_1"] forState:UIControlStateNormal];
    [_button_1 setImage:[UIImage imageNamed:@"tabbar_pressed_1"] forState:UIControlStateSelected];
    [_button_1 setFrame:CGRectMake(0, 0, 64, 60)];
    [_button_1 setTag:101];
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setImage:[UIImage imageNamed:@"tabbar_normal_2"] forState:UIControlStateNormal];
    [_button_2 setImage:[UIImage imageNamed:@"tabbar_pressed_2"] forState:UIControlStateSelected];
    [_button_2 setFrame:CGRectMake(65, 0, 64, 60)];
    [_button_2 setTag:102];
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setImage:[UIImage imageNamed:@"tabbar_normal_3"] forState:UIControlStateNormal];
    [_button_3 setImage:[UIImage imageNamed:@"tabbar_pressed_3"] forState:UIControlStateSelected];
    [_button_3 setFrame:CGRectMake(202, 0, 64, 60)];
    [_button_3 setTag:103];
    [_button_3 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setImage:[UIImage imageNamed:@"tabbar_normal_4"] forState:UIControlStateNormal];
    [_button_4 setImage:[UIImage imageNamed:@"tabbar_pressed_4"] forState:UIControlStateSelected];
    [_button_4 setFrame:CGRectMake(267, 0, 64, 60)];
    [_button_4 setTag:104];
    [_button_4 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button_1];
    [self addSubview:_button_2];
    [self addSubview:_button_3];
    [self addSubview:_button_4];
    
}

-(void)btn1Click:(id)sender
{
        
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%i",btn.tag);
    switch (btn.tag) {
        case 101:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_normal_1"]];
            [self.delegate touchBtnAtIndex:0];
            
            break;
        }
        case 102:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_normal_2"]];
            [self.delegate touchBtnAtIndex:1];
            break;
        }
        case 103:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_normal_3"]];
            break;
        case 104:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_normal_4"]];
            break;
        default:
            break;
    }
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
