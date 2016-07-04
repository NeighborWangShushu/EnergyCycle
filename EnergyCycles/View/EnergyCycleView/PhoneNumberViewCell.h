//
//  PhoneNumberViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneNumberViewCell : UITableViewCell

//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//添加按键
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

//线
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end
