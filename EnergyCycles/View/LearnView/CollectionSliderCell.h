//
//  CollectionSliderCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionSliderCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)createCollectionSliderCell;

@end
