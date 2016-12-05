//
//  TheAdvOneViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TheAdvOneViewCell.h"

#import "NSDate+Category.h"

@implementation TheAdvOneViewCell

- (void)awakeFromNib {
    self.iconButton.layer.masksToBounds = YES;
    self.iconButton.layer.cornerRadius = 20.f;
}

#pragma mark - 填充数据
- (void)updateDataOneWithModel:(TheAdvMainModel *)model {
    if (model==nil) {
        return;
    }
    
    [self.iconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photoUrl]] forState:UIControlStateNormal placeholderImage:[[UIImage imageNamed:@"touxiang.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.nicknameLabel.text=model.nickName;
    self.titleLabel.text=[model.title stringByRemovingPercentEncoding];
    
//    self.informationLabel.text=[model.content stringByRemovingPercentEncoding];
    NSString *informationStr = [model.content stringByRemovingPercentEncoding];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.informationLabel.text = informationStr;
    
    [self.zanButton setTitle:[NSString stringWithFormat:@"%@总票",model.hits] forState:UIControlStateNormal];
    [self.caiButton setTitle:[NSString stringWithFormat:@"%@新增",model.daysHits] forState:UIControlStateNormal];
    [self.commentButton setTitle:model.commNum forState:UIControlStateNormal];
    [self.classButton setTitle:model.postType forState:UIControlStateNormal];
    self.classButton.layer.masksToBounds=YES;
    self.classButton.layer.cornerRadius=2.5f;
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (model.postPic.count>3) {
        for (NSInteger i=0; i<3; i++) {
            UIImageView * image=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*(Screen_width-20)/3, 120,(Screen_width-20)/3-5, 112)];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.layer.masksToBounds = YES;
            [image sd_setImageWithURL:[NSURL URLWithString:model.postPic[i]] placeholderImage:[UIImage imageNamed:@""]];
            [self.contentView addSubview:image];
        }
    }else{
        for (NSInteger i=0; i<model.postPic.count ; i++) {
            UIImageView * image=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*(Screen_width-20)/3, 120,(Screen_width-20)/3-5, 112)];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.layer.masksToBounds = YES;
            [image sd_setImageWithURL:[NSURL URLWithString:model.postPic[i]] placeholderImage:[UIImage imageNamed:@""]];
            [self.contentView addSubview:image];
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

#pragma mark - 头像点击事件
- (IBAction)iconButtonClick:(UIButton *)sender {
    if (_advPKOneShowButtonClick) {
        _advPKOneShowButtonClick(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
