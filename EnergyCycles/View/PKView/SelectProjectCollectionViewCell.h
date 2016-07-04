//
//  SelectProjectCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectProjectCollectionViewCell : UICollectionViewCell

//显示图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//选中图片
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)updateCollectionDataWith;


@end
