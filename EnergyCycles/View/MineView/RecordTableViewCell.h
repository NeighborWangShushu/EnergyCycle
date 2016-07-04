//
//  RecordTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell

//
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
//
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
//
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *kuaidiLabel;



@end
