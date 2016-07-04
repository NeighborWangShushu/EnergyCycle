//
//  ReportTwoTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/10.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTwoTableViewCell : UITableViewCell

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//输入标题
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
//单位
@property (weak, nonatomic) IBOutlet UILabel *danweiLabel;


@end
