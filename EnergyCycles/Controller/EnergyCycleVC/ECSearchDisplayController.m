//
//  ECSearchDisplayController.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECSearchDisplayController.h"

@implementation ECSearchDisplayController


- (void)setActive:(BOOL)visible animated:(BOOL)animated
{
    [super setActive: visible animated: animated];
    
    //move the dimming part down
    for (UIView *subview in self.searchContentsController.view.subviews) {
        //NSLog(@"%@", NSStringFromClass([subview class]));
        if ([subview isKindOfClass:NSClassFromString(@"UISearchDisplayControllerContainerView")])
        {
            UIView*view = subview.subviews[2];
            for (UIView*v in view.subviews) {
                if ([v isKindOfClass:NSClassFromString(@"_UISearchDisplayControllerDimmingView")]) {
                    v.backgroundColor = [UIColor whiteColor];
                    v.alpha = 1.0;
                }
            }
        }
    }
    
}

@end
