//
//  TheAddressBookViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface TheAddressBookViewController : BaseViewController {
    IBOutlet UITableView *addressBookTableView;
}

@property (weak, nonatomic) IBOutlet UIView *searchBackView;


@end
