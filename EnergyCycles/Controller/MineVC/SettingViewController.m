//
//  SettingViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SettingViewController.h"

#import "SettingOneViewCell.h"
#import "SettingTwoViewCell.h"
#import "SettingThreeViewCell.h"

@interface SettingViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *settingOneArray;
@property (nonatomic, strong) NSMutableArray *settingTwoArray;
@property (nonatomic, strong) NSMutableArray *settingThreeArray;
@property (nonatomic, strong) NSMutableArray *settingFourArray;

@end

@implementation SettingViewController

// 分区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

// 行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

// 分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataArray count];
}

// 每个分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"reuse";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
 
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settingOneArray = [[NSMutableArray alloc] initWithObjects:@"个人资料", @"账户管理", @"我的能量源", nil];
    _settingTwoArray = [[NSMutableArray alloc] initWithObjects:@"消息推送", nil];
    _settingThreeArray = [[NSMutableArray alloc] initWithObjects:@"清理缓存", @"意见反馈", @"关于能量圈", nil];
    _settingFourArray = [[NSMutableArray alloc] initWithObjects:@"退出当前账号", nil];
    _dataArray = [[NSMutableArray alloc] initWithObjects:_settingOneArray, _settingTwoArray, _settingThreeArray, _settingFourArray, nil];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    
    // 协议
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // 分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor blackColor];
    
    // 添加
    [self.view addSubview:tableView];
    
    
    // Do any additional setup after loading the view.
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
