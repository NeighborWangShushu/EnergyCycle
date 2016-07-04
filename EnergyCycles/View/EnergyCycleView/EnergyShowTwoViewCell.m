//
//  EnergyShowTwoViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "EnergyShowTwoViewCell.h"

#import "EnergyMainModel.h"

#import "NSDate+Category.h"

@implementation EnergyShowTwoViewCell

- (void)awakeFromNib {
    self.icon1Button.layer.masksToBounds = YES;
    self.icon1Button.layer.cornerRadius = 20.f;
    
    [self.icon1Button setBackgroundImage:[UIImage imageNamed:@"touxiang.png"] forState:UIControlStateNormal];
    
    self.dingLabel.layer.masksToBounds = YES;
    self.dingLabel.layer.cornerRadius = 2.f;
}

#pragma mark - 填充数据
- (void)updateDataTwoWithModel:(EnergyMainModel *)model {
    if ([model.isTop integerValue] == 1) {
        self.dingLabel.hidden = NO;
    }else {
        self.dingLabel.hidden = YES;
    }
    
    [self.icon1Button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photoUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
    self.nickname1Label.text=model.nickName;
    self.title1Label.text=[model.artTitle stringByRemovingPercentEncoding];
    
//    self.information1Label.text=[model.artContent stringByRemovingPercentEncoding];
    NSString *informationStr = [model.artContent stringByRemovingPercentEncoding];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.information1Label.text = informationStr;
    
    [self.zan1Button setTitle:model.likeNum forState:UIControlStateNormal];
    if ([model.isHasLike integerValue] == 1) {
        [self.zan1Button setImage:[UIImage imageNamed:@"zan_pressed.png"] forState:UIControlStateNormal];
    }else {
        [self.zan1Button setImage:[UIImage imageNamed:@"zan_normal.png"] forState:UIControlStateNormal];
    }
    
    [self.cai1Button setTitle:model.noLikeNum forState:UIControlStateNormal];
    if ([model.isHasNoLike integerValue] == 1) {
        [self.cai1Button setImage:[UIImage imageNamed:@"cai_pressed.png"] forState:UIControlStateNormal];
    }else {
        [self.cai1Button setImage:[UIImage imageNamed:@"cai_normal.png"] forState:UIControlStateNormal];
    }
    
    [self.comment1Button setTitle:model.commentNum forState:UIControlStateNormal];
    
    //视频
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:model.videoFirstImg] placeholderImage:[UIImage imageNamed:@"placepic.png"]];
    self.videoTitle.text = [model.artTitle stringByRemovingPercentEncoding];
    self.videoContent.text = model.videoTitle;
    self.videoFrom.text = model.videoUrl;
    
    for (UIView *view in self.videoImage.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, self.videoImage.frame.size.width, self.videoImage.frame.size.height);
    [button setImage:[[UIImage imageNamed:@"video.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    button.userInteractionEnabled = NO;
    [self.videoImage addSubview:button];
    
    
    NSString *dateString = model.createTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [dateFormatter dateFromString:dateString];
    
    NSInteger min = [nowDate minutesBeforeDate:[NSDate date]];
    if (min >= 60) {
        NSInteger hour = [nowDate hoursBeforeDate:[NSDate date]];
        if (hour >= 24) {
            NSArray *timeArr = [model.createTime componentsSeparatedByString:@" "];
            self.time1Label.text = timeArr.firstObject;
        }else {
            self.time1Label.text = [NSString stringWithFormat:@"%ld小时前",(long)hour];
        }
    }else {
        if (min == 0) {
            min = 1;
        }
        self.time1Label.text = [NSString stringWithFormat:@"%ld分钟前",(long)min];
    }
    
    //设置老学员认证图标
    self.smallIcon1ImageView.image = [UIImage imageNamed:@""];
    if ([model.curuserOldOrderNumber integerValue] == 1 || [model.curuserOldOrderNumber integerValue] == 2 || [model.curuserOldOrderNumber integerValue] == 3) {
        if ([model.oldOrderNumber integerValue] == 1) {
            self.smallIcon1ImageView.image = [UIImage imageNamed:@"jiangpai04.png"];
        }else if ([model.oldOrderNumber integerValue] == 2) {
            self.smallIcon1ImageView.image = [UIImage imageNamed:@"jiangpai02.png"];
        }else if ([model.oldOrderNumber integerValue] == 3) {
            self.smallIcon1ImageView.image = [UIImage imageNamed:@"jiangpai03.png"];
        }
    }
}

- (IBAction)icon1ButtonClick:(UIButton *)sender {
    if (_energyShowTwoButtonClick) {
        _energyShowTwoButtonClick(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
