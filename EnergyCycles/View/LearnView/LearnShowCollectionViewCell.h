//
//  LearnShowCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"
#import "LearnViewShowModel.h"

@interface LearnShowCollectionViewCell : UICollectionViewCell

//block 选中的Cell
@property (nonatomic, copy) void(^learnShowSelectCell)(LearnViewShowModel *model,NSString *type,NSInteger touchIndex);

//block 选中的Cell
@property (nonatomic, copy) void(^learnBaShowSelectCell)(UserModel *model,NSString *type);

//TableVie
@property (weak, nonatomic) IBOutlet UITableView *learnShowTableView;

//
- (void)creatCollectionViewWithIndex:(NSString *)indexStr;


@end
