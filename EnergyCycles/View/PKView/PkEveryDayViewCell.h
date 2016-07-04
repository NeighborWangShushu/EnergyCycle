//
//  PkEveryDayViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/8.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EveryDayPKModel.h"
#import "EveryDPKPMModel.h"

@interface PkEveryDayViewCell : UICollectionViewCell {
    __weak IBOutlet UITableView *pkEveryDayTableView;
}

@property (nonatomic, copy) void(^netBackEvery)(void);

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

//block 点击头像
@property (nonatomic, copy) void(^headButtonTouchu)(EveryDPKPMModel *model);

//block 点击cell
@property (nonatomic, copy) void(^otherCellTouch)(EveryDPKPMModel *model);

//
@property (nonatomic, copy) void(^jumpToMineEveryDayPK)(void);

//填充数据
- (void)pkShowCollectionGetDataWithIndex:(EveryDayPKModel *)model;



@end
