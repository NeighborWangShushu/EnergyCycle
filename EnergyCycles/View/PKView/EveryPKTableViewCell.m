//
//  EveryPKTableViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "EveryPKTableViewCell.h"

@implementation EveryPKTableViewCell

- (void)awakeFromNib {
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 20.f;
    
    [self.headButton setBackgroundImage:[UIImage imageNamed:@"touxiang.png"] forState:UIControlStateNormal];
}

#pragma mark - 填充数据
- (void)updateEveryDayPKDataWithIndex:(NSInteger)index withModel:(EveryDPKPMModel *)model {
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.leftButton setTitle:@"" forState:UIControlStateNormal];
    if (index == 0) {
        self.leftImageView.image = [UIImage imageNamed:@"NO1_.png"];
    }else if (index == 1) {
        self.leftImageView.image = [UIImage imageNamed:@"NO2_.png"];
    }else if (index == 2) {
        self.leftImageView.image = [UIImage imageNamed:@"NO3_.png"];
    }else {
        [self.leftButton setBackgroundImage:[UIImage imageNamed:@"38paimingkuang_.png"] forState:UIControlStateNormal];
        [self.leftButton setTitle:[NSString stringWithFormat:@"%ld",index+1] forState:UIControlStateNormal];
    }
    
    //
    [self.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photourl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
    
    //
    self.nameLabel.text = model.nickname;
    
    //
    self.jiluLabel.text = [NSString stringWithFormat:@"%@ %@",model.repItemNum,model.unit];
    
    //
    if ([model.haslike integerValue] == 0) {
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"39xin01_.png"] forState:UIControlStateNormal];
    }else {
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"32xin02_.png"] forState:UIControlStateNormal];
    }
    self.rightButton.tag = 30001+index;
}

- (IBAction)rightButtonClick:(UIButton *)sender {
    if (_zanButtonClick) {
        _zanButtonClick(sender.tag - 30001);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
