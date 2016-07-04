//
//  LearnPageViewController.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@interface LearnPageViewController : UIViewController

- (id)initWithData:(NSDictionary*)data;

@property (nonatomic,strong)NSString * type;

@property (nonatomic,strong)CategoryModel * model;

- (void)reloadData;

@end
