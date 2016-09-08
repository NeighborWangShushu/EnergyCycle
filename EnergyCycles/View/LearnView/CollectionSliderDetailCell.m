//
//  CollectionSliderDetailCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CollectionSliderDetailCell.h"

@implementation CollectionSliderDetailCell

- (void)getDataWithUrl:(NSString *)url indexPath:(NSIndexPath *)indexPath{
    self.url = url;
    switch (indexPath.row) {
        case 0: {
            [self.backgroundImage setImage:[UIImage imageNamed:@"Learn_CCTalk"] forState:UIControlStateNormal];
            self.nameLabel.text = @"CC课堂";
            break;
        }
        case 1: {
            [self.backgroundImage setImage:[UIImage imageNamed:@"Learn_AudioBooks"] forState:UIControlStateNormal];
            self.nameLabel.text = @"有声书";
        }
            break;
        case 2: {
            [self.backgroundImage setImage:[UIImage imageNamed:@"Learn_GreatVideo"] forState:UIControlStateNormal];
            self.nameLabel.text = @"精彩视频";
            break;
        }
        default:
            break;
    }
}

- (IBAction)clickAction:(id)sender {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
