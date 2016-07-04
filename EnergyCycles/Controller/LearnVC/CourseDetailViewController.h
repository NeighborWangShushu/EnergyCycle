//
//  CourseDetailViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface CourseDetailViewController : BaseViewController {
    UIWebView *showWebView;
    UIView *showWabBackView;
}

@property (nonatomic, copy) void(^courseDetail)(void);

@property (weak, nonatomic) IBOutlet UITableView *tuijianTableView;

@property (nonatomic, strong) NSString *courseID;
@property (nonatomic, strong) NSString *courseType;

@property (nonatomic, strong) NSString *courseTitle;
@property (nonatomic, strong) NSString *courseContent;


@end
