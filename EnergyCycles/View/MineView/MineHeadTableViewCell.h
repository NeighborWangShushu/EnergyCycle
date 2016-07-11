//
//  MineHeadTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeadTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIButton *headImage;
// 姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 性别
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
// 签到
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
// 地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
// 简介
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

// 获取数据
- (void)updataDataWithImage:(NSString *)image
                       name:(NSString *)name
                        sex:(NSString *)sex
                     signIn:(NSInteger)signIn
                    address:(NSString *)address
                      intro:(NSString *)intro;

@end
