//
//  MineChatTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MineChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *rightHeadButton;

@property (weak, nonatomic) IBOutlet UILabel *rightContentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightContentImage;

- (void)updateDataWithModel:(MessageModel *)model;

@end
