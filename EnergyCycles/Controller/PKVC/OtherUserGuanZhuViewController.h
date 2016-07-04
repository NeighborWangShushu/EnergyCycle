//
//  OtherUserGuanZhuViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 16/3/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface OtherUserGuanZhuViewController : BaseViewController {
    IBOutlet UITableView *otherUserTableView;
}

@property (nonatomic, strong) NSString *otherUserID;


@end
