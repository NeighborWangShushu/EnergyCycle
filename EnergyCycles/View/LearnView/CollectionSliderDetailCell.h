//
//  CollectionSliderDetailCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"

@interface CollectionSliderDetailCell : UICollectionViewCell

@property (nonatomic, copy) NSString *url;
// 图片按钮
@property (weak, nonatomic) IBOutlet UIButton *backgroundImage;
// 文字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)getDataWithModel:(BannerModel *)model;

@end
