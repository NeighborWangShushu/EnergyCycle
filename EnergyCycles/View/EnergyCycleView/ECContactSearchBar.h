//
//  ECContactSearchBar.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECContactSearchBar : UISearchBar

@property (nonatomic,strong)NSMutableArray * datas;

@property (nonatomic, assign, setter = setHasCentredPlaceholder:) BOOL hasCentredPlaceholder;


- (instancetype)initWithFrame:(CGRect)frame;

@end
