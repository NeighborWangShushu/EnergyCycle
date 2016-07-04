//
//  ColumCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ColumCell.h"
#import "Masonry.h"

@interface ColumCell () {
    UIImageView * img;
}

@end

@implementation ColumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.text.adjustsFontSizeToFitWidth = YES;
    self.layer.masksToBounds = NO;
    // Initialization code
}

- (void)setup {
    if (self.tag == 0 || self.tag == 1 ) {
        [self.img setImage:nil];
        return;
    }
    NSLog(@"%@--isEdit:%ld",self.text.text,self.tag);

    [self.img setImage:[UIImage imageNamed:@"learn_delete"]];
 
}

- (void)setIsEdit:(BOOL)isEdit {
    if (isEdit) {
        NSLog(@"setup%ld",self.tag);
        [self setup];
    }else {
        [self.img setImage:nil];
    }
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ColumCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}


@end
