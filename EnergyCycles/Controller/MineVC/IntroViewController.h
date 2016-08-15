//
//  IntroViewController.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomTextView.h"

@interface IntroViewController : BaseViewController

@property (weak, nonatomic) IBOutlet CustomTextView *introTextView;

@property (nonatomic, copy) NSString *introString;
@property (nonatomic, assign) BOOL isMyProfile;

@end
