//
//  SocialCollectionViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface SocialCollectionViewCell : UICollectionViewCell

//
@property (nonatomic, strong) void(^soicalTouchIndex)(UserModel *model);

@property (weak, nonatomic) IBOutlet UITableView *socialTableView;

#pragma mark - 填充数据
- (void)updateDataWithType:(NSInteger)type withIsRefresh:(BOOL)isRefresh;


@end
