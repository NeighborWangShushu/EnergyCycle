//
//  ECContactSelectedCell.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface ECContactSelectedCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UIView *dimmingView;
@property (nonatomic)BOOL isReadyDelete;

@property (nonatomic,strong)UserModel*model;
@end
