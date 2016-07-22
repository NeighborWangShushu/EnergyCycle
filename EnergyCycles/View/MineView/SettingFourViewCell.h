//
//  SettingFourViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingFourViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;


// 获取数据
- (void)updateDataWithJudge:(BOOL)judge;

@end
