//
//  AttentionAndFansTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "OtherUserModel.h"

@interface AttentionAndFansTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
// 姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 简介
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
// 关注
@property (weak, nonatomic) IBOutlet UIButton *isAttention;

- (void)getdateDataWithHeadImage:(NSString *)headImage
                            name:(NSString *)name
                           intro:(NSString *)intro
                     isAttention:(int)isAttention;

- (void)getdateDataWithUserModel:(UserModel *)userModel;

- (void)getdateDataWithOtherUserModel:(OtherUserModel *)otherUserModel;

@end
