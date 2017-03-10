//
//  ProjectCollectionViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKSelectedModel.h"

@interface ProjectCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;

- (void)getDataWithModel:(PKSelectedModel *)model;

@end
