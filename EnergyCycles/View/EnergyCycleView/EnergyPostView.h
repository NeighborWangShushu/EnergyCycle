//
//  EnergyPostView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextView.h"


@interface EnergyPostView : UIView

//block
@property (nonatomic, copy) void(^energyCyclesInputDict)(NSDictionary *dict);

//输入内容
@property (strong, nonatomic) CustomTextView *informationTextView;





@end
