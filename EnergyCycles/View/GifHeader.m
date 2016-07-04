//
//  GifHeader.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "GifHeader.h"

@implementation GifHeader

- (void)prepare {
    [super prepare];
    
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=40; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld_03", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages duration:1.0 forState:MJRefreshStatePulling];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;

}




@end
