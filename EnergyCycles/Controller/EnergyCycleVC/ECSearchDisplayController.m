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
    if(self.active == visible) return;
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden:NO animated:NO];
    if (visible) {
//        [self.searchBar becomeFirstResponder];
    } else {
//        [self.searchBar resignFirstResponder];
    }
    
    
    //move the dimming part down
    for (UIView *subview in self.searchContentsController.view.subviews) {

        if ([subview isKindOfClass:NSClassFromString(@"UISearchDisplayControllerContainerView")])
        {
//            if (!visible) {
//                UIView*searchView = subview.subviews[1];
//                for (UIView*v in searchView.subviews) {
//                    if ([v isKindOfClass:NSClassFromString(@"ECContactSearchBar")]) {
//                        NSLog(@"%f",v.frame.origin.y);
//                        CGRect frame = v.frame;
//                        NSLog(@"%f---%f",frame.origin.y,frame.size.height);
//                        frame.origin.y = 0;
//                        v.frame = frame;
//                    }
//                }
//            }
        
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
