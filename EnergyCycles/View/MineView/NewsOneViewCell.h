//
//  NewsOneViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsOneViewCell : UITableViewCell

//
@property (weak, nonatomic) IBOutlet UIImageView *readPointImageView;
//
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;


@end
