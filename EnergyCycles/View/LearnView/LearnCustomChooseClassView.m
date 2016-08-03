//
//  CustomChooseClassView.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LearnCustomChooseClassView.h"

#import "CustomTableViewCell.h"

@interface LearnCustomChooseClassView () <UITableViewDataSource,UITableViewDelegate> {
    UITableView *customTableView;
    
    NSString *chooseStr;
    NSArray *titleArr;
    NSInteger showType;
}

@end

@implementation LearnCustomChooseClassView

- (instancetype)initWithFrame:(CGRect)frame WithType:(NSInteger)type {
    self = [super initWithFrame:frame];
    if (self) {
        showType = type;
        [self showUI];
    }
    
    return self;
}

#pragma mark - 
- (void)showUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    titleArr = @[@"老学员介绍",@"网络搜索",@"摩英教育微信公众号",@"微信朋友圈",@"APP",@"其它"];
    if (showType == 2) {
        titleArr = @[@"父亲",@"母亲",@"本人",@"其它"];
    }
    
    customTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Screen_Height/2+50+80*(showType-1), Screen_width, Screen_Height/2-50-80*(showType-1)) style:UITableViewStylePlain];
    customTableView.dataSource = self;
    customTableView.delegate = self;
    customTableView.showsVerticalScrollIndicator = NO;
    customTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    customTableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:252/255.0 alpha:1];
    
    [self addSubview:customTableView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height/2+80*(showType-1), Screen_width, 50.f)];
    backView.backgroundColor = [UIColor whiteColor];
    NSArray *btnTitleArr = @[@"取消",@"确定"];
    for (NSInteger i=0; i<btnTitleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0+(Screen_width-60)*i, 0, 60, 50);
        
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
        }
        btn.tag = 2101 + i;
        [btn addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backView addSubview:btn];
    }
    [self addSubview:backView];
}

#pragma mark - UITableView 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (showType == 2) {
        return 4;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomTableViewCellId = @"CustomTableViewCellId";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil].lastObject;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = titleArr[indexPath.row];
    
    return cell;
}

#pragma mark -
- (void)chooseButtonClick:(UIButton *)btn {
    if (btn.tag != 2101) {
        if (_chooseClassStr) {
            _chooseClassStr(chooseStr.length>0?chooseStr:@" ",showType);
        }
    }else {
        _chooseClassStr(@" ",showType);
    }
}

#pragma mark - cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (NSInteger i=0; i<titleArr.count; i++) {
        CustomTableViewCell *cell = [customTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        cell.rightGouImageView.image = [UIImage imageNamed:@""];
    }
    
    CustomTableViewCell *cell = [customTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    cell.titleLabel.textColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    cell.rightGouImageView.image = [UIImage imageNamed:@"right.png"];
    chooseStr = titleArr[indexPath.row];
}


@end
