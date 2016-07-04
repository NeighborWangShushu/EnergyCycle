//
//  MineEveryDayPKViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface MineEveryDayPKViewController : BaseViewController

//头部背景
@property (weak, nonatomic) IBOutlet UIView *headBackView;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

//个人图片
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;
- (IBAction)headImageButtonClick:(id)sender;

//今日PK
@property (weak, nonatomic) IBOutlet UIButton *nowDayPKButton;
- (IBAction)nowDayPKButtonClick:(UIButton *)sender;

//历史记录
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
- (IBAction)historyButtonClick:(UIButton *)sender;

//线
@property (weak, nonatomic) IBOutlet UIView *backLineView;


@property (weak, nonatomic) IBOutlet UICollectionView *showCollectionView;



@end
