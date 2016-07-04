//
//  SelectTheProjectViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectTheProjectViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UICollectionView *selectProjectCollectionView;

@property (nonatomic, strong) NSArray *getChooseArr;


@end
