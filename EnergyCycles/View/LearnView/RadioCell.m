//
//  RadioCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RadioCell.h"
#import "Masonry.h"
#import "RadioCollectionCell.h"
#import "RadioItem.h"

@interface RadioCell ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    NSSet * sets;
}

@end

@implementation RadioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRadios:(NSMutableArray *)radios {
    if (radios) {
        _radios = radios;
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
}

- (void)setup {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置每个item的大小，
    [flowLayout setItemSize:CGSizeMake((Screen_width - 50)/3, (Screen_width - 50)/3)];
    //    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    // 设置列的最小间距
    flowLayout.minimumInteritemSpacing = 10;
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 15;
    // 设置布局的内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    // 滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[RadioCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:collectionView];
    
    NSInteger height = (((Screen_width - 50)/3) * 2) + 20;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(height + 10));
    }];
}

#pragma mark UICollectionViewDataSource 
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RadioCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    RadioItem * item = self.radios[indexPath.row];
    item.ID = indexPath.row;
    cell.pic = item.pic;
    cell.url = item.url;
    cell.item = item;
    cell.item.ID = item.ID;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.radios count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
