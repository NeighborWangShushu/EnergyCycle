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


@interface EnergyPostViewCell ()

@end

@implementation EnergyPostViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.informationTextView.placehoder = @"说点什么吧... \r正文字数不得少于30字";

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//#pragma mark --GET
//
//- (void)setPics:(NSMutableArray *)pics {
//    
//    _pics = pics;
//    if (self.collectionView) {
//        [self.collectionView reloadData];
//    }
//}
//
//
//#pragma mark UICollectionViewDelegate
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == [self.pics count]) {
//        if ([self.delegate respondsToSelector:@selector(didAddPic)]) {
//            [self.delegate didAddPic];
//        }
//    }else {
//        if ([self.delegate respondsToSelector:@selector(didClickPic:currentIndex:pics:)]) {
//            [self.delegate didClickPic:self currentIndex:indexPath.row pics:self.pics];
//        }
//    }
//}
//
//
//#pragma mark --UICollectionViewDataSource
//
//- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *EnergyPostCollectionViewCellId = @"EnergyPostCollectionViewCell";
//    EnergyPostCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EnergyPostCollectionViewCellId forIndexPath:indexPath];
//    if (indexPath.row != [self.pics count]) {
//        [cell.showImageView setImage:self.pics[indexPath.row]];
//    }
//    
//    return cell;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (self.pics.count == 8) {
//        return [self.pics count];
//    }
//    return self.pics.count + 1;
//}


@end
