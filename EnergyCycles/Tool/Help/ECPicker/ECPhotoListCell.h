//
//  ECPhotoListCollectionViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECPhotoListCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL isSelected;

- (void)selected;

@end
