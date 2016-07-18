//
//  EnergyPostCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "EnergyPostCollectionViewCell.h"

@implementation EnergyPostCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    UILongPressGestureRecognizer*longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressGesture:)];
    longGesture.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longGesture];
    
}


- (void)longpressGesture:(UILongPressGestureRecognizer*)gesture {
    
    if ([self.delegate respondsToSelector:@selector(didLongpressedImage:)]) {
        [self.delegate didLongpressedImage:self.tag];
    }
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"EnergyPostCollectionViewCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

@end
