//
//  ECPhotoListViewController.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECPickerControllerDelegate <NSObject>

@optional
- (void)exportImageData:(NSArray *)imageData ID:(NSArray *)ID;

@end

@import Photos;

@interface ECPhotoListVC : UIViewController

@property (nonatomic, strong) PHFetchResult *fetchResult;

@property (nonatomic, assign) id<ECPickerControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *imageIDArr;

@end
