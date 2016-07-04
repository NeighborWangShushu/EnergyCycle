//
//  MyPointTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPointTableViewCell : UITableViewCell

//顶部线
@property (weak, nonatomic) IBOutlet UIView *upLineView;
//底部线
@property (weak, nonatomic) IBOutlet UIView *downLineView;
//点
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;
//虚线
@property (weak, nonatomic) IBOutlet UIImageView *xuxianImageView;

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//数字
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
