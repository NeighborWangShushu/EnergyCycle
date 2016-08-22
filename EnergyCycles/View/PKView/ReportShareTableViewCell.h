//
//  ReportShareTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportShareTableViewCell : UITableViewCell

// qq
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
// 微信
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
// 朋友圈
@property (weak, nonatomic) IBOutlet UIButton *momentsButton;
// 微博
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;

@property (nonatomic, assign) BOOL onQQ;

@property (nonatomic, assign) BOOL onWechat;

@property (nonatomic, assign) BOOL onMoments;

@property (nonatomic, assign) BOOL onWeibo;

- (void)updateData;

@end
