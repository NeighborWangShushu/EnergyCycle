//
//  NavMenuView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECNavMenuModel.h"

@protocol NavMenuViewDelegate <NSObject>

- (void)didSelected:(NSIndexPath*)indexPath item:(ECNavMenuModel*)model;

@end

@interface NavMenuView : UIView


/**
 *  初始化接口
 *
 *  @param datas Menu标题数据，数据类型为String
 *
 *  @return UIView
 */
- (instancetype)initWithDatas:(NSArray*)datas;


@property (nonatomic,assign)id<NavMenuViewDelegate>delegate;


@end
