//
//  NewsCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InformationModel.h"
#import "MessageModel.h"

@interface NewsCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^netBack)(void);

//点击回调-通知
@property (nonatomic, copy) void(^InformationShowSelectCell)(InformationModel *model, NSInteger touIndex);

//点击回调-私信
//@property (nonatomic, copy) void(^MessageShowSelectCell)(MessageModel *model, NSInteger touIndex);

//点击回调-活动
@property (nonatomic, copy) void(^ActiveShowSelectCell)(InformationModel *model, NSInteger touIndex);

//
@property (weak, nonatomic) IBOutlet UITableView *myNewsTableView;

//填充数据
- (void)creatInformationCollectionViewWithIndex:(NSInteger)index;


@end
