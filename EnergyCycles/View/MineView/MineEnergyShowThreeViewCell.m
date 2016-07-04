//
//  EnergyShowThreeViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/30.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineEnergyShowThreeViewCell.h"

#import "NSDate+Category.h"

@implementation MineEnergyShowThreeViewCell

- (void)awakeFromNib {
    self.icon2Button.layer.masksToBounds = YES;
    self.icon2Button.layer.cornerRadius = 20.f;
    
    [self.icon2Button setBackgroundImage:[UIImage imageNamed:@"touxiang.png"] forState:UIControlStateNormal];
    
    self.dingLabel.layer.masksToBounds = YES;
    self.dingLabel.layer.cornerRadius = 2.f;
}

#pragma mark - 填充数据
- (void)updateDataThreeWithModel:(EnergyMainModel *)model {
    if ([model.isTop integerValue] == 1) {
        self.dingLabel.hidden = NO;
    }else {
        self.dingLabel.hidden = YES;
    }
    
    [self.icon2Button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photoUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
    self.nickname2Label.text=model.nickName;
    self.title2Label.text=[model.artTitle stringByRemovingPercentEncoding];
    
//    self.information2Label.text=[model.artContent stringByRemovingPercentEncoding];
    NSString *informationStr = [model.artContent stringByRemovingPercentEncoding];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.information2Label.text = informationStr;
    
    [self.zan2Button setTitle:model.likeNum forState:UIControlStateNormal];
    if ([model.isHasLike integerValue] == 1) {
        [self.zan2Button setImage:[UIImage imageNamed:@"zan_pressed.png"] forState:UIControlStateNormal];
    }else {
        [self.zan2Button setImage:[UIImage imageNamed:@"zan_normal.png"] forState:UIControlStateNormal];
    }
    
    [self.cai2Button setTitle:model.noLikeNum forState:UIControlStateNormal];
    if ([model.isHasNoLike integerValue] == 1) {
        [self.cai2Button setImage:[UIImage imageNamed:@"cai_pressed.png"] forState:UIControlStateNormal];
    }else {
        [self.cai2Button setImage:[UIImage imageNamed:@"cai_normal.png"] forState:UIControlStateNormal];
    }
    
    [self.comment2Button setTitle:model.commentNum forState:UIControlStateNormal];
    
    NSString *dateString = model.createTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [dateFormatter dateFromString:dateString];
    
    NSInteger min = [nowDate minutesBeforeDate:[NSDate date]];
    if (min >= 60) {
        NSInteger hour = [nowDate hoursBeforeDate:[NSDate date]];
        if (hour >= 24) {
            NSArray *timeArr = [model.createTime componentsSeparatedByString:@" "];
            self.time2Label.text = timeArr.firstObject;
        }else {
            self.time2Label.text = [NSString stringWithFormat:@"%ld小时前",(long)hour];
        }
    }else {
        if (min == 0) {
            min = 1;
        }
        self.time2Label.text = [NSString stringWithFormat:@"%ld分钟前",(long)min];
    }
    //设置老学员认证图标
    self.smallIcon2ImageView.image = [UIImage imageNamed:@""];
    if ([model.curuserOldOrderNumber integerValue] == 1 || [model.curuserOldOrderNumber integerValue] == 2 || [model.curuserOldOrderNumber integerValue] == 3) {
        if ([model.oldOrderNumber integerValue] == 1) {
            self.smallIcon2ImageView.image = [UIImage imageNamed:@"jiangpai04.png"];
        }else if ([model.oldOrderNumber integerValue] == 2) {
            self.smallIcon2ImageView.image = [UIImage imageNamed:@"jiangpai02.png"];
        }else if ([model.oldOrderNumber integerValue] == 3) {
            self.smallIcon2ImageView.image = [UIImage imageNamed:@"jiangpai03.png"];
        }
    }
}

- (IBAction)icon2ButtonClick:(UIButton *)sender {
    if (_energyShowThreeButtonClick) {
        _energyShowThreeButtonClick(sender.tag);
    }
}

#pragma mark - 删除
- (IBAction)del2ButtonClick:(UIButton *)sender {
    if (_mineThrEnergyDelButtonClick) {
        _mineThrEnergyDelButtonClick(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
