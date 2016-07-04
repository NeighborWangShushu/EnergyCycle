//
//  PopColumView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PopColumView.h"
#import "Masonry.h"
#import "ColumCell.h"
#import "RecipeCollectionHeaderView.h"
#import "CategoryModel.h"

@interface PopColumView () {
    NSMutableArray * selectedData;
    NSMutableArray * otherData;
    BOOL isEdit;
}
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)NSMutableArray * texts;
@property (nonatomic,strong)UIButton * edit;

@end

@implementation PopColumView

- (instancetype)initWithData:(NSMutableArray*)data myColum:(NSMutableArray*)mdata{
    self = [super init];
    if (self) {
        otherData = [NSMutableArray arrayWithArray:mdata]; //标签
        self.texts = [NSMutableArray arrayWithArray:data]; //我的定制
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
    
    UILabel * title = [UILabel new];
    title.font = [UIFont systemFontOfSize:15];
    title.text = @"我的定制";
    title.textColor = [UIColor blackColor];
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@80);
    }];
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(35);
    }];
    
    self.edit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.edit setTitle:@"编辑" forState:UIControlStateNormal];
    [self.edit setTitle:@"完成" forState:UIControlStateSelected];
    [self.edit.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.edit.layer.borderColor = [UIColor colorWithRed:96.0/255.0 green:194.0/255.0 blue:237.0/255.0 alpha:1.0].CGColor;
    self.edit.layer.borderWidth = 0.5f;
    self.edit.layer.cornerRadius = 10.0f;
    [self.edit setTitleColor:[UIColor colorWithRed:96.0/255.0 green:194.0/255.0 blue:237.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.edit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.edit setTitleColor:[UIColor colorWithRed:96.0/255.0 green:194.0/255.0 blue:237.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    [self addSubview:self.edit];
    [self.edit addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    [self.edit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(closeButton.mas_left).with.offset(- 15);
        make.top.equalTo(closeButton.mas_bottom).with.offset(10);
        make.height.equalTo(@22);
        make.width.equalTo(@40);
    }];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionHeadersPinToVisibleBounds = NO;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout] ;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    self.collectionView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
    [self.collectionView registerClass:[ColumCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.collectionView registerClass:[ColumCell class] forCellWithReuseIdentifier:@"headerCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecipeCollectionHeaderView" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(100);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
    }];
}

#pragma mark action

- (void)editAction {
    NSLog(@"edit");
    isEdit = !isEdit;
    [self.edit setSelected:isEdit];
    [self.collectionView reloadData];
}

- (void)close {
    if ([self.delegate respondsToSelector:@selector(popColunView:didChooseColums:otherItems:)]) {
        [self.delegate popColunView:self didChooseColums:self.texts otherItems:otherData];
    }else {
        NSLog(@"未监听回调popColunView:didChooseColums:otherItems:");
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.texts count];
    }
    return otherData.count;
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(5.f, 0.0f, 5.f, 0.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(320, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%f",self.frame.size.width);
   return  CGSizeMake((self.frame.size.width - 68)/4, 40);
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}

- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return .3f;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    CategoryModel *text = [otherData objectAtIndex:fromIndexPath.item];
    [otherData removeObjectAtIndex:fromIndexPath.item];
    [self.texts insertObject:text atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
   
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEdit && indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"headerCell";
        CategoryModel * model = self.texts[indexPath.item];
        ColumCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.text.text = model.name;
        cell.tag = indexPath.row;
        cell.isEdit = isEdit;
        return cell;
    }else {
        static NSString *cellID = @"cellID";
        CategoryModel * model = otherData[indexPath.item];
        ColumCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.text.text = model.name;
        return cell;
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(7, 7, 15, 7);//分别为上、左、下、右
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.title.text = @"添加分类";
        reusableview = headerView;
        return reusableview;
        
    }
    return reusableview;
}

//返回头headerView的大小

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && isEdit) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            return;
        }else {
            [self.collectionView performBatchUpdates:^{
                [otherData addObject:[self.texts objectAtIndex:indexPath.item]];
                [self.texts removeObjectAtIndex:indexPath.item];
                NSIndexPath * toIndexPath = [NSIndexPath indexPathForRow:[otherData count] - 1 inSection:1];
                [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
            } completion:^(BOOL finished) {
                [self.collectionView reloadData];
            }];

        }
        return;
    }
    else if (indexPath.section == 0 || isEdit) {
        
        return;
    }
    [self.collectionView performBatchUpdates:^{
        CategoryModel * str = otherData[indexPath.item];
        NSIndexPath * toIndexPath = [NSIndexPath indexPathForRow:[self.texts count] inSection:0];
        [self.texts addObject:str];
        [otherData removeObjectAtIndex:indexPath.item];
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:toIndexPath];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}


@end
