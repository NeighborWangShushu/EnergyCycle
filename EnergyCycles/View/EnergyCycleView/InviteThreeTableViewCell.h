//
//  InviteThreeTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteThreeTableViewCell : UITableViewCell

//头像点击
@property (nonatomic, copy) void(^iconButtonClick)(NSInteger index);

//头像
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
- (IBAction)iconButtonClick:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIButton *focusButton;


@end
