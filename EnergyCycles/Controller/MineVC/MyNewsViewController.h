//
//  MyNewsViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface MyNewsViewController : BaseViewController {
    IBOutlet UICollectionView *myNewsCollectionView;
}

@property (weak, nonatomic) IBOutlet UIView *headBackView;

@property (nonatomic, strong) NSString *pushType;


@end
