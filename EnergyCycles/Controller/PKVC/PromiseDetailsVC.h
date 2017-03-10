//
//  PromiseDetailsVC.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"

@interface PromiseDetailsVC : UIViewController<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property (nonatomic, strong) UIImageView *indicatorImg;

- (void)getData;

@end
