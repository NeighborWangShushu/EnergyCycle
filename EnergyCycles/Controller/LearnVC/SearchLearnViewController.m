//
//  SearchLearnViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SearchLearnViewController.h"

#import "SearchOneTableViewCell.h"
#import "SearchTwoTableViewCell.h"

#import "SearchResultsViewController.h"

@interface SearchLearnViewController () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource> {
    UIButton *rightButton;
    UISearchBar *mySearchBar;
    
    NSMutableArray *_historyArr;
    
    NSString *type;
    NSString *searchStr;
    BOOL _isLoadMore;
}

@end

@implementation SearchLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchTableView.showsHorizontalScrollIndicator = NO;
    searchTableView.showsVerticalScrollIndicator = NO;
    searchTableView.backgroundColor = [UIColor whiteColor];
    
    _historyArr = [[NSMutableArray alloc] init];
    
    [self setupLeftNavBarWithTitle:@""];
    
    //
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(12, 0, Screen_width-63-12, 44)];
    mySearchBar.searchBarStyle = UISearchBarStyleMinimal;
    mySearchBar.barTintColor = [UIColor grayColor];
    mySearchBar.delegate = self;
    [self.navigationController.navigationBar addSubview:mySearchBar];
    [_historyArr removeAllObjects];
    _historyArr = [NSMutableArray array];
    NSDictionary *hisDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchDict"];
    NSArray *hisArr = hisDict[@"searchArr"];
    for (NSString *str in hisArr) {
        [_historyArr addObject:str];
    }
    if (_historyArr.count) {
        [searchTableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [mySearchBar removeFromSuperview];
    mySearchBar = nil;
}

- (void)leftAction {
}

#pragma mark - 返回按键
- (void)rightAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [mySearchBar removeFromSuperview];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 实现搜索框代理事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    for (NSInteger i=0; i<_historyArr.count; i++) {
        if ([_historyArr[i] isEqualToString:searchBar.text]) {
            [_historyArr removeObjectAtIndex:i];
        }
    }
    [_historyArr insertObject:searchBar.text atIndex:0];
    if (_historyArr.count >= 10) {
        NSMutableArray *subArr = [[NSMutableArray alloc] init];
        for (NSInteger i=9; i>=0; i--) {
            [subArr addObject:_historyArr[i]];
        }
        [_historyArr removeAllObjects];
        for (NSString *str in subArr) {
            [_historyArr addObject:str];
        }
    }
    //将搜索历史记录保存到本地
    NSMutableDictionary *searchDict = [[NSMutableDictionary alloc] init];
    [searchDict setObject:_historyArr forKey:@"searchArr"];
    [[NSUserDefaults standardUserDefaults] setObject:searchDict forKey:@"SearchDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //
    type = @"2";
    searchStr = searchBar.text;
    [self performSegueWithIdentifier:@"SearchViewToSearchDetailView" sender:nil];
}

#pragma mark - UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    return _historyArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 155.f;
    }
    if (_isLoadMore) {
        return ([_historyArr count] > 0?[_historyArr count] + 1 : 0) * 45;
    }else {
        return ([_historyArr count] > 0?MIN([_historyArr count], 2) + 1 : 0) * 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        static NSString *SearchOneTableViewCellId = @"SearchOneTableViewCellId";
        SearchOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchOneTableViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SearchOneTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateWithType:indexPath.section];
        
        [cell setSearchCollectionTouch:^(NSString *str, NSInteger index) {
            type = [NSString stringWithFormat:@"%ld",(long)index];
            searchStr = str;
            [self performSegueWithIdentifier:@"SearchViewToSearchDetailView" sender:nil];
        }];
        
        [cell setCleanHistory:^(BOOL isLoadMore){
            _isLoadMore = isLoadMore;
            [_historyArr removeAllObjects];
            [searchTableView reloadData];
        }];
        
        return cell;
    }
    
    static NSString *SearchTwoTableViewCellId = @"SearchTwoTableViewCellId";
    SearchTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchTwoTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SearchTwoTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_historyArr.count) {
        cell.titleLabel.text = _historyArr[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        type = @"2";
        searchStr = _historyArr[indexPath.row];
        [self performSegueWithIdentifier:@"SearchViewToSearchDetailView" sender:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50.f;
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *oneBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 50)];
        oneBackView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 100, 20)];
        label.textColor = [UIColor blackColor];
        label.text = @"热门搜索";
        [oneBackView addSubview:label];
        
        UIImageView*hot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot"]];
        [hot setFrame:CGRectMake(15, 15, 25, 12)];
        [oneBackView addSubview:hot];
        
        return oneBackView;
    }

    return [UIView new];
//    else {
//        UIView *thrBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 50)];
//        thrBackView.backgroundColor = [UIColor whiteColor];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
//        label.textColor = [UIColor blackColor];
//        label.text = @"搜索历史";
//        [thrBackView addSubview:label];
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        button.frame = CGRectMake(Screen_width-84-20, 15, 84, 25);
//        [button setTitle:@"清空搜索历史" forState:UIControlStateNormal];
//        [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:14];
//        [button addTarget:self action:@selector(qingkongHistory) forControlEvents:UIControlEventTouchUpInside];
//        [thrBackView addSubview:button];
//        
//        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, Screen_width, 1)];
//        lineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
//        [thrBackView addSubview:lineView];
//        
//        return thrBackView;
//    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchViewToSearchDetailView"]) {
        SearchResultsViewController *searchResultVC = segue.destinationViewController;
        
        searchResultVC.myType = type;
        searchResultVC.mySearchStr = searchStr;
    }
}

- (void)qingkongHistory {
    [_historyArr removeAllObjects];
    NSMutableDictionary *searchDict = [[NSMutableDictionary alloc] init];
    [searchDict setObject:_historyArr forKey:@"searchArr"];
    
    [[NSUserDefaults standardUserDefaults] setObject:searchDict forKey:@"SearchDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [searchTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
