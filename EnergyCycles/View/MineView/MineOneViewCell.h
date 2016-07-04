//
//  MineOneViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineOneViewCell : UITableViewCell

//
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
//
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

//填充数据
- (void)updateDataWithStr:(NSString *)getStr;


@end
