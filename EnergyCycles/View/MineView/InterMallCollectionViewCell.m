//
//  InterMallCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "InterMallCollectionViewCell.h"

@implementation InterMallCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - 填充数据
- (void)creatCollectionViewWithModel:(MallModel *)model {
    self.jiaImageView.hidden = NO;
    if ([model.merchantType isEqualToString:@"兑换"]) {
        self.jiaImageView.hidden = YES;
    }
    
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"参考价：%@",model.ReferencePrice];
    self.jifenLabel.text = [NSString stringWithFormat:@"%@",model.jifen];
    
    NSArray *imageArr = [model.img componentsSeparatedByString:@","];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:imageArr.firstObject]];
}


@end
