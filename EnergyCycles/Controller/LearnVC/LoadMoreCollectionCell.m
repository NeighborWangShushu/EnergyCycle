//
//  LoadMoreCollectionCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LoadMoreCollectionCell.h"

@implementation LoadMoreCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"LoadMoreCollectionCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

@end
