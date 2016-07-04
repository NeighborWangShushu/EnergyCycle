//
//  PkHomeCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKViewCollectionModel.h"

@interface PkHomeCollectionViewCell : UICollectionViewCell

//
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//填充数据
- (void)updateDataEveryPKWithModel:(PKViewCollectionModel *)model;


@end
