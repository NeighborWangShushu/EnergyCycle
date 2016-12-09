//
//  EnergyPostView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "EnergyPostView.h"
#import "Masonry.h"

@implementation EnergyPostView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
        [self setup];
    }
    return self;
}


- (void)initialize {
   
}

- (void)setup {
    
    self.informationTextView = [[CustomTextView alloc] init];
//    self.informationTextView.placehoder = @"说点什么吧... \r正文字数不得少于30字";
    self.informationTextView.placehoder = @"说点什么吧...";
    [self addSubview:self.informationTextView];
    [self.informationTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
}

@end
