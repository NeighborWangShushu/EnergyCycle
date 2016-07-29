//
//  NavMenuView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NavMenuView.h"
#import "Masonry.h"
#import "ECNavMenuCell.h"

@interface NavMenuView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * datas;
@end

@implementation NavMenuView

- (instancetype)initWithDatas:(NSArray *)datas {
    
    if (self == [super init]) {
        self.datas = datas;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    [self setup];
    
}

- (void)setup {
    
    UIImageView *bg = [UIImageView new];
    [bg setImage:[UIImage imageNamed:@"nav_menu_bg"]];
    [self addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
    NSInteger selectedIndex = [self getSelectedIndex];

    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ECNavMenuModel*model = self.datas[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(didSelected:item:)]) {
        [self.delegate didSelected:indexPath item:model];
    }
    
}

#pragma mark UITableViewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"cellId";
    ECNavMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECNavMenuCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    ECNavMenuModel*model = self.datas[indexPath.row];
    cell.text.text = model.name;
    cell.model = model;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas count];
}



#pragma mark Get

- (NSInteger)getSelectedIndex {
    for (int i = 0; i < self.datas.count; i++) {
        ECNavMenuModel*model = self.datas[i];
        if (model.isSelected) {
            return i;
        }
    }
    return 0;
}


@end
