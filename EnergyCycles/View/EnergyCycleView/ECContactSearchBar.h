//
//  ECContactSearchBar.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@protocol ECContactSearchBarDelegate;

@interface ECContactSearchBar : UISearchBar

@property (nonatomic,strong)NSMutableArray * datas;

@property (nonatomic, assign, setter = setHasCentredPlaceholder:) BOOL hasCentredPlaceholder;

@property (nonatomic,assign)id<ECContactSearchBarDelegate>edelegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end

@protocol ECContactSearchBarDelegate <NSObject>

- (void)contactSearchBar:(ECContactSearchBar*)searchBar model:(UserModel*)model isClear:(BOOL)isClear;

@end