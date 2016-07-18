//
//  ECShareCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECShareCell.h"

@interface ECShareCell ()


@property (nonatomic,strong) NSMutableArray * shares;
@end

@implementation ECShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableArray*)shares {
    if (!_shares) {
        _shares = [NSMutableArray array];
    }
    return _shares;
}

- (IBAction)shareAction:(id)sender {
    UIButton*button = (UIButton*)sender;
    [button setSelected:!button.isSelected];
    if(button.isSelected) {
        [self.shares addObject:[NSNumber numberWithInteger:button.tag]];
    }else {
        [self.shares removeObject:[NSNumber numberWithInteger:button.tag]];
    }
    
    NSLog(@"%@",self.shares);
    if ([self.delegate respondsToSelector:@selector(didChooseShareItems:)]) {
        [self.delegate didChooseShareItems:_shares];
    }
}

- (ECShareType)getType:(NSInteger)index {
    switch (index) {
        case 0:
            return ECShareTypeMoment;
            break;
        case 1:
            return ECShareTypeWechat;
            break;
        case 2:
            return ECShareTypeSina;
            break;
        case 3:
            return ECShareTypeQzone;
            break;
            
        default:
            break;
    }
    return ECShareTypeOther;
}

@end
