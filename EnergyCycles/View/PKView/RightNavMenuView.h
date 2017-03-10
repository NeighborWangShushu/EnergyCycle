//
//  RightNavMenuView.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightNavMenuModel.h"

@protocol RightNavMenuViewDelegate <NSObject>

- (void)didSelected:(NSIndexPath *)indexPath;

@end

@interface RightNavMenuView : UIView

@property (nonatomic, weak) id<RightNavMenuViewDelegate> delegate;

- (instancetype)initWithDataArray:(NSArray *)dataArray;

@end
