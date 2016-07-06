//
//  SDTimeLineCell.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "ECTimeLineModel.h"

typedef NS_ENUM(NSUInteger, ECTimeLineCellActionType) {
    ECTimeLineCellActionTypeShare,
    ECTimeLineCellActionTypeComment,
    ECTimeLineCellActionTypeLike
};

@protocol ECTimeLineCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell;

- (void)didActionInCell:(UITableViewCell*)cell actionType:(ECTimeLineCellActionType)type atIndexPath:(NSIndexPath*)indexPath;

@end

@class ECTimeLineModel;

@interface ECTimeLineCell : UITableViewCell

@property (nonatomic, weak) id<ECTimeLineCellDelegate> delegate;

@property (nonatomic, strong) ECTimeLineModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic) ECTimeLineCellActionType type;
@end
