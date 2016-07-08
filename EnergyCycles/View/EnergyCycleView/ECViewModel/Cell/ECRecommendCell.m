//
//  ECRecommendCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECRecommendCell.h"
#import "Masonry.h"
#import "CommentCollectionCell.h"
#import "CommentUserModel.h"

@interface ECRecommendCell ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
}
@property (nonatomic,strong)UICollectionView * collectionView;


@end

@implementation ECRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setDatas:(NSMutableArray *)datas {
    _datas = datas;
    [self.collectionView reloadData];
}

- (void)setup {
    
    UILabel * title = [UILabel new];
    title.text = @"推荐用户";
    title.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
    title.font = [UIFont systemFontOfSize:18];
    [self addSubview:title];
    
    UIImageView * arrow = [UIImageView new];
    [arrow setImage:[UIImage imageNamed:@"ec_comment_arrow"]];
    [self addSubview:arrow];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.itemSize = CGSizeMake(66, 86);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[CommentCollectionCell class] forCellWithReuseIdentifier:@"CommentCellID"];
    self.collectionView.allowsMultipleSelection = NO;//默认为NO,是否可以多选
    [self addSubview:self.collectionView];
    
    UIView * bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    [self addSubview:bottomView];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(10);
    }];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(10);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(title.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"CommentCellID";
    CommentCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    CommentUserModel * model = [self.datas objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
