//
//  ECTimeLineModel.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECTimeLineCellLikeItemModel,ECTimeLineCellCommentItemModel;

@interface ECTimeLineModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, strong) NSArray *picNamesArray;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, strong) NSArray<ECTimeLineCellLikeItemModel *> *likeItemsArray;
@property (nonatomic, strong) NSArray<ECTimeLineCellCommentItemModel *> *commentItemsArray;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;


@end

