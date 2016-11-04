//
//  ECPhotoScrollVC.h
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ECPhotoScrollVC : UIViewController

@property (nonatomic, strong) PHFetchResult *albumData;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
