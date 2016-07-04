//
//  EnergyCycleViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/23.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"


@interface EnergyCycleViewController : BaseViewController

//显示可侧滑
@property (weak, nonatomic) IBOutlet UICollectionView *showBackCollectionView;

//发帖按键
@property (weak, nonatomic) IBOutlet UIButton *postButton;
//发帖按键响应事件

- (IBAction)postButtonClick:(id)sender;



@end
