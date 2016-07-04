//
//  CoustomGiftView.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoustomGiftView : UIView

@property (nonatomic, copy) void(^customGitView)(NSString *inputStr,NSInteger index);

//
- (instancetype)initWithFrame:(CGRect)frame withNickName:(NSString *)nickName;


@end
