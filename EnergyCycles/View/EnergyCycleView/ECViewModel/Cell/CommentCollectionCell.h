//
//  CommentCollectionCell.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentUserModel.h"

@interface CommentCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic,strong)CommentUserModel*model;
@property (weak, nonatomic) IBOutlet UIImageView *badge;

- (void)showMore;
@end
