//
//  CourseRegistrationViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface CourseRegistrationViewController : BaseViewController {
    IBOutlet UITableView *courseRegisterTableView;
}

@property (nonatomic, strong) NSString *courseID;


@end
