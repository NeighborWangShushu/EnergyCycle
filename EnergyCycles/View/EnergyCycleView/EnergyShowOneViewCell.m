//
//  EnergyShowOneViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "EnergyShowOneViewCell.h"

#import "NSDate+Category.h"

@implementation EnergyShowOneViewCell

- (void)awakeFromNib {
    self.iconButton.layer.masksToBounds = YES;
    self.iconButton.layer.cornerRadius = 20.f;
    
    [self.iconButton setBackgroundImage:[UIImage imageNamed:@"touxiang.png"] forState:UIControlStateNormal];
    
    self.dingLabel.layer.masksToBounds = YES;
    self.dingLabel.layer.cornerRadius = 2.f;
}

#pragma mark - 填充数据
- (void)updateDataOneWithModel:(EnergyMainModel *)model {
    if ([model.isTop integerValue] == 1) {
        self.dingLabel.hidden = NO;
    }else {
        self.dingLabel.hidden = YES;
    }
    
    [self.iconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photoUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
    self.nicknameLabel.text=model.nickName;
    self.titleLabel.text=[model.artTitle stringByRemovingPercentEncoding];
    
//    self.informationLabel.text=[model.artContent stringByRemovingPercentEncoding];
    NSString *informationStr = [model.artContent stringByRemovingPercentEncoding];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.informationLabel.text = informationStr;
    
    [self.zanButton setTitle:model.likeNum forState:UIControlStateNormal];
    if ([model.isHasLike integerValue] == 1) {
        [self.zanButton setImage:[UIImage imageNamed:@"zan_pressed.png"] forState:UIControlStateNormal];
    }else {
        [self.zanButton setImage:[UIImage imageNamed:@"zan_normal.png"] forState:UIControlStateNormal];
    }
    
    [self.caiButton setTitle:model.noLikeNum forState:UIControlStateNormal];
    if ([model.isHasNoLike integerValue] == 1) {
        [self.caiButton setImage:[UIImage imageNamed:@"cai_pressed.png"] forState:UIControlStateNormal];
    }else {
        [self.caiButton setImage:[UIImage imageNamed:@"cai_normal.png"] forState:UIControlStateNormal];
    }
    
    [self.commentButton setTitle:model.commentNum forState:UIControlStateNormal];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
        
    if (model.artPic.count) {
        if (model.artPic.count >= 3 ) {
            for (NSInteger i=0; i<3; i++) {
                UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*(Screen_width-20)/3, 140,(Screen_width-20)/3-5, 112)];
                image.contentMode = UIViewContentModeScaleAspectFill;
                image.layer.masksToBounds = YES;
                [image sd_setImageWithURL:[NSURL URLWithString:model.artPic[i]] placeholderImage:[UIImage imageNamed:@"placepic.png"]];
                [self addSubview:image];
            }
        }else {
            for (NSInteger i=0; i<model.artPic.count; i++) {
                UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*(Screen_width-20)/3, 140,(Screen_width-20)/3-5, 112)];
                image.contentMode = UIViewContentModeScaleAspectFill;
                image.layer.masksToBounds = YES;
                [image sd_setImageWithURL:[NSURL URLWithString:model.artPic[i]] placeholderImage:[UIImage imageNamed:@"placepic.png"]];
                [self addSubview:image];
            }
        }
    }
    
    NSString *dateString = model.createTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [dateFormatter dateFromString:dateString];
    
    NSInteger min = [nowDate minutesBeforeDate:[NSDate date]];
    if (min >= 60) {
        NSInteger hour = [nowDate hoursBeforeDate:[NSDate date]];
        if (hour >= 24) {
            NSArray *timeArr = [model.createTime componentsSeparatedByString:@" "];
            self.timeLabel.text = timeArr.firstObject;
        }else {
            self.timeLabel.text = [NSString stringWithFormat:@"%ld小时前",(long)hour];
        }
    }else {
        if (min == 0) {
            min = 1;
        }
        self.timeLabel.text = [NSString stringWithFormat:@"%ld分钟前",(long)min];
    }
    
    //设置老学员认证图标
    self.smallIconImageView.image = [UIImage imageNamed:@""];
    if ([model.curuserOldOrderNumber integerValue] == 1 || [model.curuserOldOrderNumber integerValue] == 2 || [model.curuserOldOrderNumber integerValue] == 3) {
        if ([model.oldOrderNumber integerValue] == 1) {
            self.smallIconImageView.image = [UIImage imageNamed:@"jiangpai04.png"];
        }else if ([model.oldOrderNumber integerValue] == 2) {
            self.smallIconImageView.image = [UIImage imageNamed:@"jiangpai02.png"];
        }else if ([model.oldOrderNumber integerValue] == 3) {
            self.smallIconImageView.image = [UIImage imageNamed:@"jiangpai03.png"];
        }
    }
}

- (IBAction)iconButtonClick:(UIButton *)sender {
    if (_energyShowButtonClick) {
        _energyShowButtonClick(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
