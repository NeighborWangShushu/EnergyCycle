//
//  OtherCell.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthModel.h"


@protocol OtherCellDelegate;

@interface OtherCell : UITableViewCell

@property (nonatomic,strong)NSMutableArray * healths;

@property (nonatomic,assign)id<OtherCellDelegate>delegate;

@end

@protocol OtherCellDelegate <NSObject>

- (void)otherCellView:(OtherCell*)cell didSelectedItem:(HealthModel*)model;

@end