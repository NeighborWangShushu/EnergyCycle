//
//  NewsTwoCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

//备用
#import <UIKit/UIKit.h>

#import "MessageModel.h"

@interface NewsTwoCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^netTwoBack)(void);

//点击回调-私信
@property (nonatomic, copy) void(^MessageTwoShowSelectCell)(MessageModel *model, NSInteger touIndex);

//
@property (weak, nonatomic) IBOutlet UITableView *myNewsSiXinTableView;

//填充数据
- (void)creatInformationCollectionViewWithIndex:(NSInteger)index;



@end
