//
//  MineTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

- (void)updateDataWithSection:(NSInteger)section
                        index:(NSInteger)index
                        userInfoModel:(UserInfoModel *)userInfoModel {
    if (section == 1) {
//        if (index == 0) {
//            self.leftImage.image = [UIImage imageNamed:@"energy"];
//            self.leftLabel.text = @"能量帖";
//            self.rightLabel.text = userInfoModel.NLQCount;
//            [self lineView];
//        } else if (index == 1) {
//            self.leftImage.image = [UIImage imageNamed:@"Group 7"];
//            self.leftLabel.text = @"关注";
//            self.rightLabel.text = userInfoModel.GuanZhuCount;
//            [self lineView];
//        } else if (index == 2) {
//            self.leftImage.image = [UIImage imageNamed:@"Group 6"];
//            self.leftLabel.text = @"粉丝";
//            self.rightLabel.text = userInfoModel.FenSiCount;
//            [self lineView];
//        } else if (index == 3) {
//            self.leftImage.image = [UIImage imageNamed:@"mail-icon"];
//            self.leftLabel.text = @"消息";
//            self.rightLabel.text = userInfoModel.MsgCount;
//            [self lineView];
//        } else if (index == 4) {
//            self.leftImage.image = [UIImage imageNamed:@"Group 5"];
//            self.leftLabel.text = @"PK记录";
//            self.rightLabel.text = @"";
//            [self lineView];
//        } else if (index == 5) {
//            self.leftImage.image = [UIImage imageNamed:@"paihang"];
//            self.leftLabel.text = @"推荐用户";
//            self.rightLabel.text = userInfoModel.TuiJianCount;
//        }
        if (index == 0) {
            self.leftImage.image = [UIImage imageNamed:@"energy"];
            self.leftLabel.text = @"我的能量源";
            self.rightImage.hidden = YES;
            self.constraint.constant = 19;
            self.rightLabel.text = userInfoModel.PowerSource;
            self.rightLabel.textColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
            self.rightLabel.alpha = 0.8;
            [self lineView];
        } else if (index == 1) {
            self.leftImage.image = [UIImage imageNamed:@"ziliao"];
            self.leftLabel.text = @"我的资料";
            self.rightLabel.text = @"修改";
            [self lineView];
        } else if (index == 2) {
            self.leftImage.image = [UIImage imageNamed:@"Group 5"];
            self.leftLabel.text = @"我的社交圈";
            self.rightLabel.text = @"好友";
            [self lineView];
        } else if (index == 3) {
            self.leftImage.image = [UIImage imageNamed:@"Group 7"];
            self.leftLabel.text = @"关注";
            self.rightLabel.text = userInfoModel.GuanZhuCount;
            [self lineView];
        } else if (index == 4) {
            self.leftImage.image = [UIImage imageNamed:@"Group 6"];
            self.leftLabel.text = @"粉丝";
            self.rightLabel.text = userInfoModel.FenSiCount;
            [self lineView];
        } else if (index == 5) {
            self.leftImage.image = [UIImage imageNamed:@"mail-icon"];
            self.leftLabel.text = @"消息";
            self.rightLabel.text = userInfoModel.MsgCount;
            if ([userInfoModel.MsgCount isEqualToString:@"0"] || userInfoModel.MsgCount == nil) {
                self.rightLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:0.8];
            } else {
                self.rightLabel.textColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
            }
        }
    } else if (section == 2) {
        if (index == 0) {
            self.leftImage.image = [UIImage imageNamed:@"paihang"];
            self.leftLabel.text = @"积分排行榜";
            self.rightLabel.text = @"查看排行";
            [self lineView];
        } else if (index == 1) {
            self.leftImage.image = [UIImage imageNamed:@"jifen"];
            self.leftLabel.text = @"积分商城";
            self.rightLabel.text = @"兑换排行";
        }
        
    } else if (section == 3) {
        self.leftImage.image = [UIImage imageNamed:@"Group 62"];
        self.leftLabel.text = @"设置";
        self.rightLabel.text = @"";
    } else if (section == 4) {
        self.leftImage.hidden = YES;
        self.leftLabel.hidden = YES;
        self.rightLabel.hidden = YES;
        self.rightImage.hidden = YES;
        self.centerLabel.hidden = NO;
    }
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 50, self.frame.size.height - 1, self.frame.size.width + 50, 1);
    line.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.contentView addSubview:line];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
