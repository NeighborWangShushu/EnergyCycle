//
//  LearnShowTwoCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"

@interface LearnShowTwoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITableView *learnTwoTableView;

////block 选中的Cell
//@property (nonatomic, copy) void(^learnBaShowSelectCell)(UserModel *model,NSString *type);

//block 点击其他用户头像
@property (nonatomic, copy) void(^learnShowOtherSelect)(UserModel *model);

//
- (void)creatTwoCollectionViewWithIndex:(NSString *)indexStr;


@end
