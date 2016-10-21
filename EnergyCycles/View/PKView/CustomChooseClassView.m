//
//  CustomChooseClassView.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CustomChooseClassView.h"

#import "CustomTableViewCell.h"

@interface CustomChooseClassView () <UITableViewDataSource,UITableViewDelegate> {
    UITableView *customTableView;
    NSMutableArray *_dataArr;
    
    NSString *chooseStr;
    NSString * chooseID;
    NSArray *titleArr;
}

@end

@implementation CustomChooseClassView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self showUI];
    }
    
    return self;
}

#pragma mark - 
- (void)showUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _dataArr=[NSMutableArray array];
 
    [self getCategpary];
    customTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Screen_Height/2+50, Screen_width, Screen_Height/2-50) style:UITableViewStylePlain];
    customTableView.dataSource = self;
    customTableView.delegate = self;
    customTableView.showsVerticalScrollIndicator = NO;
    customTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    customTableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:252/255.0 alpha:1];
    
    [self addSubview:customTableView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height/2, Screen_width, 50.f)];
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

#pragma  mark-- 获取分类
-(void)getCategpary{
     [[AppHttpManager shareInstance] getGetPostTypeWithPostOrGet:@"get" success:^(NSDictionary *dict) {
         if (dict) {
             for (NSDictionary * dic in dict[@"Data"]) {
                 [_dataArr addObject:dic];
             }
             [customTableView reloadData];
         }
     } failure:^(NSString *str) {
         NSLog(@"%@",str);
     }];
}

#pragma mark - UITableView 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
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
    if (_dataArr.count) {
        NSDictionary *dic=_dataArr[indexPath.row];
        cell.titleLabel.text=dic[@"Name"];
    }
    
    return cell;
}

#pragma mark - cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count == 0) {
        return;
    }
    for (NSInteger i=0; i<_dataArr.count; i++) {
        CustomTableViewCell *cell = [customTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        cell.rightGouImageView.image = [UIImage imageNamed:@""];
    }
    
    CustomTableViewCell *cell = [customTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    cell.titleLabel.textColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
    cell.rightGouImageView.image = [UIImage imageNamed:@"right.png"];
    if (_dataArr.count) {
        NSDictionary * dic=_dataArr[indexPath.row];
        chooseStr = dic[@"Name"];
        chooseID = [NSString stringWithFormat:@"%@",dic[@"Id"]];
    }
}

#pragma mark - 确定、取消_传值
- (void)chooseButtonClick:(UIButton *)btn {
    if (btn.tag != 2101) {
        if (_chooseClassStr) {
            _chooseClassStr(chooseStr.length>0?chooseStr:@" ",chooseID.length>0?chooseID:@" ");
        }
    }else {
        _chooseClassStr(@" ",@" ");
    }
}


@end
