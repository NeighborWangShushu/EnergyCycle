//
//  ECSiftCollectionCell.m
//  EnergyCycles
//
//  Created by vj on 2016/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECSiftCollectionCell.h"
#import "Masonry.h"

@interface ECSiftCollectionCell ()

@property (nonatomic,strong)UIImageView * contentImg;

@property (nonatomic,strong)UILabel * title;

@property (nonatomic,strong)UILabel * time;

@property (nonatomic,strong)UIImageView * msg;

@property (nonatomic,strong)UILabel * msgLabel;

@property (nonatomic,strong)UIImageView * like;

@property (nonatomic,strong)UILabel * likeLabel;

@end

@implementation ECSiftCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)setModel:(ECTimeLineModel *)model {
    
    _model = model;
    //大图
    NSString * image = [model.picNamesArray firstObject];
    [self.contentImg sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:EC_AVATAR_PLACEHOLDER];
    
    //内容
    self.title.text = model.msgContent;
    
    //时间
    self.time.text = model.time;
    
    self.msg.image = [UIImage imageNamed:@"ec_sift_comment"];
    self.like.image = [UIImage imageNamed:@"ec_sift_like"];
    
    self.msgLabel.text = [NSString stringWithFormat:@"%ld",model.commentItemsArray.count];
    
    self.likeLabel.text = [NSString stringWithFormat:@"%ld",model.likeItemsArray.count];
}


- (void)initUI {
    
    self.contentImg = [UIImageView new];
    self.contentImg.layer.masksToBounds = YES;
    [self.contentImg setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:self.contentImg];
    
    self.title = [UILabel new];
    [self.title setFont:[UIFont systemFontOfSize:12]];
    [self.title setTextColor:[UIColor blackColor]];
    self.title.numberOfLines = 2;
    [self addSubview:self.title];
    
    self.time = [UILabel new];
    [self.time setFont:[UIFont systemFontOfSize:12]];
    [self.time setTextColor:[UIColor lightGrayColor]];
    [self addSubview:self.time];
    
    self.msg = [UIImageView new];
    [self addSubview:self.msg];
    
    self.msgLabel = [UILabel new];
    [self.msgLabel setFont:[UIFont systemFontOfSize:12]];
    [self.msgLabel setTextColor:[UIColor lightGrayColor]];
    [self addSubview:self.msgLabel];
    
    self.like = [UIImageView new];
    [self addSubview:self.like];
    
    self.likeLabel = [UILabel new];
    [self.likeLabel setFont:[UIFont systemFontOfSize:12]];
    [self.likeLabel setTextColor:[UIColor lightGrayColor]];
    [self addSubview:self.likeLabel];
    
    [self.contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@(Screen_width/2 - 10));
        
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.top.equalTo(self.contentImg.mas_bottom).with.offset(5);
        make.height.equalTo(@40);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.title.mas_bottom).with.offset(10);
        
    }];
    
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.title.mas_bottom).with.offset(10);
        make.left.equalTo(self.like.mas_right).with.offset(10);
        
    }];
    
    [self.like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likeLabel.mas_left).with.offset(-8);
        make.width.equalTo(@14);
        make.height.equalTo(@12);
        make.centerY.equalTo(self.likeLabel.mas_centerY);
    }];
    
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.like.mas_left).with.offset(-5);
        make.centerY.equalTo(self.like.mas_centerY);
        
    }];
    
    [self.msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.msgLabel.mas_centerY);
        make.right.equalTo(self.msgLabel.mas_left).with.offset(-10);
        make.width.equalTo(@14);
        make.height.equalTo(@12);
    }];
    
}



@end
