//
//  ECPAlertWhoCell.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECPAlertWhoCellDelegate;


@interface ECPAlertWhoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *text;

@property (nonatomic,strong) NSMutableArray * datas;
- (IBAction)alertAction:(id)sender;

@property (nonatomic,assign)id<ECPAlertWhoCellDelegate>delegate;



@end


@protocol ECPAlertWhoCellDelegate <NSObject>

- (void)didSelected;

@end