//
//  MyPointsViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface MyPointsViewController : BaseViewController {
    IBOutlet UITableView *pointTableView;
}

@property (weak, nonatomic) IBOutlet UIView *shuLineView;

//
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
- (IBAction)leftButtonClick:(id)sender;

//
@property (weak, nonatomic) IBOutlet UIButton *numButton;



@end
