//
//  OtherUserTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserTableViewCell : UITableViewCell

@property (nonatomic, strong) void(^zanButtonClick)(NSInteger index);

//
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageVoew;
//
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
//
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
- (IBAction)zanButtonClick:(UIButton *)sender;


@end
