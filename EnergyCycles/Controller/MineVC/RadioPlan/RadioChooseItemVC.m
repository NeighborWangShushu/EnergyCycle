//
//  RadioChooseItemVC.m
//  EnergyCycles
//
//  Created by vj on 2017/1/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RadioChooseItemVC.h"
#import "RadioPlanCell.h"
#import "Masonry.h"

@interface RadioChooseItemVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSArray * datas;
@property (nonatomic)RadioChooseItemType type;

//选中的时间
@property (nonatomic,strong)NSMutableArray * selectedDates;

//选择电台  上一次选中的cell
@property (nonatomic,strong)RadioPlanCell * lastSelectedCell;

@end

@implementation RadioChooseItemVC

#pragma mark - GET 

- (NSMutableArray*)selectedDates {
    if (!_selectedDates) {
        if (![self.model.weekdaysToString isEqualToString:@""]) {
            _selectedDates = [NSMutableArray arrayWithArray:[self.model.weekdaysToString componentsSeparatedByString:@","]];
        }else {
            _selectedDates = [NSMutableArray array];
        }
    }
    return _selectedDates;
}

- (NSArray*)datas {
    if (!_datas) {
        switch (self.type) {
            case RadioChooseItemTypeRadio:
                _datas = @[@"BBC",
                           @"CNN",
                           @"FOX News",
                           @"NPR",
                           @"Radio Australia",
                           @"Ted",
                           @"LBC",
                           @"VOA",
                           @"JPR"];
                break;
            case RadioChooseItemTypeDuration:
                _datas = @[@"星期日",
                           @"星期一",
                           @"星期二",
                           @"星期三",
                           @"星期四",
                           @"星期五",
                           @"星期六"
                           ];

                break;
            default:
                break;
        }    }
    return _datas;
}

- (NSString*)getTitle {
    NSString * title = @"";
    switch (self.type) {
        case RadioChooseItemTypeRadio:
            title = @"选择电台";
            break;
        case RadioChooseItemTypeDuration:
            title = @"选择时间";
            break;
        default:
            break;
    }
    return title;
}

- (RadioClockModel*)model {
    
    if (!_model){
        NSArray * arr = [RadioClockModel findAll];
        if (arr.count > 0) {
            _model = [arr firstObject];
        }else {
            _model = [[RadioClockModel alloc] init];
        }
    }
    return _model;
}

#pragma mark - Init

- (instancetype)initWithItemType:(RadioChooseItemType)type {
    self = [super init];
    if (self) {
        self.type = type;
        [self setupWithType:type];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupWithType:(RadioChooseItemType)type {
    
    self.title = [self getTitle];
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioPlanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RadioPlanCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setStyle:RadioPlanCellStyleNormal model:self.model];
    if (self.type == RadioChooseItemTypeDuration) {
        __block NSString * index = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
      [self.selectedDates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          NSString * value = [self.selectedDates objectAtIndex:idx];
          if ([index isEqualToString:value]) {
              [cell setIsChecked:YES];
          }
      }];
    }else {
        if ([self.model.channelName isEqualToString:self.datas[indexPath.row]]) {
            [cell setIsChecked:YES];
            _lastSelectedCell = cell;
        }
    }
    cell.text.text = [self.datas objectAtIndex:indexPath.row];
    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioPlanCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.type == RadioChooseItemTypeDuration) {
        [cell setIsChecked:!cell.isChecked];
        if (cell.isChecked) {
            [self.selectedDates addObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        }else {
            [self.selectedDates removeObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        }
        NSLog(@"%@",self.selectedDates);
        self.model.weekdays = self.selectedDates;
    }else {
        if (_lastSelectedCell) {
            [_lastSelectedCell setIsChecked:NO];
        }
        [cell setIsChecked:YES];
        _lastSelectedCell = cell;
        self.model.channelName = [_datas objectAtIndex:indexPath.row];
    }
}


#pragma mark - Actions

- (void)leftAction {
    
    [self.model saveOrUpdate];
    if (self.type == RadioChooseItemTypeDuration) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RADIOPLAYSETTINGTIMECHANGED" object:nil];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RADIOPLAYSETTINGMODELCHANGED" object:nil];
    }
    //通知RadioPlaySettingVC 刷新列表
    [self.navigationController popViewControllerAnimated:YES];
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
