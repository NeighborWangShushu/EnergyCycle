//
//  SettingTwoViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTwoViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

// 添加数据
- (void)updateDataWithSection:(NSInteger)section index:(NSInteger)index;

- (void)isOtherLogin;

@end
