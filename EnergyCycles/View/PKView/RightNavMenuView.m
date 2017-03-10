//
//  RightNavMenuView.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RightNavMenuView.h"
#import "RightNavMenuCell.h"
#import "Masonry.h"

@interface RightNavMenuView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation RightNavMenuView

- (instancetype)initWithDataArray:(NSArray *)dataArray {
    
    if (self == [super init]) {
        self.dataArray = dataArray;
        [self setup];
    }
    
    return self;
    
}

- (void)setup {
    
    self.bgView = [UIView new];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(@5);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.5;
    
    UIView *topView = [UIView new];
    [self.bgView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.top.equalTo(@-5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    topView.transform = CGAffineTransformMakeRotation(45 * (M_PI / 180.0f));
    topView.layer.cornerRadius = 1.5;
    topView.backgroundColor = [UIColor blackColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(10);
        make.right.equalTo(self.bgView.mas_right).with.offset(-10);
        make.top.equalTo(self.bgView.mas_top).with.offset(10);
        make.bottom.equalTo(self.bgView.mas_bottom).with.offset(-10);
    }];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 2);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelected:)]) {
        [self.delegate didSelected:indexPath];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *rightNavMenuCell = @"RightNavMenuCell";
    RightNavMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:rightNavMenuCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:rightNavMenuCell owner:self options:nil].firstObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RightNavMenuModel *model = self.dataArray[indexPath.row];
    [cell getDataWithModel:model];
    if ((indexPath.row + 1) != self.dataArray.count) {
        [cell lineView];
    }
    
    return cell;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
