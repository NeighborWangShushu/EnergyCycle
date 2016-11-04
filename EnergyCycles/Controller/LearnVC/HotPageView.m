//
//  HotPageViewController.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HotPageView.h"
#import "OtherCell.h"
#import "Masonry.h"
#import "ReferralModel.h"
#import "GifHeader.h"


@interface HotPageView ()<UITableViewDelegate,UITableViewDataSource,OtherCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation HotPageView

- (void)setData:(NSDictionary *)data {
    _data = data;
    ReferralModel*model = [[ReferralModel alloc] initWithHot:_data];
    self.model = model;
    [self setup];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
}


- (void)setup {
    if (self.tableView) {
        [self.tableView reloadData];
        return;
    }
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelection = NO;
    tableView.estimatedRowHeight = 40.0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    self.tableView = tableView;
    self.tableView.mj_header = [GifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}

- (void)reloadData {
    [self.tableView.mj_header beginRefreshing];
}

//下拉刷新
- (void)loadNewData {
    [[AppHttpManager shareInstance] getSearchWithTypes:self.postType withContent:self.type PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self setData:dict];
            [self.tableView.mj_header endRefreshing];
            
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }else {
        return 40;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//   return [self.model.health count] * 87;
//}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * OTHERCELL = @"OTHERCELL";
    
    OtherCell * cell3 = (OtherCell*)[tableView dequeueReusableCellWithIdentifier:OTHERCELL];
        if (!cell3) {
            cell3 = [[[NSBundle mainBundle] loadNibNamed:@"OtherCell" owner:self options:nil] lastObject];
        }
    cell3.delegate = self;
    cell3.healths = self.model.health;
    return cell3;
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark OtherCellDelegate

- (void)otherCellView:(OtherCell *)cell didSelectedItem:(HealthModel *)model {
    
    NSMutableDictionary * postData = [NSMutableDictionary dictionary];
    [postData setObject:[NSString stringWithFormat:@"%ld",model.ID] forKey:@"id"];
    [postData setObject:model.course forKey:@"course"];
    [postData setObject:model.title forKey:@"title"];
    [postData setObject:model.pic forKey:@"pic"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReferralSelected" object:nil userInfo:postData];
}

@end
