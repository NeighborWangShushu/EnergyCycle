//
//  EnergyPostViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "EnergyPostViewCell.h"
#import "EnergyPostCollectionViewCell.h"
#import "Masonry.h"


@interface EnergyPostViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation EnergyPostViewCell

- (void)awakeFromNib {
    self.informationTextView.placehoder = @"说点什么吧...";
    
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(60, 60);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[EnergyPostCollectionViewCell class] forCellWithReuseIdentifier:@"EnergyPostCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@80);
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark --GET

- (void)setPics:(NSMutableArray *)pics {
    
    _pics = pics;
    if (self.collectionView) {
        [self.collectionView reloadData];
    }
}


#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.pics count]) {
        if ([self.delegate respondsToSelector:@selector(didAddPic)]) {
            [self.delegate didAddPic];
        }
    }
}


#pragma mark --UICollectionViewDataSource

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *EnergyPostCollectionViewCellId = @"EnergyPostCollectionViewCell";
    EnergyPostCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EnergyPostCollectionViewCellId forIndexPath:indexPath];
    if (indexPath.row != [self.pics count]) {
        [cell.showImageView setImage:self.pics[indexPath.row]];
    }
    
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.pics.count == 8) {
        return [self.pics count];
    }
    return self.pics.count + 1;
}


@end
