//
//  ECShareCell.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ECShareType) {
    ECShareTypeMoment,
    ECShareTypeWechat,
    ECShareTypeSina,
    ECShareTypeQzone,
    ECShareTypeOther,
};

@protocol ECShareCellDelegate <NSObject>

- (void)didChooseShareItems:(NSMutableArray*)items;

@end

@interface ECShareCell : UITableViewCell

@property (nonatomic,weak)id<ECShareCellDelegate>delegate;


//0  朋友圈  1 微信好友 2 新浪微博 3 qq空间
- (IBAction)shareAction:(id)sender;




@end
