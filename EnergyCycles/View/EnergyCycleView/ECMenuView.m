//
//  ECMenuView.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/7/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECMenuView.h"
#import "Masonry.h"


@interface ECMenuView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ECMenuView

- (instancetype)initWithTypes:(NSArray *)types {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}


- (void)initialize {
    
    
    [self setup];
}

- (void)setup {
    
    UITableView * tableView   = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableView.delegate        = self;
    tableView.dataSource      = self;
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];

    
}


@end
