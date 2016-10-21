//
//  EnergyPostView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECPostShareDelegate <NSObject>

- (void)didChooseShareItems:(NSMutableArray*)items;

@end

@interface EnergyPostShareView : UIView


@property (nonatomic,assign)id<ECPostShareDelegate>delegate;

@end
