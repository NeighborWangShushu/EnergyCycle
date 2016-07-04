//
//  SearchResultsViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchResultsViewController : BaseViewController {
    IBOutlet UITableView *searchResultTableView;
}

@property (nonatomic, copy) NSString *myType;
@property (nonatomic, strong) NSString *mySearchStr;


@end
