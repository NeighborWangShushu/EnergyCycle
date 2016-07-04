//
//  TheAdvThrViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "MineTheAdvThrViewCell.h"

#import "NSDate+Category.h"

@implementation MineTheAdvThrViewCell

- (void)awakeFromNib {
    self.icon2Button.layer.masksToBounds = YES;
    self.icon2Button.layer.cornerRadius = 20.f;
    
    [self.icon2Button setBackgroundImage:[UIImage imageNamed:@"touxiang.png"] forState:UIControlStateNormal];
}

#pragma mark - 填充数据
- (void)updateDataThrWithModel:(TheAdvMainModel *)model {
    if (model==nil) {
        return;
    }
    [self.icon2Button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photoUrl]] forState:UIControlStateNormal placeholderImage:[[UIImage imageNamed:@"touxiang.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.nickname2Label.text=model.nickName;
    self.title2Label.text=[model.title stringByRemovingPercentEncoding];
    
//    self.information2Label.text=[model.content stringByRemovingPercentEncoding];
    NSString *informationStr = [model.content stringByRemovingPercentEncoding];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.information2Label.text = informationStr;
    
    [self.zan2Button setTitle:[NSString stringWithFormat:@"%@总票",model.hits] forState:UIControlStateNormal];
    [self.cai2Button setTitle:[NSString stringWithFormat:@"%@新增",model.daysHits] forState:UIControlStateNormal];
    [self.comment2Button setTitle:model.commNum forState:UIControlStateNormal];
    [self.class2Button setTitle:model.postType forState:UIControlStateNormal];
    self.class2Button.layer.masksToBounds=YES;
    self.class2Button.layer.cornerRadius=2.5f;
    
    
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

#pragma mark - 头像点击事件
- (IBAction)icon2ButtonClick:(UIButton *)sender {
    if (_advPKThrShowButtonClick) {
        _advPKThrShowButtonClick(sender.tag);
    }
}

#pragma mark - 删除
- (IBAction)delButtonClick:(UIButton *)sender {
    if (_mineTwoAdvDelButtonClick) {
        _mineTwoAdvDelButtonClick(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
