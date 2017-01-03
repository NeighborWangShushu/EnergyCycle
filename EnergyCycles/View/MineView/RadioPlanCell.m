//
//  RadioPlanCell.m
//  EnergyCycles
//
//  Created by vj on 2017/1/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RadioPlanCell.h"
#import "Masonry.h"

@interface RadioPlanCell ()

@property (nonatomic,strong)UIImageView * checkImg;

@property (nonatomic,strong)UISwitch * switchButton;

@end

@implementation RadioPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setStyle:(RadioPlanCellStyle)style {
    switch (style) {
        case RadioPlanCellStyleNormal:
            [self setupNormal];
            break;
        case RadioPlanCellStyleSwitch:
            [self setupSwitch];
            break;
        default:
            break;
    }
}

- (void)setupNormal {
    _checkImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_playradio_time_checked"]];
    [self addSubview:_checkImg];
    [_checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    _checkImg.hidden = YES;
    
}

- (void)setupSwitch {
   
    _switchButton = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_switchButton setOnTintColor:[UIColor colorWithRed:239.0/255.0 green:79.0/255.0 blue:81.0/255.0 alpha:1.0]];
    [_switchButton addTarget:self action:@selector(switchValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_switchButton];
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.width.equalTo(@60);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

- (void)setIsChecked:(BOOL)isChecked {
    _checkImg.hidden = !isChecked;
}


- (void)switchValueDidChanged:(UISwitch*)sender {
    
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([_delegate respondsToSelector:@selector(switchValueDidChange:isSelected:)]) {
        [_delegate switchValueDidChange:self isSelected:mySwitch.isOn];
    }
}

- (void)setup {
    
    
}

- (void)setSwitchSelected:(BOOL)selected {
    [_switchButton setSelected:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
