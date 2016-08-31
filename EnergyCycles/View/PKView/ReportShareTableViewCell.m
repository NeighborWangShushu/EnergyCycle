//
//  ReportShareTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ReportShareTableViewCell.h"

@implementation ReportShareTableViewCell
- (IBAction)qqAction:(id)sender {
    if (self.onQQ) {
        [self.qqButton setImage:[UIImage imageNamed:@"offQQ"] forState:UIControlStateNormal];
        self.onQQ = NO;
    } else {
        [self.qqButton setImage:[UIImage imageNamed:@"onQQ"] forState:UIControlStateNormal];
        self.onQQ = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportQQSwitch" object:self.onQQ ? @"YES" : @"NO"];
}

- (IBAction)wechatAction:(id)sender {
    if (self.onWechat) {
        [self.wechatButton setImage:[UIImage imageNamed:@"offWechat"] forState:UIControlStateNormal];
        self.onWechat = NO;
    } else {
        [self.wechatButton setImage:[UIImage imageNamed:@"onWechat"] forState:UIControlStateNormal];
        self.onWechat = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportWechaSwitch" object:self.onWechat ? @"YES" : @"NO"];
}

- (IBAction)momentsAction:(id)sender {
    if (self.onMoments) {
        [self.momentsButton setImage:[UIImage imageNamed:@"offMoments"] forState:UIControlStateNormal];
        self.onMoments = NO;
    } else {
        [self.momentsButton setImage:[UIImage imageNamed:@"onMoments"] forState:UIControlStateNormal];
        self.onMoments = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportMomentsSwitch" object:self.onMoments ? @"YES" : @"NO"];
}

- (IBAction)weiboAction:(id)sender {
    if (self.onWeibo) {
        [self.weiboButton setImage:[UIImage imageNamed:@"offWeibo"] forState:UIControlStateNormal];
        self.onWeibo = NO;
    } else {
        [self.weiboButton setImage:[UIImage imageNamed:@"onWeibo"] forState:UIControlStateNormal];
        self.onWeibo = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportWeiboSwitch" object:self.onWeibo ? @"YES" : @"NO"];
}

- (void)updateData {
    self.onQQ = NO;
    self.onWechat = NO;
    self.onMoments = NO;
    self.onWeibo = NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
