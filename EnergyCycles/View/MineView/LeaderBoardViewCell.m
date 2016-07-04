//
//  LeaderBoardViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LeaderBoardViewCell.h"

@implementation LeaderBoardViewCell

- (void)awakeFromNib {
    [self.headLearnButton setBackgroundImage:[UIImage imageNamed:@"touxiang.png"] forState:UIControlStateNormal];
    self.headLearnButton.layer.masksToBounds = YES;
    self.headLearnButton.layer.cornerRadius = 20.f;
    
    self.leftLearnButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)updateLearderBoardDataWithModel:(UserModel *)model withIndex:(NSInteger)index {
    [self.leftLearnButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.leftLearnButton setTitle:@"" forState:UIControlStateNormal];
    if (index == 0) {
        self.leftLearnImageView.image = [UIImage imageNamed:@"NO1_.png"];
    }else if (index == 1) {
        self.leftLearnImageView.image = [UIImage imageNamed:@"NO2_.png"];
    }else if (index == 2) {
        self.leftLearnImageView.image = [UIImage imageNamed:@"NO3_.png"];
    }else {
        self.leftLearnImageView.image = [UIImage imageNamed:@""];
        [self.leftLearnButton setBackgroundImage:[UIImage imageNamed:@"hring.png"] forState:UIControlStateNormal];
        [self.leftLearnButton setTitle:[NSString stringWithFormat:@"%ld",(long)index+1] forState:UIControlStateNormal];
        [self.leftLearnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    self.nameLearnLabel.text = model.nickname;
    self.jiluLearnLabel.text = model.jifen;
    
    [self.headLearnButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photourl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
}

- (IBAction)rightButtonClick:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
