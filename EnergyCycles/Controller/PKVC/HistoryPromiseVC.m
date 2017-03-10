//
//  HistoryPromiseVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HistoryPromiseVC.h"
#import "HistoryPromiseCell.h"

@interface HistoryPromiseVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HistoryPromiseVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史目标";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    [self getData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    [[AppHttpManager shareInstance] getMyTargetListWithUserID:[User_ID integerValue] Type:2 PageIndex:0 PageSize:1000 PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSDictionary *dataDic = dict[@"Data"];
            for (NSDictionary *dic in dataDic) {
                PromiseModel *model = [[PromiseModel alloc] initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

#pragma mark - TablViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *historyPromiseCell = @"HistoryPromiseCell";
    HistoryPromiseCell *cell = [tableView dequeueReusableCellWithIdentifier:historyPromiseCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:historyPromiseCell owner:self options:nil].firstObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PromiseModel *model = self.dataArray[indexPath.row];
    [cell getDataWithModel:model];
    
    return cell;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
