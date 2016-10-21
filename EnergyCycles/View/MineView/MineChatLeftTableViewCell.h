//
//  MineChatLeftTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MineChatLeftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *leftHeadButton;

@property (weak, nonatomic) IBOutlet UILabel *leftContentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftContentImage;

- (void)updateDataWithModel:(MessageModel *)model;

@end
