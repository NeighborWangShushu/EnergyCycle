//
//  ECSiftCell.h
//  EnergyCycles
//
//  Created by vj on 2016/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTimeLineModel.h"

//精选动态
@interface ECSiftCell : UITableViewCell

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray<ECTimeLineModel*> * models;

@end
