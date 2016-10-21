//
//  CollectionSliderCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CollectionSliderCell.h"
#import "CollectionSliderDetailCell.h"
#import "BannerModel.h"

@interface CollectionSliderCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation CollectionSliderCell

- (void)createCollectionSliderCell {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    CGFloat width = (Screen_width - 40) / 3;
    layout.itemSize = CGSizeMake(width, self.frame.size.height);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, self.frame.size.height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionSliderDetailCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
//    [collectionView registerClass:[CollectionSliderDetailCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionSliderDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    BannerModel *model = self.dataArray[indexPath.row];
    [cell getDataWithModel:model];
    cell.layer.cornerRadius = 5;
    return cell;
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
