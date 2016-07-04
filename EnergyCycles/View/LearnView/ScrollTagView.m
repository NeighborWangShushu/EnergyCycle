//
//  ScrollTagView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ScrollTagView.h"
#import "TagItemView.h"
#import "Masonry.h"

@interface ScrollTagView ()
{
    NSInteger currentIndex;
    NSInteger count;
    NSMutableArray * items;
}
@property CGFloat top,bottom,gap,textSize;

@property (nonatomic,strong)UIColor * textColor;
@property (nonatomic,strong)NSMutableArray * source;
@property (nonatomic,strong)UIView * line;
@property (nonatomic,strong)UIView * contentView;

@end

@implementation ScrollTagView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.source = [NSMutableArray new];
    items = [NSMutableArray new];
    self.top = 10.0;
    self.bottom = 10.0;
    self.gap = 20.0;
    self.textSize = 14.0;
    currentIndex = 0;
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)layoutSubviews {
    

}

- (void)drawRect:(CGRect)rect {
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if ([self.vdataSrouce respondsToSelector:@selector(numberOfScrollTagView:)]) {
        count = [self.vdataSrouce numberOfScrollTagView:self];
    }
    [self setup];
}

- (void)setup {
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        
    }];
    
    [self loadRequiredItems];
}

- (void)loadRequiredItems {
    TagItemView * lv = nil;
    
    //所有item的容器，方便适配位置，所以把item放在一个view里
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(self.contentView.mas_width);
    }];
    
    for (int i = 0; i < count; i++) {
        TagItemView * iv = [TagItemView new];
        iv.title = @"123123";
        [backView addSubview:iv];
        
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lv) {make.left.equalTo(lv.mas_right).with.offset(0);}
            else {make.left.equalTo(backView.mas_left);};
            make.top.equalTo(backView.mas_top);
            make.bottom.equalTo(backView.mas_bottom);
            if (i == count - 1) {
                make.right.equalTo(backView.mas_right);
            }
        }];
        [items addObject:iv];
        lv = iv;
    }
    
    
    self.line = [UIView new];
    self.line.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        TagItemView * selectedItem = (TagItemView*)items[currentIndex];
        make.centerX.equalTo(selectedItem.mas_centerX);
        make.top.equalTo(selectedItem.mas_bottom).with.offset(-5);
        make.width.equalTo(selectedItem.mas_width);
        make.height.equalTo(@2);
        
    }];
}


- (void)reloadData {
    
}

@end
