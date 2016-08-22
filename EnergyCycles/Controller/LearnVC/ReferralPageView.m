//
//  ReferralView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ReferralPageView.h"
#import "BannerItem.h"
#import "Masonry.h"
#import "CCTalkCell.h"
#import "RadioCell.h"
#import "OtherCell.h"
#import "BannerCell.h"
#import "ReferralHeadView.h"
#import "ReferralModel.h"
#import "GifHeader.h"


@interface ReferralPageView ()<UITableViewDelegate,UITableViewDataSource,OtherCellDelegate,ReferralHeadViewDelegate> {
    NSMutableArray * banners;
}

@property (nonatomic,strong)UITableView * tableView;

@end

@implementation ReferralPageView

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    ReferralModel*model = [[ReferralModel alloc] initWithReferral:data radioData:_radioData];
    self.model = model;
    [banners removeAllObjects];
    for (BannerItem*item in self.model.banners) {
        [banners addObject:item.pic];
    }
    
    [self setup];
}

- (void)initialize {
    
    self.backgroundColor = [UIColor clearColor];
    banners  = [NSMutableArray new];
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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.estimatedRowHeight = 40.0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    self.tableView = tableView;
    self.tableView.mj_header = [GifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}

- (void)reloadData {
    [self.tableView.mj_header beginRefreshing];
}

//下拉刷新
- (void)loadNewData {
    [[AppHttpManager shareInstance] getAppRadioListPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            _radioData = dict;
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
        } else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
    
}

#pragma mark UITableViewDelegate



#pragma mark OtherCellDelegate 
- (void)otherCellView:(OtherCell *)cell didSelectedItem:(HealthModel *)model {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(referralSelected:) name:@"ReferralSelected" object:nil];
    
    NSMutableDictionary * postData = [NSMutableDictionary dictionary];
    [postData setObject:[NSString stringWithFormat:@"%ld",model.ID] forKey:@"id"];
    [postData setObject:model.course forKey:@"course"];
    [postData setObject:model.title forKey:@"title"];
    [postData setObject:[NSNumber numberWithBool:model.isVideo] forKey:@"type"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReferralSelected" object:nil userInfo:postData];
    
}


#pragma mark UITableViewDataSource

- (void)headView:(ReferralHeadView *)headview showMore:(NSString *)name {
    NSMutableDictionary * postData = [NSMutableDictionary dictionary];
    [postData setObject:name forKey:@"name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReferralHeadViewShowMore" object:nil userInfo:postData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * BANNERCELL = @"BANNERCELL";
    static NSString * RADIOCELL = @"RADIOCELL";
//    static NSString * CCTALKCell = @"CCTALKCell";
    static NSString * OTHERCELL = @"OTHERCELL";
    
    if (indexPath.section == 0) {
        BannerCell * cell0 = (BannerCell*)[tableView dequeueReusableCellWithIdentifier:BANNERCELL];
        if (!cell0) {
            cell0 =  [[[NSBundle mainBundle] loadNibNamed:@"BannerCell" owner:self options:nil] lastObject];
        }
        cell0.data = banners;
        cell0.items = self.model.banners;
        return cell0;
    }
    else if (indexPath.section == 1) {
        RadioCell * cell2 = (RadioCell*)[tableView dequeueReusableCellWithIdentifier:RADIOCELL];
        if (!cell2) {
            cell2 = [[[NSBundle mainBundle] loadNibNamed:@"RadioCell" owner:self options:nil] lastObject];
        }
        cell2.radios = self.model.radios;
        return cell2;
    }else{
        NSString * name = @"";
        OtherCell * cell3 = (OtherCell*)[tableView dequeueReusableCellWithIdentifier:OTHERCELL];
        if (!cell3) {
            cell3 = [[[NSBundle mainBundle] loadNibNamed:@"OtherCell" owner:self options:nil] lastObject];
        }
        cell3.delegate = self;
        NSDictionary * dic = self.model.health[indexPath.section - 2];
        name = [dic allKeys][0];
        cell3.healths = [dic objectForKey:name];
        return cell3;
    }
    return nil;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString*name = @"";
    ReferralHeadView * headview;
    headview = [[ReferralHeadView alloc] initWithName:name];
    headview.delegate = self;
    if(section == 1){
        headview.name = @"英文电台";
        headview.type = ReferralHeadViewTypeRadio;
    }else if (section == 0){
        headview.type = ReferralHeadViewTypeNone;
    }
    else {
        NSDictionary*model = self.model.health[section - 2];
        headview.name = [model allKeys][0];
        headview.type = ReferralHeadViewTypeOther;
    }
    
    return headview;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView*view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + [self.model.health count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


@end
