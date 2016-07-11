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
                        count:(NSDictionary *)count{
    if (section == 1) {
        if (index == 0) {
            self.leftImage.image = [UIImage imageNamed:@"energy"];
            self.leftLabel.text = @"能量圈";
            [self lineView];
        } else if (index == 1) {
            self.leftImage.image = [UIImage imageNamed:@"Group 7"];
            self.leftLabel.text = @"关注";
            [self lineView];
        } else if (index == 2) {
            self.leftImage.image = [UIImage imageNamed:@"Group 6"];
            self.leftLabel.text = @"粉丝";
            [self lineView];
        } else if (index == 3) {
            self.leftImage.image = [UIImage imageNamed:@"mail-icon"];
            self.leftLabel.text = @"消息";
            [self lineView];
        } else if (index == 4) {
            self.leftImage.image = [UIImage imageNamed:@"Group 5"];
            self.leftLabel.text = @"PK记录";
            self.rightLabel.text = @"";
            [self lineView];
        } else if (index == 5) {
            self.leftImage.image = [UIImage imageNamed:@"paihang"];
            self.leftLabel.text = @"推荐用户";
        }
    } else if (section == 2) {
        self.leftImage.image = [UIImage imageNamed:@"Group 4"];
        self.leftLabel.text = @"积分榜";
        self.rightLabel.text = @"";
    } else if (section == 3) {
        self.leftImage.image = [UIImage imageNamed:@"Group 62"];
        self.leftLabel.text = @"设置";
        self.rightLabel.text = @"";
    }
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 50, self.frame.size.height + 6, self.frame.size.width + 50, 1);
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
