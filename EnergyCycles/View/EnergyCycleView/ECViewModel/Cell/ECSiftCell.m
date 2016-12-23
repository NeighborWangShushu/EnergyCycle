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

NSString  *const cellID = @"ECSiftCollectionCell";


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.itemSize = CGSizeMake(Screen_width/2 - 5, Screen_width/2 - 5);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ECSiftCollectionCell class] forCellWithReuseIdentifier:cellID];
    self.collectionView.allowsMultipleSelection = NO;//默认为NO,是否可以多选
    [self addSubview:self.collectionView];
}

- (NSMutableArray*)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    
    return _models;
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
    
    ECSiftCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = [self.models objectAtIndex:indexPath.row];
    
    return nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
