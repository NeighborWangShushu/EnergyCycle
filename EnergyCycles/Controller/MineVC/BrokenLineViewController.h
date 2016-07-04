//
//  BrokenLineViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface BrokenLineViewController : BaseViewController {
    IBOutlet UITableView *brokenTableView;
}

@property (nonatomic, strong) NSString *showStr;

//
@property (weak, nonatomic) IBOutlet UISegmentedControl *brokenSegmentedControl;
- (IBAction)brokenSegmentdConClick:(UISegmentedControl *)sender;

@property (nonatomic, strong) NSString *projectID;


@end
