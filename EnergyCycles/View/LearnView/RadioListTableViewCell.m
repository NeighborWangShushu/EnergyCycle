//
//  RadioListTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RadioListTableViewCell.h"
#import "AFSoundManager.h"
#import "ECAudioPlayAnimation.h"

@interface RadioListTableViewCell ()

@property (nonatomic, strong) ECAudioPlayAnimation *animation;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSURL *cellUrl;
@property (nonatomic, assign) BOOL isPlay;

@end

@implementation RadioListTableViewCell

- (void)getDataWithModel:(RadioModel *)model {
    
    self.cellUrl = [NSURL URLWithString:model.RadioUrl];
    self.ID = model.ID;
    if ([AFSoundManager sharedManager].player.status == AVPlayerStatusReadyToPlay) {
        NSLog(@"111");
        if ([self.cellUrl isEqual:self.radioUrl]) {
            NSLog(@"222%@", model.Name);
            [self setAnimation];
        }
    } else {
        self.isPlay = NO;
    }
    
    // 电台图片
    [self.radioImage sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl]];
    self.radioImage.layer.cornerRadius = 5;
    self.radioImage.layer.masksToBounds = YES;
    
    // 电台名字
    self.radioName.text = model.Name;
    
    // 电台简介
    if (model.Intro == nil || [model.Intro isEqualToString:@""]) {
        self.radioIntro.text = @"暂无";
    } else {
        self.radioIntro.text = model.Intro;
    }
    
    [self lineView];
    
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 12, self.frame.size.height - 1, self.frame.size.width + 50, 1);
    line.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.contentView addSubview:line];
}

- (void)setAnimation {
    self.isPlay = YES;
    self.animation = [[ECAudioPlayAnimation alloc] initWithFrame:CGRectMake(0, 30, 50, 20)];
    self.animation.numberOfRect = 6;
    self.animation.rectColor = [UIColor whiteColor];
    self.animation.space = 1;
    self.animation.rectSize = CGSizeMake(50, 20);
    self.animation.rectWidth = 8;
    self.RadioPlayAnimation.clipsToBounds = YES;
    [self.RadioPlayAnimation addSubview:self.animation];
    [self.animation startAnimation];
}

- (void)stopAnimation {
    self.isPlay = NO;
    [self.animation stopAnimation];
}

- (void)stopRadioPlayer:(NSNotification *)notification {
    NSURL *stopUrl = [[notification userInfo] objectForKey:@"radioUrl"];
    if ([stopUrl isEqual:self.cellUrl]) {
        [self stopAnimation]; // 停止
    }
}

- (void)play {
    if (!self.isPlay) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RadioCollectionCellPlay" object:nil userInfo:@{@"url" : [NSString stringWithFormat:@"%@", self.cellUrl], @"index" : self.ID}];
        [self setAnimation];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RadioCollectionCellStop" object:nil userInfo:@{@"url" : [NSString stringWithFormat:@"%@", self.cellUrl], @"index" : self.ID}];
        [self stopAnimation];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRadioPlayer:) name:@"stopRadioPlayer" object:nil];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
