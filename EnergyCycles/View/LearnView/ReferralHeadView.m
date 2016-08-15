//
//  RadioHeadView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ReferralHeadView.h"
#import "Masonry.h"

@interface ReferralHeadView ()
{
    
    
}

@end

@implementation ReferralHeadView


- (id)initWithName:(NSString*)name {
    self = [super init];
    if (self) {
        _name = name;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setType:(ReferralHeadViewType)type {
    _type = type;
    [self setup];
}

- (void)setup {
    if (self.type == ReferralHeadViewTypeNone) {
        return;
    }
    
    UIImageView*img = [UIImageView new];
    [img setImage:[UIImage imageNamed:@"learn_head_icon"]];
    [self addSubview:img];
    
    UILabel * title = [UILabel new];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:15];
    title.text = _name;
    [self addSubview:title];
    
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(20);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
        
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(20);
        make.top.equalTo(self.mas_top).with.offset(16);
        make.bottom.equalTo(self.mas_bottom).with.offset(-16);
    }];
    
    if (self.type == ReferralHeadViewTypeCCTalk) {
        UIImageView*arrow = [UIImageView new];
        [arrow setImage:[UIImage imageNamed:@"referral_cctalk_radio"]];
        [self addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-20);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UIButton * go = [UIButton buttonWithType:UIButtonTypeCustom];
        [go setTitle:@"进入CCTALK" forState:UIControlStateNormal];
        [go setTitle:@"进入CCTALK" forState:UIControlStateSelected];
        [go setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [go.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [self addSubview:go];
        [go addTarget:self action:@selector(goCCTalk) forControlEvents:UIControlEventTouchUpInside];
        [go mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrow.mas_left).with.offset(-10);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    
    if (self.type == ReferralHeadViewTypeOther) {
        UIButton * more = [UIButton buttonWithType:UIButtonTypeCustom];
        [more setTitle:@"更多" forState:UIControlStateNormal];
        [more setTitle:@"更多" forState:UIControlStateHighlighted];
        [more.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [more setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [more setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self addSubview:more];
        [more addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
        [more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    
}


- (void)more:(id)sender {
    if ([self.delegate respondsToSelector:@selector(headView:showMore:)]) {
        [self.delegate headView:self showMore:self.name];
    }
}


- (void)goCCTalk {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GOTOCCTALK" object:nil userInfo:@{@"url":@"http://www.cctalk.com/org/525/?from=singlemessage&isappinstalled=0"}];
}


@end

