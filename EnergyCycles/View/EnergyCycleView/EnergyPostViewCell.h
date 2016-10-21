//
//  EnergyPostViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTextView.h"

@protocol EnergyPostViewCellDelegate;

@interface EnergyPostViewCell : UITableViewCell

//block
@property (nonatomic, copy) void(^energyCyclesInputDict)(NSDictionary *dict);

//标题
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
//输入内容
@property (weak, nonatomic) IBOutlet CustomTextView *informationTextView;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (strong, nonatomic)  UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray * pics;

@property (nonatomic,weak)id<EnergyPostViewCellDelegate>delegate;

- (IBAction)addPicAction:(id)sender;
@end

@protocol EnergyPostViewCellDelegate <NSObject>


- (void)didAddPic;

- (void)didClickPic:(EnergyPostViewCell*)cell currentIndex:(NSInteger)index pics:(NSArray*)pics;

@end
