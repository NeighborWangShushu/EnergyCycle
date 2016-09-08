//
//  AttentionAndFansTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "AttentionAndFansTableViewController.h"
#import "MineHomePageViewController.h"

#import "AttentionAndFansTableViewCell.h"

#import "ECContactSearchBar.h"
#import "ECSearchDisplayController.h"

#import "UserModel.h"
#import "OtherUserModel.h"
#import "GifHeader.h"

@interface AttentionAndFansTableViewController ()<UISearchDisplayDelegate,UISearchBarDelegate,ECContactSearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *allDataArr;

@property (nonatomic, strong) ECContactSearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation AttentionAndFansTableViewController

// 懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)allDataArr {
    if (!_allDataArr) {
        self.allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----刷新-----

- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        // 设置标题与加载数据
        if (self.userId == NULL || [self.userId isEqualToString:[NSString stringWithFormat:@"%@", User_ID]]) {
            if (self.type == 1) {
                self.title = @"我的关注";
                [weakSelf getAttentionInfo];
            } else if (self.type == 2) {
                self.title = @"我的粉丝";
                [weakSelf getFansInfo];
            }
        } else {
            if (self.type == 1) {
                self.title = @"他的关注";
            } else {
                self.title = @"他的粉丝";
            }
            [weakSelf getUserIdAttentionOrFansInfo];
        }
    }];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)judge {
    // 设置标题与加载数据
    if (self.userId == NULL || [self.userId isEqualToString:[NSString stringWithFormat:@"%@", User_ID]]) {
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
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if (self.searchController.active) {
//        self.searchController.active = NO;
//        [self.searchController.searchBar removeFromSuperview];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftNavBarWithimage:@"loginfanhui"];

    // 关闭自动约束
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置tableView中cell的线条隐藏
    // TableView的分割线样式为None,作用为隐藏下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createSearchResultsUpdating];
    
    [self judge];
    
    [self setUpMJRefresh];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark -----搜索框------

// 创建搜索框
- (void)createSearchResultsUpdating {
    _searchBar = [[ECContactSearchBar alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 44)];
    _searchBar.delegate = self;
    _searchBar.edelegate = self;
    _searchBar.hasCentredPlaceholder = NO;
    _searchBar.backgroundColor = [UIColor whiteColor];
    [_searchBar setPlaceholder:@"搜索"];
    [_searchBar setContentMode:UIViewContentModeLeft];
    [_searchBar.layer setBorderWidth:0.5];
    [_searchBar.layer setBorderColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1].CGColor];
    [_searchBar setDelegate:self];
    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
    [_searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;
    
    _searchController = [[ECSearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
    _searchController.displaysSearchBarInNavigationBar = NO;
    _searchController.delegate = self;
    _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchController.searchContentsController.view.backgroundColor = [UIColor whiteColor];
    _searchController.searchResultsTableView.tableFooterView = [UIView new];
    _searchController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    [_searchController.searchBar sizeToFit];
    _searchController.searchResultsTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 2.0f, 0.0f);
    
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [_searchBar setShowsCancelButton:YES animated:NO];
    UIView *topView = controller.searchBar.subviews[0];
    controller.searchResultsTableView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    for (UIView *view in topView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            [view removeFromSuperview];
        }
    }
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    for (UIView *subview in tableView.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewWrapperView"]) {
            subview.frame = CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height);
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchController.searchBar text] scope:[[self.searchController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchController.searchBar scopeButtonTitles] objectAtIndex:[self.searchController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSMutableArray *resultsArr = [NSMutableArray array];
    for (int i = 0; i < self.allDataArr.count; i++) {
        NSString *nickString = [(UserModel *)self.allDataArr[i] nickname];
        
        NSRange nickRange = NSMakeRange(0, nickString.length);
        
        NSRange foundRange = [nickString rangeOfString:self.searchController.searchBar.text options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch range:nickRange];
        
        if (foundRange.length) {
            [resultsArr addObject:self.allDataArr[i]];
        }
    }
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:resultsArr];
}

#pragma mark -----获取数据-----

// 关注列表
- (void)getAttentionInfo {
    [[AppHttpManager shareInstance] getMyHeartWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self.dataArr removeAllObjects];
            [self.allDataArr removeAllObjects];
            
            for (NSDictionary *subDict in dict[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                [self.dataArr addObject:model];
                [self.allDataArr addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endRefresh];
                [self.tableView reloadData];
            });
        } else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@", str);
    }];
}

// 粉丝列表
- (void)getFansInfo {
    [[AppHttpManager shareInstance] getHeartMeWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            
            [self.dataArr removeAllObjects];
            [self.dataArr removeAllObjects];
            
            for (NSDictionary *subDict in dict[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                [self.dataArr addObject:model];
                [self.allDataArr addObject:model];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self endRefresh];
                    [self.tableView reloadData];
                });
            }
        } else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
        

    } failure:^(NSString *str) {
        [self endRefresh];
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
            
            [self.dataArr removeAllObjects];
            [self.allDataArr removeAllObjects];
            
            for (NSDictionary *subDict in dict[@"Data"]) {
                OtherUserModel *model = [[OtherUserModel alloc] initWithDictionary:subDict error:nil];
                [self.dataArr addObject:model];
                [self.allDataArr addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endRefresh];
                [self.tableView reloadData];
            });
        } else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
                                                          
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@",str);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -----TableView协议方法-----

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
    if (self.userId == NULL || [self.userId isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
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

// 点击协议方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
    if (self.userId == NULL || [self.userId isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
        UserModel *model = self.dataArr[indexPath.row];
        mineVC.userId = model.use_id;
    } else {
        OtherUserModel *model = self.dataArr[indexPath.row];
        mineVC.userId = model.userId;
    }
    [self.navigationController pushViewController:mineVC animated:YES];
}

#pragma mark -----备注名-----

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
                        [self judge];
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
