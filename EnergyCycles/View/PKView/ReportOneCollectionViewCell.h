//
//  ReportOneCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PKSelectedModel.h"

@interface ReportOneCollectionViewCell : UICollectionViewCell

//
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

//
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//填充数据
- (void)updateCollectionViewDataWithModel:(PKSelectedModel *)model;


@end
