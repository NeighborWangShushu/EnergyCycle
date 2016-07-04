//
//  IntegralMallViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface IntegralMallViewController : BaseViewController {
    IBOutlet UICollectionView *InterMallCollectionView;
}

@property (weak, nonatomic) IBOutlet UIView *headBackView;
//左按键
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
- (IBAction)leftButtonClick:(id)sender;
//右按键
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)rightButtonClick:(id)sender;
//数
@property (weak, nonatomic) IBOutlet UIButton *numButton;
- (IBAction)numButtonClick:(id)sender;


@end
