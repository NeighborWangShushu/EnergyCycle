//
//  SetProjectCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetProjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

- (void)getDataWithModelIndexPath:(NSIndexPath *)indexPath;

- (void)lineView;

@end
