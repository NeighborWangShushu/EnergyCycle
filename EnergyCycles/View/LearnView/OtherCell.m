//
//  OtherCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OtherCell.h"
#import "VideoView.h"
#import "ArticleView.h"
#import "Masonry.h"

@interface OtherCell ()<ArticleViewDelegate,VideoViewDelegate>

@end

@implementation OtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHealths:(NSMutableArray *)healths {
    _healths = healths;
    [self setup];
}

- (void)setup {
    UIView*lastView;
    for (int i = 0; i < self.healths.count; i++) {
        HealthModel * model = self.healths[i];
        switch (model.type) {
            case HealthModelTypeVideo:
            {
                VideoView*view = [[VideoView alloc] initWithItem:model];
                view.delegate = self;
                [self addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.mas_left).with.offset(20);
                    make.right.equalTo(self.mas_right).with.offset(-20);
                    if (lastView) {
                        make.top.equalTo(lastView.mas_bottom).with.offset(16);
                    }else {
                        make.top.equalTo(self.mas_top);
                    }
                    make.height.equalTo(@100);
                    if (i == self.healths.count - 1) {
                        make.bottom.equalTo(self.mas_bottom);
                    }
                }];
                lastView = view;
            }
                break;
            case HealthModelTypeArticle:
            {
                ArticleView*view = [[ArticleView alloc] initWithItem:model];
                view.delegate = self;
                [self addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.mas_left).with.offset(20);
                    make.right.equalTo(self.mas_right).with.offset(-20);
                    if (lastView) {
                        make.top.equalTo(lastView.mas_bottom).with.offset(16);
                    }else {
                        make.top.equalTo(self.mas_top);
                    }
                    make.height.equalTo(@80);
                    if (i == self.healths.count - 1) {
                        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
                    }
                }];
                lastView = view;
            }
                break;
            default:
                break;
        }
        
    }
}

//文章点击回调
- (void)articleView:(UIView *)view didSelectedItem:(HealthModel *)model {
    if ([self.delegate respondsToSelector:@selector(otherCellView:didSelectedItem:)]) {
        [self.delegate otherCellView:self didSelectedItem:model];
    }
}

//视频点击回调
- (void)videoView:(VideoView *)view didSelected:(HealthModel *)model {
    if ([self.delegate respondsToSelector:@selector(otherCellView:didSelectedItem:)]) {
        [self.delegate otherCellView:self didSelectedItem:model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

@end
