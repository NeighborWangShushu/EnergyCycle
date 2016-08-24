//
//  ECContactVC.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECContactVCDelegate <NSObject>

- (void)didSelectedContacts:(NSMutableArray*)items;

@end

@interface ECContactVC : UIViewController

@property (nonatomic,assign)id<ECContactVCDelegate>delegate;

@end
