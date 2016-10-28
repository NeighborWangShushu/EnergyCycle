//
//  RadioListTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RadioListTableViewCell.h"
#import "AFSoundManager.h"

@implementation RadioListTableViewCell

- (void)getDataWithModel:(RadioModel *)model {
    
    if ([AFSoundManager sharedManager].player.status == AVPlayerStatusReadyToPlay) {
        NSLog(@"111");
        NSURL *url = [NSURL URLWithString:model.RadioUrl];
        if ([url isEqual:self.radioUrl]) {
            NSLog(@"222%@", model.Name);
            [self setAnimation];
        }
    }
    
    // 电台图片
    [self.radioImage sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl]];
    
    // 电台名字
    self.radioName.text = model.Name;
    
    // 电台简介
    self.radioIntro.text = @"简介";
    
    [self lineView];
    
}

- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 12, self.frame.size.height - 1, self.frame.size.width + 50, 1);
    line.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.contentView addSubview:line];
}

- (void)setAnimation {
    CGSize size = CGSizeMake(50, 50);
    CGFloat height = 10;
    CGFloat height_h = size.height - height;
    CGFloat width = 10;
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - height, width, height)];
    firstView.backgroundColor = [UIColor redColor];
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(20, size.height - height_h, width, height_h)];
    secondView.backgroundColor = [UIColor redColor];
    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(40, size.height - height, width, height)];
    thirdView.backgroundColor = [UIColor redColor];
    [self.RadioPlayAnimation addSubview:firstView];
    [self.RadioPlayAnimation addSubview:secondView];
    [self.RadioPlayAnimation addSubview:thirdView];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionRepeat
                     animations:^{
                         firstView.frame = CGRectMake(0, size.height - height_h, width, height_h);
                         secondView.frame = CGRectMake(20, size.height - height, width, height);
                         thirdView.frame = CGRectMake(40, size.height - height_h, width, height_h);
                     } completion:^(BOOL finished) {
                         
                     }];
    
//    UIView *fourthView = [[UIView alloc] init];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
