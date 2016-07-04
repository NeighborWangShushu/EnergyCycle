//
//  ScrollTagView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollTagViewDelegate;
@protocol ScrollTagViewDataSource;

@interface ScrollTagView : UIScrollView

- (id)initWithFrame:(CGRect)frame;

- (void)reloadData;

@property (nonatomic,assign)id<ScrollTagViewDelegate>vdelegate;

@property (nonatomic,assign)id<ScrollTagViewDataSource>vdataSrouce;

@end

@protocol ScrollTagViewDelegate <NSObject>

- (void)didSelected:(ScrollTagView*)scrollView index:(NSInteger)selectedIndex;

@end

@protocol ScrollTagViewDataSource <NSObject>

- (NSString*)scrollTagView:(ScrollTagView*)scrollView index:(NSInteger)dataIndex;

- (NSInteger)numberOfScrollTagView:(ScrollTagView*)scrollView;

@end