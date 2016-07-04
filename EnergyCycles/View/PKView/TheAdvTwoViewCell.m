//
//  TheAdvTwoViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TheAdvTwoViewCell.h"

#import "NSDate+Category.h"

@implementation TheAdvTwoViewCell

- (void)awakeFromNib {
    self.icon1Button.layer.masksToBounds = YES;
    self.icon1Button.layer.cornerRadius = 20.f;
}

#pragma mark - 填充数据
- (void)updateDataTwoWithModel:(TheAdvMainModel *)model {
    if (model==nil) {
        return;
    }
    [self.icon1Button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photoUrl]] forState:UIControlStateNormal placeholderImage:[[UIImage imageNamed:@"touxiang.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.nickname1Label.text=model.nickName;
    self.title1Label.text=[model.title stringByRemovingPercentEncoding];
    
//    self.information1Label.text=[model.content stringByRemovingPercentEncoding];
    NSString *informationStr = [model.content stringByRemovingPercentEncoding];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.information1Label.text = informationStr;
    
    [self.zan1Button setTitle:[NSString stringWithFormat:@"%@总票",model.hits] forState:UIControlStateNormal];
    [self.cai1Button setTitle:[NSString stringWithFormat:@"%@新增",model.daysHits] forState:UIControlStateNormal];
    [self.comment1Button setTitle:model.commNum forState:UIControlStateNormal];
    [self.class1Button setTitle:model.postType forState:UIControlStateNormal];
    self.class1Button.layer.masksToBounds=YES;
    self.class1Button.layer.cornerRadius=2.5f;
    
    //视频
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.videoFirstImg] placeholderImage:[UIImage imageNamed:@"placepic.png"]];
    self.videoTitle.text = [model.title stringByRemovingPercentEncoding];
    self.videoContext.text = model.videoTitle;
    self.videoFrom.text = model.videoUrl;
    
    for (UIView *view in self.videoImageView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, self.videoImageView.frame.size.width, self.videoImageView.frame.size.height);
    [button setImage:[[UIImage imageNamed:@"video.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    button.userInteractionEnabled = NO;
    [self.videoImageView addSubview:button];
    
    
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

#pragma mark - 头像点击事件
- (IBAction)icon1ButtonClick:(UIButton *)sender {
    if (_advPKTwoShowButtonClick) {
        _advPKTwoShowButtonClick(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
