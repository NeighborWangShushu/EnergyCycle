//
//  TheAdvPKCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/9.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TheAdvMainModel.h"

@interface TheAdvPKCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^netAdvBack)(void);

//
@property (weak, nonatomic) IBOutlet UITableView *theAdvTableView;

//block
@property (nonatomic, copy) void(^theAdvPKCollectionView)(TheAdvMainModel *model,NSInteger touchIndex);

@property (nonatomic, copy) void(^getAwardNameAndID)(NSString * awardName,NSString *awardId);

//
@property (nonatomic, copy) void(^jumpToOtherInformation)(TheAdvMainModel *model);

@property(nonatomic,strong)NSString * awardStr;// 奖品name
@property(nonatomic,strong)NSString * awardID;//奖品ID

//获得网络数据
- (void)advPKShowCollectionGetDataWithIndex:(int)indexPath;


@end
