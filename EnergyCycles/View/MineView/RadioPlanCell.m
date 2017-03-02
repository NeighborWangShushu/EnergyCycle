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

@property (nonatomic,strong)UILabel * week;

@property (nonatomic,strong)UILabel * time;

@property (nonatomic,strong)UILabel * radio;

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

- (void)setStyle:(RadioPlanCellStyle)style model:(RadioClockModel *)model {
    
    _model = model;
    
    switch (style) {
        case RadioPlanCellStyleNormal:
            [self setupNormal];
            break;
        case RadioPlanCellStyleSwitch:
            [self setupSwitch];
            break;
        case RadioPlanCellStyleTime:
            [self setupTime];
            break;
        case RadioPlanCellStyleRadio:
            [self setupRadio];
            break;
        case RadioPlanCellStyleFeaturesSwitch:
            [self setupFeaturesSwitch];
            break;
        case RadioPlanCellStyleChannel:
            [self setupChannel];
            break;
        default:
            break;
    }
}

- (void)setupNormal {
    if (!_checkImg) {
        _checkImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_playradio_time_checked"]];
        [self addSubview:_checkImg];
        [_checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-20);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    _checkImg.hidden = YES;
    
}

- (void)setupSwitch {
   
    if (!_switchButton) {
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
   if (self.model.isOpen) {
        [_switchButton setOn:YES];
    }
}

- (void)setupTime {
    
    if (!self.week) {
        self.week = [[UILabel alloc] init];
        self.week.font = [UIFont systemFontOfSize:13];
        self.week.textColor = [UIColor blackColor];
        [self addSubview:self.week];
        
        self.time = [[UILabel alloc] init];
        self.time.font = [UIFont systemFontOfSize:13];
        self.time.textColor = [UIColor blackColor];
        [self addSubview:self.time];
        
        UIImageView * arrow = [UIImageView new];
        [arrow setImage:[UIImage imageNamed:@"Myjiantou.png"]];
        [self addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-20);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self.week mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-40);
            make.top.equalTo(@10);
            make.height.equalTo(@15);
        }];
        
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-40);
            make.top.equalTo(self.week.mas_bottom).with.offset(5);
        }];
    }
    self.week.text = _model.notificationWeekydays;
    self.time.text = self.model.specificTime;

    
}

- (void)setupRadio {
    
    if (!self.radio) {
        self.radio = [[UILabel alloc] init];
        self.radio.font = [UIFont systemFontOfSize:15];
        self.radio.textColor = [UIColor blackColor];
        [self addSubview:self.radio];
        [self.radio mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-40);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UIImageView * arrow = [UIImageView new];
        [arrow setImage:[UIImage imageNamed:@"Myjiantou.png"]];
        [self addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-20);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    self.radio.text = _model.channelName;

    
}

- (void)setupFeaturesSwitch {
    if (!_switchButton) {
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
    if (self.model.isOpen) {
        [_switchButton setOn:YES];
    }
}

- (void)setupChannel {
    if (!_checkImg) {
        _checkImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_playradio_time_checked"]];
        [self addSubview:_checkImg];
        [_checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-20);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    _checkImg.hidden = YES;
    
}


- (void)setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
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

//是否重复
- (void)setSwitchSelected:(BOOL)selected {
    [_switchButton setSelected:selected];
}

//是否打开提醒功能
- (void)setOpenSelected:(BOOL)selected {
    [_switchButton setSelected:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
