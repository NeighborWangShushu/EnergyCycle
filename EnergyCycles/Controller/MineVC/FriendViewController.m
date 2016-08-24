//
//  FriendViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FriendViewController.h"
#import "AttentionAndFansTableViewCell.h"

#import "MineHomePageViewController.h"

@interface FriendViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation FriendViewController

// 懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)getData {
    [[AppHttpManager shareInstance] getBothHeartWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        [self.dataArr removeAllObjects];
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *dic in dict[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                [self.dataArr addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = @"我的社交圈";
    
    [self getData];
    // Do any additional setup after loading the view.
}

// 可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"备注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UserModel *model = self.dataArr[indexPath.row];
        [self addNoteName:model];
        // 实现相关的逻辑代码
        // ...
        // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
        tableView.editing = NO;
        // 不需要主动退出编辑模式，更新view的操作完成后就会自动退出编辑模式
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    return @[likeAction];
}

- (void)addNoteName:(UserModel *)model {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加备注名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入要添加的备注名";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        if ([textField.text isEqualToString:@""] || textField.text == nil) {
            [SVProgressHUD showImage:nil status:@"备注名不能为空" maskType:SVProgressHUDMaskTypeClear];
        } else {
            [[AppHttpManager shareInstance] getAddNoteNameWithuserId:[User_ID intValue] Token:User_TOKEN OuId:[model.use_id intValue] NoteName:textField.text PostOrGet:@"post" success:^(NSDictionary *dict) {
                if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                    [SVProgressHUD showImage:nil status:@"操作成功" maskType:SVProgressHUDMaskTypeClear];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getData];
                    });
                }else {
                    [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
                }
            } failure:^(NSString *str) {
                NSLog(@"%@", str);
            }];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *attentionAndFansTableViewCell = @"attentionAndFansTableViewCell";
    AttentionAndFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionAndFansTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AttentionAndFansTableViewCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserModel *model = self.dataArr[indexPath.row];
    [cell getdateFriendsDataWithUserModel:model];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
    UserModel *model = self.dataArr[indexPath.row];
    mineVC.userId = model.use_id;
    [self.navigationController pushViewController:mineVC animated:YES];
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
