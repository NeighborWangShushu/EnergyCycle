//
//  ReportPostingTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportPostingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (nonatomic, assign) BOOL onPost;

- (void)updateData;

@end
