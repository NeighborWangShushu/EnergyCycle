//
//  MySocialCircleViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface MySocialCircleViewController : BaseViewController {
    IBOutlet UICollectionView *mySocialCircleCollectionView;
}

@property (weak, nonatomic) IBOutlet UIView *soicalHeadView;

//显示类型
@property (nonatomic, strong) NSString *showType;


@end
