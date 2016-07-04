//
//  SearchOneTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchOneTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^searchCollectionTouch)(NSString *searchStr,NSInteger type);

@property (nonatomic, copy) void(^cleanHistory)(BOOL isloadMore);

@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;

//
- (void)updateWithType:(NSInteger)type;


@end
