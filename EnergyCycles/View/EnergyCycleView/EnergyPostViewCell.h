//
//  EnergyPostViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTextView.h"

@interface EnergyPostViewCell : UITableViewCell

//block
@property (nonatomic, copy) void(^energyCyclesInputDict)(NSDictionary *dict);

//标题
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
//输入内容
@property (weak, nonatomic) IBOutlet CustomTextView *informationTextView;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;



@end
