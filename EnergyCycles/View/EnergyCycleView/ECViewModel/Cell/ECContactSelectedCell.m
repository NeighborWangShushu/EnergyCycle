//
//  ECContactSelectedCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECContactSelectedCell.h"

@implementation ECContactSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ECContactSelectedCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

@end
