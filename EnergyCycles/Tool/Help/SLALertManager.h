//
//  SLALertManager.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SLScoreType){
    SLScroeTypeOne,
    SLScroeTypeTwo,
    SLScroeTypeThree,
    SLScroeTypeFour,
    SLScroeTypeSix,
    SLScroeTypeTen,
    SLScroeTypeTwenty,
    SLScroeTypeThirty,
    SLScroeTypeForty,
    SLScroeTypeFifty
};

@interface SLALertManager : NSObject

+ (SLALertManager *)shareManager;


- (void)showAlert:(SLScoreType)type;


@end
