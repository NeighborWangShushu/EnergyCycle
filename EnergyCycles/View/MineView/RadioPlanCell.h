//
//  RadioPlanCell.h
//  EnergyCycles
//
//  Created by vj on 2017/1/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,RadioPlanCellStyle) {
    RadioPlanCellStyleNormal = 0,
    RadioPlanCellStyleSwitch
    
};

@protocol RadioPlanDelegate;

@interface RadioPlanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *text;

@property (nonatomic,assign)RadioPlanCellStyle style;

@property (nonatomic,weak)id<RadioPlanDelegate>delegate;

@property (nonatomic,assign)BOOL isChecked;

//设置cell样式
- (void)setStyle:(RadioPlanCellStyle)style;

//是否重复
- (void)setSwitchSelected:(BOOL)selected;


@end

@protocol RadioPlanDelegate <NSObject>

- (void)switchValueDidChange:(RadioPlanCell*)cell isSelected:(BOOL)selected;

@end
