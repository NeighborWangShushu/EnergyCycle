//
//  ECNavMenuCell.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECNavMenuModel.h"


@interface ECNavMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectedIcon;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (nonatomic,strong)ECNavMenuModel * model;

@end
