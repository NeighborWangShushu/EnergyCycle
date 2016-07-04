//
//  CourseTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/14.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell

//
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
//
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *biaoLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *liulanLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeLabelAutoLayout;


@end
