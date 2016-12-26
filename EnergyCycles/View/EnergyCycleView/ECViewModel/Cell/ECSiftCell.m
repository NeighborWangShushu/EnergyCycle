//
//  ECSiftCell.m
//  EnergyCycles
//
//  Created by vj on 2016/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECSiftCell.h"
#import "ECSiftCollectionCell.h"

@interface ECSiftCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end


@implementation ECSiftCell

//NSString  *const cellID = @"ECSiftCollectionCell";


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.itemSize = CGSizeMake(Screen_width/2 - 15, Screen_width/2 + 60);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 0);
    
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView registerClass:[ECSiftCollectionCell class] forCellWithReuseIdentifier:@"ECSiftCollectionCell"];
    self.collectionView.allowsMultipleSelection = NO;//默认为NO,是否可以多选
    [self addSubview:self.collectionView];
    
}


- (void)setModels:(NSMutableArray<ECTimeLineModel *> *)models {
    _models = models;
    NSInteger line = _models.count%2 + 1;
    CGFloat itemHeight = Screen_width/2 + 70;
    [self.collectionView setFrame:CGRectMake(5, 0, Screen_width - 10, itemHeight * line)];
    
    
    [self.collectionView reloadData];
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ECSiftCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ECSiftCollectionCell" forIndexPath:indexPath];

    cell.model = [self.models objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(ecSiftCellDidSelectedItem:model:)]) {
        [self.delegate ecSiftCellDidSelectedItem:indexPath model:[self.models objectAtIndex:indexPath.row]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
