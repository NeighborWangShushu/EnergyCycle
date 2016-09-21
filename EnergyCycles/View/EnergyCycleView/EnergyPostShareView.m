//
//  EnergyPostView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "EnergyPostShareView.h"
#import "Masonry.h"

@interface EnergyPostShareView ()

@property (nonatomic,strong)NSMutableArray * shares;

@end

@implementation EnergyPostShareView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
        [self setup];
    }
    return self;
}


- (void)initialize {
    
    self.shares = [NSMutableArray array];
}

- (void)setup {
    UILabel * title = [UILabel new];
    title.text = @"同步分享到";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:14];
    [self addSubview:title];
    
    UIButton * shareButtonOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButtonOne setImage:[UIImage imageNamed:@"post_moments_normal"] forState:UIControlStateNormal];
    [shareButtonOne setImage:[UIImage imageNamed:@"post_moments_selected"] forState:UIControlStateSelected];
    shareButtonOne.tag = 0;
    [shareButtonOne addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButtonOne];
    
    UIButton * shareButtonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButtonTwo setImage:[UIImage imageNamed:@"post_wechat_normal"] forState:UIControlStateNormal];
    [shareButtonTwo setImage:[UIImage imageNamed:@"post_wechat_selected"] forState:UIControlStateSelected];
    shareButtonTwo.tag = 1;
    [shareButtonTwo addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButtonTwo];
    
    UIButton * shareButtonThree = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButtonThree setImage:[UIImage imageNamed:@"post_weibo_normal"] forState:UIControlStateNormal];
    [shareButtonThree setImage:[UIImage imageNamed:@"post_weibo_selected"] forState:UIControlStateSelected];
    shareButtonThree.tag = 2;
    [shareButtonThree addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButtonThree];
    
    UIButton * shareButtonFour = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButtonFour setImage:[UIImage imageNamed:@"post_qq_normal"] forState:UIControlStateNormal];
    [shareButtonFour setImage:[UIImage imageNamed:@"post_qq_selected"] forState:UIControlStateSelected];
    shareButtonFour.tag = 3;
    [shareButtonFour addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButtonFour];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    
    [shareButtonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).with.offset(10);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    
    [shareButtonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareButtonOne.mas_right).with.offset(10);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    
    [shareButtonThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareButtonTwo.mas_right).with.offset(10);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    
    [shareButtonFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareButtonThree.mas_right).with.offset(10);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    
}


- (void)shareAction:(UIButton*)sender {
    
    UIButton*button = (UIButton*)sender;
    [button setSelected:!button.isSelected];
    if(button.isSelected) {
        [self.shares addObject:[NSNumber numberWithInteger:button.tag]];
    }else {
        [self.shares removeObject:[NSNumber numberWithInteger:button.tag]];
    }
    
    NSLog(@"%@",self.shares);
    if ([self.delegate respondsToSelector:@selector(didChooseShareItems:)]) {
        [self.delegate didChooseShareItems:_shares];
    }

}




@end
