//
//  OtherUserShowViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 16/3/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserShowViewCell : UITableViewCell

@property (nonatomic, copy) void(^otherUserButtonClick)(NSInteger index);

@property (nonatomic, copy) void(^otherUserHeadButtonClick)(NSInteger index);

//
@property (weak, nonatomic) IBOutlet UIButton *headButton;
- (IBAction)otherHeadButtonClick:(UIButton *)sender;

//
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)rightButtonClick:(UIButton *)sender;


@end
