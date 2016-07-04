//
//  UIColor+Extension.h
//  DuoLiFarm
//
//  Created by AD-iOS on 15/5/14.
//  Copyright (c) 2015年 wangding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
@end
