//
//  ECContactSearchBar.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECContactSearchBar.h"
#import "Masonry.h"
#import "ECContactSelectedCell.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UITextField+WJ.h"

@interface ECContactSearchBar ()<UICollectionViewDelegate,UICollectionViewDataSource,WJTextFieldDelegate> {
    UITextField * searchField;
}


@property (nonatomic,strong)UICollectionView * collectionView;
@end


@implementation ECContactSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.searchBarStyle = UISearchBarStyleProminent;
        self.translucent = NO;
        
        [self setup];
        
    }
    return self;
}


- (void)layoutSubviews {
    
    NSInteger index = [self indexOfSearchTextfieldInSubviews];
    NSInteger backgroungIndex = [self indexOfSearchBackgroundInSubviews];
    if (index) {
        searchField = (UITextField*)((UIView*)self.subviews[0]).subviews[index];
        searchField.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        searchField.textColor = [UIColor lightGrayColor];
        UIView*background = (UIView*)((UIView*)self.subviews[0]).subviews[backgroungIndex];
        [background removeFromSuperview];
        
        searchField.leftView = self.collectionView;
        searchField.leftViewMode = UITextFieldViewModeAlways;
    }
    
}


- (void)setup {
   
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.itemSize = CGSizeMake(30, 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ECContactSelectedCell class] forCellWithReuseIdentifier:@"CommentCellID"];
    self.collectionView.allowsMultipleSelection = NO;//默认为NO,是否可以多选
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    
}

// ------------------------------------------------------------------------------------------
#pragma mark - Methods
// ------------------------------------------------------------------------------------------

- (void)setHasCentredPlaceholder:(BOOL)hasCentredPlaceholder
{
    _hasCentredPlaceholder = hasCentredPlaceholder;
    
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector])
    {
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&_hasCentredPlaceholder atIndex:2];
        [invocation invoke];
    }
}

- (void)setDatas:(NSMutableArray *)datas {
    _datas = datas;
    self.collectionView.frame = CGRectMake(0, 0, MIN(_datas.count, 6)*40 , 44);
    NSLog(@"%f",self.collectionView.frame.origin.y);
    [self.collectionView reloadData];
}

- (NSInteger)indexOfSearchTextfieldInSubviews {
    NSInteger index;
    UIView *searchBarView = (UIView*)self.subviews[0];
    for (int i = 0; i < searchBarView.subviews.count; i++) {
        if ([searchBarView.subviews[i] isKindOfClass:[UITextField class]]) {
            
            index = i;
            break;
        }
    }
    
    return index;
}

- (NSInteger)indexOfSearchBackgroundInSubviews {
    
    NSInteger index;
    UIView *searchBarView = (UIView*)self.subviews[0];
    
    for (int i = 0; i < searchBarView.subviews.count; i++) {
        if ([searchBarView.subviews[i] isKindOfClass:[UIView class]]) {
            
            index = i;
            break;
        }
    }
    
    return index;
    
}


- (void)textFieldDidChange:(NSNotification *)notification {
    
    [self unSelectedItems];

    
}
- (void)unSelectedItems {
    __weak typeof(self) weakSelf = self;
    [self.datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UserModel*model = weakSelf.datas[idx];
        model.readyToDelete = @"";
        [weakSelf.collectionView reloadData];
    }];

}


- (void)readyToDeleteItem {
    [self.collectionView reloadData];
}

- (void)deleteItem {
    UserModel*model = [self.datas lastObject];
    model.isSelected = @"";
    [self.datas removeLastObject];
    self.collectionView.frame = CGRectMake(0, 0, MIN(_datas.count, 6)*40 , 44);
    
    [self.collectionView reloadData];
    if ([self.edelegate respondsToSelector:@selector(contactSearchBar:model:isClear:)]) {
        [self.edelegate contactSearchBar:self model:model isClear:!self.datas.count];
    }
}

#pragma mark WJTextFieldDelegate

- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    if (textField.text.length == 0) {
        UserModel*model = [self.datas lastObject];
        if ([model.readyToDelete isEqualToString:@""]) {
            model.readyToDelete = @"readyToDelete";
            [self readyToDeleteItem];
        }else {
            model.readyToDelete = @"";
            [self deleteItem];
        }
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
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:model.pkImg] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
    return cell;
}


#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}



@end
