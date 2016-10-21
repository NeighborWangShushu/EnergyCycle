//
//  ChatTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface ChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *text;

- (void)updateDataWithModel:(MessageModel *)model;

@end
