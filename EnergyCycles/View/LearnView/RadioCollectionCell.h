//
//  RadioCollectionCell.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioItem.h"


@interface RadioCollectionCell : UICollectionViewCell

@property (nonatomic,copy)NSString * pic;
@property (nonatomic,copy)NSString * url;
@property (nonatomic,strong)RadioItem * item;
@property (nonatomic)BOOL isPlay;

@property (weak, nonatomic) IBOutlet UIImageView *img;
@end
