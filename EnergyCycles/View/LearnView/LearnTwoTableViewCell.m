//
//  LearnTwoTableViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LearnTwoTableViewCell.h"

@implementation LearnTwoTableViewCell

- (void)awakeFromNib {
    self.headLearnButton.layer.masksToBounds = YES;
    self.headLearnButton.layer.cornerRadius = 20.f;
    
    [self.headLearnButton setBackgroundImage:[UIImage imageNamed:@"touxiang.png"] forState:UIControlStateNormal];
    
    self.leftLearnButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}

#pragma mark - 填充数据
- (void)updateEveryDayPKDataWithIndex:(NSInteger)index withModel:(UserModel *)model {
    [self.leftLearnButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.leftLearnButton setTitle:@"" forState:UIControlStateNormal];
    
    self.leftLearnImageView.image = [UIImage imageNamed:@""];
    if (index == 0) {
        self.leftLearnImageView.image = [UIImage imageNamed:@"NO1_.png"];
    }else if (index == 1) {
        self.leftLearnImageView.image = [UIImage imageNamed:@"NO2_.png"];
    }else if (index == 2) {
        self.leftLearnImageView.image = [UIImage imageNamed:@"NO3_.png"];
    }else {
        [self.leftLearnButton setBackgroundImage:[UIImage imageNamed:@"hring.png"] forState:UIControlStateNormal];
        [self.leftLearnButton setTitle:[NSString stringWithFormat:@"%ld",(long)index+1] forState:UIControlStateNormal];
    }
    
    self.rightButton.tag = 3401+index;
    if ([model.flag integerValue] == 0) {
        [self.rightButton setImage:[UIImage imageNamed:@"hxin.png"] forState:UIControlStateNormal];
    }else {
        [self.rightButton setImage:[UIImage imageNamed:@"32xin02_.png"] forState:UIControlStateNormal];
    }
    
    [self.headLearnButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photourl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
    self.nameLearnLabel.text = model.nickname;
    self.jiluLearnLabel.text = [NSString stringWithFormat:@"%@",model.studyVal];
}

- (IBAction)rightButtonClick:(UIButton *)sender {
    if (_learnCellTouchuZan) {
        _learnCellTouchuZan(sender.tag - 3401);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
