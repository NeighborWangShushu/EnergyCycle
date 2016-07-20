//
//  EnergyPostCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnergyPostCollectionViewCellDelegate <NSObject>

- (void)didLongpressedImage:(NSInteger)index;

@end


@interface EnergyPostCollectionViewCell : UICollectionViewCell

//显示图片
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (strong, nonatomic) IBOutlet UIImageView *showJiaImageView;

@property (nonatomic,weak) id<EnergyPostCollectionViewCellDelegate>delegate;
@end
