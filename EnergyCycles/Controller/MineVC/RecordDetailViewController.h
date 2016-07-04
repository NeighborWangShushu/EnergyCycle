//
//  RecordDetailViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface RecordDetailViewController : BaseViewController {
    IBOutlet UITableView *recordDetailTableView;
}

@property (nonatomic, strong) NSString<Optional> *recordId;



@end
