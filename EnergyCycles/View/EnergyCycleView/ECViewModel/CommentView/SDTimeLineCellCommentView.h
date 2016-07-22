//
//  SDTimeLineCellCommentView.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "GlobalDefines.h"
#import "ECTimeLineCellCommentItemModel.h"

@protocol SDTimeLineCellCommentViewDelegate <NSObject>



/**
 *  点击评论人的名字或者点赞人的名字
 *
 *  @param linkId   评论人或者点赞人的id
 *  @param linkName 评论人或者点赞人的名称
 */


- (void)didClickLink:(NSString*)linkId linkName:(NSString*)linkName;


/**
 *  点击回复
 *
 *  @param model 该条回复的model数据，里面包括回复人和被回复人的相关信息
 */

- (void)didChooseReplyItem:(ECTimeLineCellCommentItemModel*)model;

@end

@interface SDTimeLineCellCommentView : UIView

@property (nonatomic,assign)id<SDTimeLineCellCommentViewDelegate>delegate;


- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;

@end
