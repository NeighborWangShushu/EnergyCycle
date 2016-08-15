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
    for (NSUInteger i = 0; i<40; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"2_0%ld", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages duration:1.0 forState:MJRefreshStatePulling];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;

}




@end
