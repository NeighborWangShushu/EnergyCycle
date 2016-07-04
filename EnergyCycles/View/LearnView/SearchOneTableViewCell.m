//
//  SearchOneTableViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SearchOneTableViewCell.h"

#import "SearchCollectionViewCell.h"
#import "LoadMoreCollectionCell.h"
#import "ReCiModel.h"
#import "FenLeiModel.h"

@interface SearchOneTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    NSMutableArray *_dataArr;
    NSMutableArray *_subDataArr;
    NSMutableArray * _historyArr;
    NSInteger showType;
    BOOL isLoadMore;
}

@end

@implementation SearchOneTableViewCell

- (void)awakeFromNib {
    _dataArr = [[NSMutableArray alloc] init];
    _subDataArr = [[NSMutableArray alloc] init];
    _historyArr = [NSMutableArray array];
    
 
    UICollectionViewFlowLayout *showBackLayout = [[UICollectionViewFlowLayout alloc] init];
    [showBackLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    showBackLayout.minimumInteritemSpacing = .0f;
    showBackLayout.minimumLineSpacing = .0f;
    
    self.searchCollectionView.collectionViewLayout = showBackLayout;
    self.searchCollectionView.backgroundColor = [UIColor whiteColor];
    self.searchCollectionView.dataSource = self;
    self.searchCollectionView.delegate = self;
    [self.searchCollectionView registerNib:[UINib nibWithNibName:@"SearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SearchCollectionViewCellId"];
    [self.searchCollectionView registerClass:[LoadMoreCollectionCell class] forCellWithReuseIdentifier:@"LoadMoreCollectionCell"];
    self.searchCollectionView.showsHorizontalScrollIndicator = NO;
    self.searchCollectionView.bounces = NO;
    self.searchCollectionView.pagingEnabled = NO;
    
    
}

#pragma mark - 获取网络数据
- (void)updateWithType:(NSInteger)type {
    showType = type;
    if (type == 0) {
        [self getHistoryData];
    }else {
        [self getReCiData];
    }
}


- (void)getHistoryData {
    [_historyArr removeAllObjects];
    isLoadMore = NO;
    NSDictionary *hisDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchDict"];
    NSArray *hisArr = hisDict[@"searchArr"];
    if ([hisArr count] < 3) {
        for (NSString *str in hisArr) {
            [_historyArr addObject:str];
        }
    }else {
        for (int i = 0; i < 2; i++) {
            [_historyArr addObject:hisArr[i]];
        }
    }
    [self.searchCollectionView reloadData];
    
}


- (void)getAllHistoryData {
    [_historyArr removeAllObjects];
    NSDictionary *hisDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchDict"];
    NSArray *hisArr = hisDict[@"searchArr"];
    for (NSString *str in hisArr) {
        NSLog(@"%@",str);
        [_historyArr addObject:str];
    }
    [self.searchCollectionView reloadData];
}

- (void)clearHistoryData {
    [_historyArr removeAllObjects];
    NSMutableDictionary *searchDict = [[NSMutableDictionary alloc] init];
    [searchDict setObject:_historyArr forKey:@"searchArr"];
    [[NSUserDefaults standardUserDefaults] setObject:searchDict forKey:@"SearchDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.searchCollectionView reloadData];

}

#pragma mark - 获取热词
- (void)getReCiData {
    [[AppHttpManager shareInstance] getGetHotSearchWithPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [_dataArr removeAllObjects];
            for (NSDictionary *subDict in dict[@"Data"]) {
                ReCiModel *model = [[ReCiModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            [self.searchCollectionView reloadData];

        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 获取分类
- (void)getFenLeiData {
    [[AppHttpManager shareInstance] getGetStudyTypeWithPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [_subDataArr removeAllObjects];
            for (NSDictionary *subDict in dict[@"Data"]) {
                FenLeiModel *model = [[FenLeiModel alloc] initWithDictionary:subDict error:nil];
                [_subDataArr addObject:model];
            }
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 实现UIcollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (showType == 0) {
        if ([_historyArr count] > 0) {
            return [_historyArr count] + 1;
        }
        return _historyArr.count;
    }
    return _dataArr.count;
}

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (showType == 0) {
        return CGSizeMake(Screen_width, 45);
    }

    return CGSizeMake(Screen_width/2, 45);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SearchCollectionViewCellId = @"SearchCollectionViewCellId";
    SearchCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchCollectionViewCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCollectionViewCell" owner:self options:nil] lastObject];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    if (showType == 0) {
        if (indexPath.row == [_historyArr count] && [_historyArr count] > 0) {
            LoadMoreCollectionCell * mcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LoadMoreCollectionCell" forIndexPath:indexPath];
            if (isLoadMore) {
                mcell.text.text = @"清除浏览记录";
            }else {
                mcell.text.text = @"加载更多记录";
            }
            return mcell;
        }else {
            NSString*model = _historyArr[indexPath.row];
            cell.showLabel.text = model;
            cell.rightLine.hidden = YES;
        }
        
    }else {
            ReCiModel *model = (ReCiModel *)_dataArr[indexPath.row];
            cell.showLabel.text = model.word;
            cell.historyImg.hidden = YES;
            if (indexPath.item % 2 != 0) {
                cell.rightLine.hidden = YES;
            }
    }
    
    return cell;
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (showType == 1) {

        if (_dataArr.count) {
            ReCiModel *model = (ReCiModel *)_dataArr[indexPath.row];
            if (_searchCollectionTouch) {
                _searchCollectionTouch(model.word,1);
            }
        }
    }else {
        NSLog(@"indexrow:%ld-----historycount%ld",[indexPath row],[_historyArr count]);
        if (_historyArr.count < 3 && !isLoadMore && indexPath.row == _historyArr.count) {
            //点击了加载更多
            isLoadMore = YES;
            [self getAllHistoryData];
            
        }else if(indexPath.row == [_historyArr count] && isLoadMore) {
            //清除历史记录
            isLoadMore = NO;
            [self clearHistoryData];
            if (_cleanHistory) {
                _cleanHistory(isLoadMore);
            }
            
        }else {
            NSString *model = _historyArr[indexPath.row];
            if (_searchCollectionTouch) {
                _searchCollectionTouch(model,2);
            }
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
