//
//  VideoView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VideoView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation VideoView

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
    UIImageView * bg = [UIImageView new];
    [bg sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:nil];
    bg.userInteractionEnabled = NO;
    [self addSubview:bg];
    
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@100);
    }];
    
    UILabel * title = [UILabel new];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:16.0];
    title.numberOfLines = 1;
    title.text = self.model.title;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(20);
    }];
    
    UILabel * course = [UILabel new];
    course.textColor = [UIColor whiteColor];
    course.text = [NSString stringWithFormat:@"%@%@",self.model.course,self.model.time];
    course.numberOfLines = 1;
    title.font = [UIFont boldSystemFontOfSize:14.0];
    [self addSubview:course];
    [course mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
    }];
    
//    UILabel * msg_count = [UILabel new];
//    msg_count.font = [UIFont systemFontOfSize:10.0];
//    msg_count.textColor = [UIColor whiteColor];
//    msg_count.text = [NSString stringWithFormat:@"%ld",self.model.message];
//    msg_count.numberOfLines = 1;
//    [self addSubview:msg_count];
//    [msg_count mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).with.offset(-10);
//        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
//    }];
    
//    UIImageView * msg_img = [UIImageView new];
//    msg_img.image = [UIImage imageNamed:@"msg"];
//    [self addSubview:msg_img];
//    [msg_img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(msg_count.mas_left).with.offset(-5);
//        make.centerY.equalTo(msg_count.mas_centerY);
//        make.width.equalTo(@9);
//        make.height.equalTo(@9);
//    }];
//    
//    UILabel * like_count = [UILabel new];
//    like_count.font = [UIFont systemFontOfSize:10.0];
//    like_count.textColor = [UIColor whiteColor];
//    like_count.text = [NSString stringWithFormat:@"%ld",self.model.like];
//    like_count.numberOfLines = 1;
//    [self addSubview:like_count];
//    [like_count mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(msg_img.mas_left).with.offset(-20);
//        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
//        make.centerY.equalTo(msg_img.mas_centerY);
//    }];
//    
//    UIImageView * like_img = [UIImageView new];
//    like_img.image = [UIImage imageNamed:@"like"];
//    [self addSubview:like_img];
//    [like_img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(like_count.mas_left).with.offset(-5);
//        make.centerY.equalTo(like_count.mas_centerY);
//        make.width.equalTo(@9);
//        make.height.equalTo(@9);
//    }];
    
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
    if ([self.delegate respondsToSelector:@selector(videoView:didSelected:)]) {
        [self.delegate videoView:self didSelected:self.model];
    }
}



@end
