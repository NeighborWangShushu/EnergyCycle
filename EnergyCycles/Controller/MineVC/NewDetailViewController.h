//
//  NewDetailViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

#import "InformationModel.h"

@interface NewDetailViewController : BaseViewController {
    IBOutlet UITableView *newDetailTableView;
}

@property (nonatomic, strong) InformationModel *model;


@end
