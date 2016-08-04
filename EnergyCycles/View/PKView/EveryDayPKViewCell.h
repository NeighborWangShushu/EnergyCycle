//
//  EveryDayPKViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EveryDayPKViewCell : UITableViewCell

@property (nonatomic, strong) void(^zanButton)(NSInteger index);

//
@property (weak, nonatomic) IBOutlet UILabel *paimingLabel;

//
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//
@property (weak, nonatomic) IBOutlet UILabel *classLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UIButton *rightImage;

- (IBAction)clickRightButton:(UIButton *)sender;

@end
