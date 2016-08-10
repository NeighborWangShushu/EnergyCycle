//
//  BottomView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SDTimeLineCellBottomView.h"
#import "UIView+SDAutoLayout.h"

@interface SDTimeLineCellBottomView () {
    SDAdditionalActionView * zanView;
}

@end


@implementation SDTimeLineCellBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
        //设置主题
       
    }
    return self;
}

- (void)callBack:(NSInteger)type {
    if (self.SDTimeLineCellBottomSelectedBlock) {
        self.SDTimeLineCellBottomSelectedBlock(type);
    }
    
}

- (void)setModel:(ECTimeLineModel *)model {
    _model = model;
    zanView.model = model;
}

- (void)setup {
    
    __weak typeof(self) weakself = self;
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.7];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];
    
    
    SDAdditionalActionView * shareView = [SDAdditionalActionView new];
    shareView.type = SDAdditionalActionViewTypeShare;
    shareView.selctedAddition  = ^(SDAdditionalActionViewType type) {
        [weakself callBack:0];
    };
    
    SDAdditionalActionView * commentView = [SDAdditionalActionView new];
    commentView.type = SDAdditionalActionViewTypeComment;
    commentView.selctedAddition = ^(SDAdditionalActionViewType type) {
        [weakself callBack:1];
    };
    
    zanView = [SDAdditionalActionView new];
    zanView.type = SDAdditionalActionViewTypeLike;
    zanView.model = self.model;
    zanView.selctedAddition = ^(SDAdditionalActionViewType type) {
        [weakself callBack:2];
    };
    
    [self sd_addSubviews:@[line,shareView,commentView,zanView,line2]];
    
    line.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(1);
    
    shareView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(Screen_width/3 - 2);
    
    commentView.sd_layout
    .leftSpaceToView(shareView,1)
    .topEqualToView(shareView)
    .bottomEqualToView(shareView)
    .widthIs(Screen_width/3 - 2);
    
    zanView.sd_layout
    .leftSpaceToView(commentView,1)
    .topEqualToView(commentView)
    .bottomEqualToView(commentView)
    .rightEqualToView(self);

    line2.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(1);
}

@end

@interface SDAdditionalActionView () {
    UIImage*icon;
    UIButton * button;
}

@end


@implementation SDAdditionalActionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setType:(SDAdditionalActionViewType)type {
    _type = type;
    [self setup];
}

- (void)setModel:(ECTimeLineModel *)model {
    _model = model;
    icon = model.liked?[UIImage imageNamed:@"ec_like_selected"]:[UIImage imageNamed:@"ec_like"];
    [button setImage:icon forState:UIControlStateNormal];
}

- (void)setup {
    UIImage *highlight = nil;
    NSString * title;
    
    
    switch (self.type) {
        case SDAdditionalActionViewTypeLike: {
            icon = self.model.isLiked?[UIImage imageNamed:@"ec_like_selected"]:[UIImage imageNamed:@"ec_like_normal"];
            title = @"赞";
        }
           
            break;
        case SDAdditionalActionViewTypeShare:
            icon = [UIImage imageNamed:@"ec_share"];
            title = @"分享";
            break;
        case SDAdditionalActionViewTypeComment:
            icon = [UIImage imageNamed:@"ec_msg_normal"];
            title = @"评论";
            break;
            
        default:
            break;
    }
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:icon forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button addTarget:self action:@selector(addtionAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self sd_addSubviews:@[button]];
    
    button.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
}



- (void)addtionAction:(id)sender {
    
    if(self.selctedAddition) {
        self.selctedAddition(self.type);
    }
    
}

@end