//
//  ECPAlertWhoCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECPAlertWhoView.h"
#import "ECContactSelectedCell.h"
#import "Masonry.h"

@interface ECPAlertWhoView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView * collectionView;

@end

@implementation ECPAlertWhoView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark SET/GET

- (void)setDatas:(NSMutableArray *)datas {
    _datas = datas;
    
    CGFloat width = 0.0f;
    width = datas.count * 40;
    CGFloat height = 0.0f;
    height = MAX((datas.count/3), 1) * 40;
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.text.mas_right).with.offset(30);
        make.right.equalTo(self.mas_right).with.offset(-40);
        make.top.equalTo(self.mas_top).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.height.equalTo(@(height));
        make.width.equalTo(@(width)).with.priorityHigh();
    }];
    [self layoutIfNeeded];
    [self.collectionView reloadData];
}

#pragma mark Initialize

- (void)setup {
    
    self.text = [UILabel new];
    self.text.textColor = [UIColor blackColor];
    self.text.font = [UIFont systemFontOfSize:14];
    self.text.text = @"提醒谁看";
    [self addSubview:self.text];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.itemSize = CGSizeMake(30, 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsSelection = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ECContactSelectedCell class] forCellWithReuseIdentifier:@"CommentCellID"];
    [self addSubview:self.collectionView];
    
    UIImageView * arrow = [UIImageView new];
    [arrow setImage:[UIImage imageNamed:@"ec_comment_arrow"]];
    [self addSubview:arrow];
    
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.text.mas_right).with.offset(30);
        make.right.equalTo(self.mas_right).with.offset(-40);
        make.top.equalTo(self.mas_top).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.height.equalTo(@40);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        
    }];
    
}

- (void)click {
    if ([self.delegate respondsToSelector:@selector(didSelected)]) {
        [self.delegate didSelected];
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"CommentCellID";
    ECContactSelectedCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UserModel*model = self.datas[indexPath.row];
    cell.model = model;
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:model.photourl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
    return cell;
}

@end
