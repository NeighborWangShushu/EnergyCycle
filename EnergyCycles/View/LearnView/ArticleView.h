//
//  ArticleView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthModel.h"

@protocol ArticleViewDelegate;

@interface ArticleView : UIView

@property (nonatomic,readonly)HealthModel*model;
@property (nonatomic,assign)id<ArticleViewDelegate>delegate;

- (id)initWithItem:(HealthModel*)model;

@end

@protocol ArticleViewDelegate <NSObject>

- (void)articleView:(UIView*)view didSelectedItem:(HealthModel*)model;

@end
