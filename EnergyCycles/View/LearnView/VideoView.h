//
//  VideoView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthModel.h"

@protocol VideoViewDelegate;


@interface VideoView : UIView

@property (nonatomic,strong)HealthModel * model;

@property (nonatomic,assign)id<VideoViewDelegate>delegate;

- (id)initWithItem:(HealthModel*)model;


@end

@protocol VideoViewDelegate <NSObject>

- (void)videoView:(VideoView*)view didSelected:(HealthModel*)model;

@end