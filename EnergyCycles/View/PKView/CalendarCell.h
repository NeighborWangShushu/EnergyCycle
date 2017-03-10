//
//  CalendarCell.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "FSCalendarCell.h"

typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeFinish,
    SelectionTypeUndone
};

@interface CalendarCell : FSCalendarCell

@property (weak, nonatomic) CAShapeLayer *selectionLayer;

@property (assign, nonatomic) SelectionType selectionType;

@end
