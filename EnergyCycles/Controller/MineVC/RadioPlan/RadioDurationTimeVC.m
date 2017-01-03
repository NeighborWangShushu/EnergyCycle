//
//  RadioDurationTimeVC.m
//  EnergyCycles
//
//  Created by vj on 2017/1/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RadioDurationTimeVC.h"
#import "Masonry.h"
#import "RadioPlanCell.h"
#import "RadioClockModel.h"

@interface RadioDurationTimeVC ()<UITableViewDelegate,UITableViewDataSource,RadioPlanDelegate>

@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSArray *datas;
@property (nonatomic,strong)RadioClockModel * model;
@property (nonatomic,strong)RadioPlanCell * lastSelectedCell;

@end

@implementation RadioDurationTimeVC

#pragma mark - Navigation

- (void)leftAction {
  
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - GET

- (RadioClockModel*)model {
    
  if (!_model){
        _model = [[RadioClockModel alloc] init];
    }
    return _model;

}

- (NSArray*)datas {
    if (!_datas) {
        _datas = @[@"关闭",
                   @"10分钟",
                   @"20分钟",
                   @"30分钟",
                   @"40分钟",
                   @"50分钟",
                   @"60分钟"];
    }
    return _datas;
}


#pragma mark - init

- (void)setup {
    
    self.title = @"定时停止电台";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:245.0/255.0 alpha:1.0];

    NSArray * arr = [RadioClockModel findAll];
    if (!_model && arr.count > 0) {
        _model = [arr firstObject];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioPlanCell" bundle:nil] forCellReuseIdentifier:@"RadioPlanCellID"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.datas.count;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioPlanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RadioPlanCellID" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            [cell setStyle:RadioPlanCellStyleNormal];
            cell.text.text = _datas[indexPath.row];
            if (indexPath.row == self.model.duration) {
                cell.isChecked = YES;
                _lastSelectedCell = cell;
            }
            break;
        case 1:
            [cell setStyle:RadioPlanCellStyleSwitch];
            cell.text.text = @"重复";
            [cell setSwitchSelected:self.model.isRepeat];
            break;
            
        default:
            break;
    }
    
    cell.delegate = self;
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioPlanCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isChecked = YES;
    if (_lastSelectedCell) {
        _lastSelectedCell.isChecked = NO;
    }
    _lastSelectedCell = cell;
    self.model.duration = indexPath.row;
}

- (void)switchValueDidChange:(RadioPlanCell *)cell isSelected:(BOOL)selected {
    if (self.model) {
        self.model.isRepeat = selected;
        [self.model saveOrUpdate];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
