//
//  SoicalTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGSwipeTableCell.h"

@interface SoicalTableViewCell : MGSwipeTableCell

@property (nonatomic, copy) void(^soicalButtonClick)(NSInteger index);

@property (nonatomic, copy) void(^soicalHeadButtonClick)(NSInteger index);

//
@property (weak, nonatomic) IBOutlet UIButton *headButton;
- (IBAction)soicalHeadButtonClick:(UIButton *)sender;

//
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//
@property (weak, nonatomic) IBOutlet UIImageView *prizeImageView;
//
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)rightButtonClick:(UIButton *)sender;


@end
