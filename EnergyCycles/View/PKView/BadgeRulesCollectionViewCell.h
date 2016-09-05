//
//  BadgeRulesCollectionViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeRulesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *badgeImage;

- (void)updateImageViewWithDays:(NSString *)days flag:(NSString *)flag;

@end