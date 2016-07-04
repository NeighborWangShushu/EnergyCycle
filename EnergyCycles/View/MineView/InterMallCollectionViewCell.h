//
//  InterMallCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MallModel.h"

@interface InterMallCollectionViewCell : UICollectionViewCell

//
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
//
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
//
@property (weak, nonatomic) IBOutlet UIImageView *jiaImageView;
//
- (void)creatCollectionViewWithModel:(MallModel *)model;


@end
