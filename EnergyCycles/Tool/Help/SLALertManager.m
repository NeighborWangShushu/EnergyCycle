//
//  SLALertManager.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SLALertManager.h"
#import "SCLAlertView.h"

@implementation SLALertManager

#pragma mark - 单例
+ (SLALertManager *)shareManager {
    static SLALertManager *shareAlertMessage = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareAlertMessage = [[self alloc] init];
    });
    
    return shareAlertMessage;
}

- (void)showAlert:(SLScoreType)type {

    UIImage*contentImg = [self getImg:type];
    SCLAlertView*alertView = [[SCLAlertView alloc] initWithNewWindow];
    [alertView setHideAnimationType:SlideOutToCenter];
    [alertView setShowAnimationType:SlideInFromCenter];
    alertView.backgroundType = Transparent;
    [alertView removeTopCircle];
    [alertView setBackgroundViewColor:[UIColor clearColor]];
    alertView.shouldDismissOnTapOutside = YES;
    UIImageView*img = [[UIImageView alloc] initWithImage:contentImg];
    [img setFrame:CGRectMake(10, 0, 182, 176)];
    [alertView addCustomView:img];
    [alertView showTitle:@"" subTitle:@"" style:Custom closeButtonTitle:@"" duration:2.0];
}

- (UIImage*)getImg:(SLScoreType)type {
    UIImage*img = nil;
    
    switch (type) {
        case SLScroeTypeOne:
            img = [UIImage imageNamed:@"score_1"];
            break;
        case SLScroeTypeTwo:
            img = [UIImage imageNamed:@"score_2"];
            break;
        case SLScroeTypeThree:
            img = [UIImage imageNamed:@"score_3"];
            break;
        case SLScroeTypeFour:
            img = [UIImage imageNamed:@"score_4"];
            break;
        case SLScroeTypeSix:
            img = [UIImage imageNamed:@"score_6"];
            break;
        case SLScroeTypeTen:
            img = [UIImage imageNamed:@"score_10"];
            break;
        case SLScroeTypeTwenty:
            img = [UIImage imageNamed:@"score_20"];
            break;
        case SLScroeTypeThirty:
            img = [UIImage imageNamed:@"score_30"];
            break;
        case SLScroeTypeForty:
            img = [UIImage imageNamed:@"score_40"];
            break;
        case SLScroeTypeFifty:
            img = [UIImage imageNamed:@"score_50"];
            break;
        default:
            break;
    }
    
    return img;
    
}


@end
