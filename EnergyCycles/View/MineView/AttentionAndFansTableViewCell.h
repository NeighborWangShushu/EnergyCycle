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
// 用户ID
@property (nonatomic, copy) NSString *userid;
// 是否关注
@property (nonatomic, assign) BOOL attention;

// 关注的数据
- (void)getdateAttentionDataWithUserModel:(UserModel *)userModel;
// 粉丝的数据
- (void)getdateFansDataWithUserModel:(UserModel *)userModel;
// 其他用户的关注与粉丝的数据
- (void)getdateDataWithOtherUserModel:(OtherUserModel *)otherUserModel;

@end
