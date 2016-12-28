//
//  ECSiftCell.h
//  EnergyCycles
//
//  Created by vj on 2016/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTimeLineModel.h"

@protocol ECSiftCellDelegate <NSObject>

- (void)ecSiftCellDidSelectedItem:(NSIndexPath*)indexPath model:(ECTimeLineModel*)model;

@end

//精选动态
@interface ECSiftCell : UITableViewCell

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray<ECTimeLineModel*> * models;

@property (nonatomic,weak)id<ECSiftCellDelegate>delegate;

@end
