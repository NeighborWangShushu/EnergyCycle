//
//  RadioHeadView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ReferralHeadViewTypeNone,
    ReferralHeadViewTypeOther,
    ReferralHeadViewTypeRadio,
    ReferralHeadViewTypeCCTalk,
    ReferralHeadViewTypeCollectionSlider
}ReferralHeadViewType;

@protocol ReferralHeadViewDelegate;

@interface ReferralHeadView : UIView

- (id)initWithName:(NSString*)name;

@property (nonatomic)ReferralHeadViewType type;
@property (nonatomic,copy)NSString * name;

@property (nonatomic,assign)id<ReferralHeadViewDelegate>delegate;

@end


@protocol ReferralHeadViewDelegate <NSObject>

- (void)headView:(ReferralHeadView*)headview showMore:(NSString*)name;

@end