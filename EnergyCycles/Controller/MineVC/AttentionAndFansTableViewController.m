//
//  AttentionAndFansTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AttentionAndFansTableViewController.h"
#import "AttentionAndFansTableViewCell.h"

#import "UserModel.h"
#import "OtherUserModel.h"

@interface AttentionAndFansTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation AttentionAndFansTableViewController

// 懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView中cell的线条隐藏
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置标题与加载数据
    if (self.userId == NULL || [self.userId isEqualToString:[[NSNumberFormatter alloc] stringFromNumber:User_ID]]) {
        if (self.type == 1) {
            self.title = @"我的关注";
            [self getAttentionInfo];
        } else if (self.type == 2) {
            self.title = @"我的粉丝";
            [self getFansInfo];
        }
    } else {
        if (self.type == 1) {
            self.title = @"他的关注";
        } else {
            self.title = @"他的粉丝";
        }
        [self getUserIdAttentionOrFansInfo];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// 关注列表
- (void)getAttentionInfo {
    [[AppHttpManager shareInstance] getMyHeartWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                [self.dataArr addObject:model];
            }
            NSLog(@"%@",self.dataArr);
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

// 粉丝列表
- (void)getFansInfo {
    [[AppHttpManager shareInstance] getHeartMeWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                [self.dataArr addObject:model];
            }
        } else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

// 获取目标用户的关注或者粉丝列表
- (void)getUserIdAttentionOrFansInfo {
    [[AppHttpManager shareInstance] getGetFriendsListWithUid1:[self.userId intValue]
                                                         Uid2:[User_ID intValue]
                                                         Type:self.type
                                                    PostOrGet:@"get"
                                                      success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                OtherUserModel *model = [[OtherUserModel alloc] initWithDictionary:subDict error:nil];
                [self.dataArr addObject:model];
            }
        } else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
                                                          
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *attentionAndFansTableViewCell = @"attentionAndFansTableViewCell";
    AttentionAndFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionAndFansTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AttentionAndFansTableViewCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.userId == NULL || [self.userId isEqualToString:[[NSNumberFormatter alloc] stringFromNumber:User_ID]]) {
        if (self.type == 1) {
            UserModel *model = self.dataArr[indexPath.row];
            [cell getdateAttentionDataWithUserModel:model];
        } else if (self.type == 2) {
            UserModel *model = self.dataArr[indexPath.row];
            [cell getdateFansDataWithUserModel:model];
        }
    } else {
        OtherUserModel *model = self.dataArr[indexPath.row];
        [cell getdateDataWithOtherUserModel:model];
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
