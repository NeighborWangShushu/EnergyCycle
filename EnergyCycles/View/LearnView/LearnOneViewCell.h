//
//  LearnOneViewCell.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LearnViewShowModel.h"

@interface LearnOneViewCell : UITableViewCell

//显示图片
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//阅读数量
@property (weak, nonatomic) IBOutlet UILabel *isKanNumber;
@property (strong, nonatomic) IBOutlet UIButton *zanButton;
@property (strong, nonatomic) IBOutlet UIButton *caiButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;

//填充数据
- (void)updateWithModel:(LearnViewShowModel *)model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTypeLabelWithAutoLayout;



@end
