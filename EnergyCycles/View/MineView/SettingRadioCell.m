//
//  SettingRadioCell.m
//  EnergyCycles
//
//  Created by vj on 2016/12/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingRadioCell.h"

@interface SettingRadioCell ()

@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation SettingRadioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self lineView];
    
}

- (void)setTimeValue:(NSString *)time {
    _time.text = time;
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 31, self.frame.size.height - 1, Screen_width - 50, 1);
    line.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.contentView addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
