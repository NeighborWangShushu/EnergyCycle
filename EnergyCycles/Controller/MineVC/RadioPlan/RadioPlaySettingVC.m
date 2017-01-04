//
//  RadioPlaySettingVC.m
//  EnergyCycles
//
//  Created by vj on 2017/1/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RadioPlaySettingVC.h"
#import "Masonry.h"
#import "RadioPlanCell.h"
#import "RadioChooseItemVC.h"
#import "RadioSetTimeVC.h"
#import "RadioNotificationController.h"

@interface RadioPlaySettingVC ()<UITableViewDelegate,UITableViewDataSource,RadioPlanDelegate>

@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)RadioClockModel * model;
@property (nonatomic,strong)NSArray *datas;

@end

@implementation RadioPlaySettingVC

- (void)leftAction {
    self.model.weekday = 5;
    [RadioNotificationController add:self.model];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Init

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}


#pragma mark - GET

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


- (void)setup {
    self.title = @"定时播放电台";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelChanged:) name:@"RADIOPLAYSETTINGMODELCHANGED" object:nil];

    
    
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
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioPlanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RadioPlanCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            [cell setStyle:RadioPlanCellStyleSwitch model:self.model];
            cell.text.text = @"功能开启";
            cell.delegate = self;
        break;
        case 1:
            [cell setStyle:RadioPlanCellStyleTime model:self.model];
            cell.text.text = @"时间";
            
            break;
        case 2:
            [cell setStyle:RadioPlanCellStyleRadio model:self.model];
            cell.text.text = @"电台";
            
            break;
        default:
            break;
    }
    
    cell.delegate = self;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}


#pragma mark - UITableViewDelegate

- (void)switchValueDidChange:(RadioPlanCell *)cell isSelected:(BOOL)selected {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
        {
            RadioSetTimeVC * vc = [[RadioSetTimeVC alloc] initWithModel:self.model];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            RadioChooseItemVC * vc = [[RadioChooseItemVC alloc] initWithItemType:RadioChooseItemTypeRadio];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - Notification 

- (void)modelChanged:(NSNotification*)notification {
    
    self.model = [RadioClockModel findByPK:self.model.pk];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
