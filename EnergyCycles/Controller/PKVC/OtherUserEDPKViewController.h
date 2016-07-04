//
//  OtherUserEDPKViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 16/3/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface OtherUserEDPKViewController : BaseViewController {
    __weak IBOutlet UITableView *otherUserRecTableView;
}

@property (nonatomic, strong) NSString *showUserID;
@property (nonatomic, strong) NSString *showTitle;


@end
