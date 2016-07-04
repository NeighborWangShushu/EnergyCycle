//
//  CustomChooseClassView.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LearnCustomChooseClassView : UIView

//block 选中的分类
@property (nonatomic, copy) void(^chooseClassStr)(NSString *str,NSInteger showType);

- (instancetype)initWithFrame:(CGRect)frame WithType:(NSInteger)type;


@end
