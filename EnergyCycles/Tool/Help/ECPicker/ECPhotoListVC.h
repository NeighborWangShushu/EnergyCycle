//
//  ECPhotoListViewController.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

@interface ECPhotoListVC : UIViewController

@property (nonatomic, strong) PHFetchResult *fetchResult;

@end
