//
//  tabbarViewController.h
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECTabbarView.h"



@interface ECTabbarViewController : UIViewController


- (void)hideTabbar:(BOOL)hide;

@property(nonatomic,strong) NSArray *arrayViewcontrollers;

/**
 *  当前打开的页面Index
    0-能量圈  1-pk  2-学习 3-我的
 */
@property(nonatomic,assign) NSInteger selctedIndex;

/**
 *  单例
 *
 *  @return ECTabbarViewController
 */
+ (ECTabbarViewController *)shareInstance;

- (void)setSelectIndex:(NSInteger)index;



@end



