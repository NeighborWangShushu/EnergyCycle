//
//  ArticleView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ArticleView.h"
#import "Masonry.h"

@implementation ArticleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithItem:(HealthModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self setup];
}

- (void)setup {
    UIImageView * icon = [UIImageView new];
    [icon sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:nil];
    [self addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@100);
        make.height.equalTo(@67);
    }];
    
    UILabel * title = [UILabel new];
    title.text = self.model.title;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:12];
    title.numberOfLines = 0;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).with.offset(5);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    
    UIView * typeBg = [UIView new];
    typeBg.backgroundColor = [UIColor colorWithRed:86.0/255.0 green:172.0/255.0 blue:238.0/255.0 alpha:1.0];
    typeBg.layer.masksToBounds = YES;
    typeBg.layer.cornerRadius = 4.0;
    [self addSubview:typeBg];
    [typeBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).with.offset(5);
        make.bottom.equalTo(icon.mas_bottom);
        make.height.equalTo(@20);
    }];
    
    UILabel * type = [UILabel new];
    type.textColor = [UIColor whiteColor];
    type.font = [UIFont systemFontOfSize:12];
    type.numberOfLines = 1;
    type.text = self.model.typeName;
    [typeBg addSubview:type];
    [type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(typeBg.mas_right).with.offset(-5);
        make.left.equalTo(typeBg.mas_left).with.offset(5);
        make.top.equalTo(typeBg.mas_top);
        make.bottom.equalTo(typeBg.mas_bottom);
    }];
    
    UILabel * time = [UILabel new];
    time.textColor = [UIColor lightGrayColor];
    time.font = [UIFont systemFontOfSize:12];
    time.text = self.model.time;
    [self addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeBg.mas_right).with.offset(9);
        make.centerY.equalTo(typeBg.mas_centerY);
        make.width.equalTo(@60);
    }];
    
    UILabel * see_count = [UILabel new];
    see_count.textColor = [UIColor lightGrayColor];
    see_count.text = self.model.read_count;
    see_count.numberOfLines = 1;
    see_count.font = [UIFont systemFontOfSize:12];
    [self addSubview:see_count];
    [see_count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(typeBg.mas_centerY);
    }];
    
    UIImageView * read_icon = [UIImageView new];
    [read_icon setImage:[UIImage imageNamed:@"read_icon"]];
    [self addSubview:read_icon];
    [read_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(see_count.mas_left).with.offset(-7);
        make.centerY.equalTo(see_count.mas_centerY);
        make.width.equalTo(@17);
        make.height.equalTo(@11);
    }];
    
    UIView*bottomLine = [UIView new];
    [bottomLine setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:0.8]];
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@5);
        make.height.equalTo(@1);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)buttonAction {
    if ([self.delegate respondsToSelector:@selector(articleView:didSelectedItem:)]) {
        [self.delegate articleView:self didSelectedItem:self.model];
    }
}

@end
