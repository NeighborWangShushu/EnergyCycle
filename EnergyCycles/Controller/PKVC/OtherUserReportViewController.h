//
//  OtherUserReportViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface OtherUserReportViewController : BaseViewController {
    IBOutlet UITableView *otherUserReportTableView;
}

@property (nonatomic, strong) NSString *otherUserId;
@property (nonatomic, strong) NSString *otherName;


@end
