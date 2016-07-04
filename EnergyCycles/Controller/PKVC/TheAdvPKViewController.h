//
//  TheAdvPKViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/29.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface TheAdvPKViewController : BaseViewController 

@property (weak, nonatomic) IBOutlet UICollectionView *theAdvPKCollectionView;

//进阶发帖按键
@property (weak, nonatomic) IBOutlet UIButton *theAdvPostButton;
//进阶发帖按键响应事件
- (IBAction)theAdvPostButtonClick:(id)sender;

//头按键背视图
@property (weak, nonatomic) IBOutlet UIView *headBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBackViewAutoLayoutContent;



@end
