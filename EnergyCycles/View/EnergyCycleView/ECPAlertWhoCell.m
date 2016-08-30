//
//  ECPAlertWhoCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECPAlertWhoCell.h"
#import "ECContactSelectedCell.h"
#import "Masonry.h"

@interface ECPAlertWhoCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView * collectionView;

@end

@implementation ECPAlertWhoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
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
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.text.mas_right).with.offset(30);
        make.right.equalTo(self.mas_right).with.offset(-40);
        make.top.equalTo(self.mas_top).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.height.equalTo(@40);
    }];
    
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)alertAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didSelected)]) {
        [self.delegate didSelected];
    }
}
@end
