//
//  EnergyShowBackCollectionCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnergyCycleShowCellModel.h"

#import "EnergyMainModel.h"

@interface EnergyShowBackCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITableView *showTableView;

//cell点击回调
@property (nonatomic, copy) void(^EnergyCycleCellBlock)(EnergyCycleShowCellModel *model,NSInteger tocuhIndex);

//
@property (nonatomic, copy) void(^energyCycleHeadBlock)(EnergyMainModel *model);

//获得网络数据
- (void)energyShowCollectionGetDataWithIndex:(NSInteger)indexPath;


@end
