//
//  AboutTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

- (void)updateDataWithIndex:(NSInteger)index;

@end
