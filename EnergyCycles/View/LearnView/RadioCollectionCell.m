//
//  RadioCollectionCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RadioCollectionCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface RadioCollectionCell () {
    UIButton * play;
    int stopIndex;
}

@end
@implementation RadioCollectionCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRadioPlayer:) name:@"stopRadioPlayer" object:nil];
    
    [self setup];
}

- (void)stopRadioPlayer:(NSNotification*)noti {
    stopIndex = [[[noti userInfo] objectForKey:@"index"] intValue];
    NSLog(@"stopIndex%i",stopIndex);
    if (self.item.ID == stopIndex) {
        //停止
        self.item.isPlay = NO;
        [play setSelected:self.item.isPlay];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RadioCollectionCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)setPic:(NSString *)pic {
    [self.img setImage:[UIImage imageNamed:pic]];
}

- (void)setup {
    
    play = [UIButton buttonWithType:UIButtonTypeCustom];
    [play setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [play setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    [self addSubview:play];
    
    [play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.width.equalTo(@26);
        make.height.equalTo(@26);
    }];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
   
}

- (void)setItem:(RadioItem *)item {
    _item = item;
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSInteger playIndex = delegate.audioPlayIndex;
    if(self.item.ID == playIndex){
        self.item.isPlay = YES;
        [play setSelected:self.item.isPlay];
    }
}

- (void)play:(UIButton*)sender {
    
    if (!self.item.isPlay) {
        //播放
         [[NSNotificationCenter defaultCenter] postNotificationName:@"RadioCollectionCellPlay" object:nil userInfo:@{@"url":[NSString stringWithFormat:@"%@",self.url],@"index":[NSString stringWithFormat:@"%ld",self.item.ID]}];
        self.item.isPlay = YES;
        [play setSelected:self.item.isPlay];
    }else {
        //暂停
         [[NSNotificationCenter defaultCenter] postNotificationName:@"RadioCollectionCellStop" object:nil userInfo:@{@"url":[NSString stringWithFormat:@"%@",self.url],@"index":[NSString stringWithFormat:@"%ld",self.item.ID]}];
        self.item.isPlay = NO;
        [play setSelected:self.item.isPlay];
    }

}

@end
