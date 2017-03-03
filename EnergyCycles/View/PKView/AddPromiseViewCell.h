//
//  PromiseViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPromiseViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView; // 容器视图

@property (weak, nonatomic) IBOutlet UIButton *centerButton; // 中心按钮

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel; // 底部标签

- (void)setup;

@end
