//
//  IntroViewController.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextView.h"
@interface IntroViewController : UIViewController

@property (weak, nonatomic) IBOutlet CustomTextView *introTextView;

@property (nonatomic, copy) NSString *introString;

@end
