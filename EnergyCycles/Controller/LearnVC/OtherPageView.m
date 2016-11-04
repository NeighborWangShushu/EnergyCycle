//
//  OtherPageView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "OtherPageView.h"
#import "Masonry.h"
#import "OtherCell.h"
#import "GifHeader.h"

@interface OtherPageView ()<UITableViewDelegate,UITableViewDataSource,OtherCellDelegate>

@property (nonatomic,strong)UITableView*tableView;
@end


@implementation OtherPageView

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        ReferralModel*model = [[ReferralModel alloc] initWithHot:data];
        self.model = model;
        [self setup];
        
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    ReferralModel*model = [[ReferralModel alloc] initWithHot:data];
    self.model = model;
    [self setup];
    
}

- (void)reloadData {
    [self.tableView.mj_header beginRefreshing];
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

- (void)otherCellView:(OtherCell *)cell didSelectedItem:(HealthModel *)model {
    NSMutableDictionary * postData = [NSMutableDictionary dictionary];
    [postData setObject:[NSString stringWithFormat:@"%ld",model.ID] forKey:@"id"];
    [postData setObject:model.course forKey:@"course"];
    [postData setObject:model.title forKey:@"title"];
    [postData setObject:model.pic forKey:@"pic"];
    [postData setObject:[NSNumber numberWithBool:model.isVideo] forKey:@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReferralSelected" object:nil userInfo:postData];
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }else {
        return 30;
    }
}

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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self.model.health count] * 100;
//}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


@end
