//
//  PostingViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "DraftsModel.h"

@interface PostingViewController : BaseViewController {
    
}

- (instancetype)initWithModel:(DraftsModel*)model;

- (IBAction)cancel:(id)sender;
- (IBAction)push:(id)sender;

@end
