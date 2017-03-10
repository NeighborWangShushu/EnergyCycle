//
//  RightNavMenuCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightNavMenuModel.h"

@interface RightNavMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)getDataWithModel:(RightNavMenuModel *)model;

- (void)lineView;

@end
