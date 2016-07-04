//
//  BottomView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SDTimeLineCellBottomView : UIView

@property (nonatomic,copy)void(^SDTimeLineCellBottomSelectedBlock)(NSInteger type);

@end

typedef NS_ENUM(NSUInteger, SDAdditionalActionViewType) {
    SDAdditionalActionViewTypeShare,
    SDAdditionalActionViewTypeComment,
    SDAdditionalActionViewTypeLike
};

@interface SDAdditionalActionView : UIView

@property (nonatomic,assign)SDAdditionalActionViewType type;

@property (nonatomic,copy)void(^selctedAddition)(SDAdditionalActionViewType type);

@end