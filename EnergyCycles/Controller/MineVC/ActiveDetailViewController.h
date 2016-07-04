//
//  ActiveDetailViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 16/1/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

#import "InformationModel.h"

@interface ActiveDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *showWebView;

@property (nonatomic, strong) InformationModel *model;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *touchIndex;


@end
