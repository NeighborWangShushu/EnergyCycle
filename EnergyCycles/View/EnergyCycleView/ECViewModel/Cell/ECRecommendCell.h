//
//  ECRecommendCell.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECRecommendCellDelegate <NSObject>

/**
 *  点击推荐用户
 *
 *  @param cell   ECRecommendCell
 *  @param userId 用户id
 *  @param name   用户昵称
 */
- (void)didClickCommendUser:(UITableViewCell*)cell userId:(NSString*)userId userName:(NSString*)name;

@end

@interface ECRecommendCell : UITableViewCell

@property (nonatomic,copy)NSMutableArray *datas;

@property (nonatomic,weak)id<ECRecommendCellDelegate>delegate;

@end
