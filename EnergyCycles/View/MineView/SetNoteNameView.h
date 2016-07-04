//
//  SetNoteNameView.h
//  EnergyCycles
//
//  Created by Adinnet on 16/3/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetNoteNameView : UIView

@property (nonatomic, copy) void(^setNoteNameStr)(NSString *inputStr,NSInteger tag);

- (instancetype)initWithFrame:(CGRect)frame withTag:(NSInteger)tag;


@end
