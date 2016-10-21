//
//  ECContactCell.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface ECContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (nonatomic,strong) UserModel*model;

@end
