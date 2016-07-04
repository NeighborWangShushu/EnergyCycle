//
//  PKHomeViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKHomeViewCell : UITableViewCell

//最底层ImageView
@property (weak, nonatomic) IBOutlet UIImageView *downBackImageView;

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//点击按键
@property (weak, nonatomic) IBOutlet UIButton *touchuButton;


@end
