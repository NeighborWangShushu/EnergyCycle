//
//  FriendViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "FriendViewController.h"
#import "AttentionAndFansTableViewCell.h"

#import "ECContactSearchBar.h"
#import "ECSearchDisplayController.h"

#import "MineHomePageViewController.h"

@interface FriendViewController ()<UIAlertViewDelegate, UISearchDisplayDelegate,UISearchBarDelegate,ECContactSearchBarDelegate> {
    BOOL isSearching;
}

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *allDataArr;

@property (nonatomic, strong) ECContactSearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation FriendViewController

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

- (void)getData {
    [[AppHttpManager shareInstance] getBothHeartWithUserid:@"25" PostOrGet:@"get" success:^(NSDictionary *dict) {
        [self.dataArr removeAllObjects];
        [self.allDataArr removeAllObjects];
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *dic in dict[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                [self.dataArr addObject:model];
                [self.allDataArr addObject:model];
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

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if (self.searchController.active) {
//        self.searchController.active = NO;
//        [self.searchController.searchBar removeFromSuperview];
//    }
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self createSearchResultsUpdating];
//    isSearching = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    // 关闭自动约束
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // TableView的分割线样式为None,作用为隐藏下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createSearchResultsUpdating];
    
    self.title = @"我的社交圈";
    
    [self getData];
    // Do any additional setup after loading the view.
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
    if (searchString == nil || [searchString isEqualToString:@""]) {
        isSearching = YES;
    } else {
        isSearching = NO;
    }
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


//// 创建搜索框
//- (void)createSearchResultsUpdating {
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.hidesNavigationBarDuringPresentation = NO;
//    [self.searchController.searchBar sizeToFit];
//    //    self.searchController.searchBar.backgroundColor = UIColor ;
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//}
//
//// 搜索协议方法
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSMutableArray *resultsArr = [NSMutableArray array];
//    for (int i = 0; i < self.allDataArr.count; i++) {
//        NSString *nickString = [(UserModel *)self.allDataArr[i] nickname];
//        
//        NSRange nickRange = NSMakeRange(0, nickString.length);
//        
//        NSRange foundRange = [nickString rangeOfString:self.searchController.searchBar.text options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch range:nickRange];
//        
//        if (foundRange.length) {
//            [resultsArr addObject:self.allDataArr[i]];
//        }
//    }
//    [self.dataArr removeAllObjects];
//    [self.dataArr addObjectsFromArray:resultsArr];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
//}

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
    UserModel *model = nil;
    if (isSearching) {
        model = self.allDataArr[indexPath.row];
    } else {
        model = self.dataArr[indexPath.row];
    }
    [cell getdateFriendsDataWithUserModel:model];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MineHomePageViewController *mineVC = MainStoryBoard(@"MineHomePageViewController");
    UserModel *model = nil;
    if (isSearching) {
        model = self.allDataArr[indexPath.row];
    } else {
        model = self.dataArr[indexPath.row];
    }
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
