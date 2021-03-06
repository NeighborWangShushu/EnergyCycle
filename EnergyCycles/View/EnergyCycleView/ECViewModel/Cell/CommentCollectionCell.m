//
//  CommentCollectionCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CommentCollectionCell.h"
#import "UIImageView+WebCache.h"

@implementation CommentCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setModel:(CommentUserModel *)model {
    _model = model;
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = self.icon.frame.size.width/2;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    self.name.text = model.name;
    self.name.adjustsFontSizeToFitWidth = YES;

    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CommentCollectionCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}


@end
