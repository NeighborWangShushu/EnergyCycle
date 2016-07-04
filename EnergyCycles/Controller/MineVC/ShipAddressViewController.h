//
//  ShipAddressViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface ShipAddressViewController : BaseViewController {
    IBOutlet UITableView *shipAddressTableView;
}

@property (nonatomic, strong) NSString *shangPinID;
@property (nonatomic, strong) NSString *drawType;


@end
