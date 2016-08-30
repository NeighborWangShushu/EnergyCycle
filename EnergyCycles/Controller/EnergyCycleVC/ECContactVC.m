//
//  ECContactVC.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECContactVC.h"
#import "AppHttpManager.h"
#import "ECContactCell.h"
#import "UserModel.h"
#import "Masonry.h"
#import "ContactModel.h"
#import "UIImageView+WebCache.h"
#import "ECContactSearchBar.h"
#import "ECSearchDisplayController.h"
#import "ChineseString.h"

#define kContactCellId @"kContactCellId"


@interface ECContactVC ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate,ECContactSearchBarDelegate> {
    BOOL isSearching;
}
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,strong)NSMutableArray * sectionDatas;


@property (nonatomic,strong)NSMutableArray * rowDatas;

@property (nonatomic,strong)NSMutableArray * searchResultArr;

@property (nonatomic,strong) ECContactSearchBar *searchBar;//搜索框
@property(strong, nonatomic) UISearchDisplayController *searchController;


@property (nonatomic,strong)NSMutableArray * contacts;
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation ECContactVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self setup];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}


#pragma mark NavigationBatAction

- (void)leftAction:(UIButton*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightAction:(UIButton*)sender {
    NSLog(@"selected:%@",self.selectedDatas);
    if ([self.delegate respondsToSelector:@selector(didSelectedContacts:)]) {
        [self.delegate didSelectedContacts:self.selectedDatas];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



- (void)initialize {
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    label.text = @"提醒谁看";
    [label setFont:[UIFont systemFontOfSize:18]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    leftItem.tintColor = [UIColor whiteColor];
    [leftItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItems = @[leftItem];

    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction:)];
    rightItem.tintColor = [UIColor whiteColor];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    
    self.sectionDatas = [NSMutableArray array];
    self.contacts = [NSMutableArray array];
    self.datas = [NSMutableArray array];
    self.searchResultArr=[NSMutableArray array];
    
    
}

- (void)filterData {
    
    self.sectionDatas = [ChineseString IndexArray:self.contacts];
    self.rowDatas = [ChineseString LetterSortArray:self.contacts];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)setSelectedDatas:(NSMutableArray *)selectedDatas {
    _selectedDatas = selectedDatas;
    [self getData];
    
}


- (void)setup {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionIndexTrackingBackgroundColor=[UIColor clearColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];

    
<<<<<<< HEAD
    
    _searchBar=[[ECContactSearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 44)];
    [_searchBar sizeToFit];
    _searchBar.delegate = self;
    _searchBar.hasCentredPlaceholder = NO;
=======
    _searchBar=[[ECContactSearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 44)];
    _searchBar.delegate = self;
    _searchBar.edelegate = self;
    _searchBar.hasCentredPlaceholder = NO;
    _searchBar.backgroundColor = [UIColor whiteColor];
>>>>>>> 2.0-beta-01
    [_searchBar setPlaceholder:@"搜索"];
    [_searchBar setContentMode:UIViewContentModeLeft];
    [_searchBar.layer setBorderWidth:0.5];
    [_searchBar.layer setBorderColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1].CGColor];
    [_searchBar setDelegate:self];
    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
<<<<<<< HEAD
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
=======
    [_searchBar sizeToFit];
    _searchBar.datas = self.selectedDatas;
    [self.view addSubview:self.searchBar];
    
    self.searchController = [[ECSearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.displaysSearchBarInNavigationBar = NO;
    self.searchController.delegate = self;
    self.searchController.searchContentsController.view.backgroundColor = [UIColor whiteColor];
    self.searchController.searchResultsTableView.tableFooterView = [UIView new];
    self.searchController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    [self.searchController.searchBar sizeToFit];
    _searchController.searchResultsTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 2.0f, 0.0f);

    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
>>>>>>> 2.0-beta-01
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@44);
        
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}


- (NSMutableArray *)getFriendListDataBy:(NSMutableArray *)array{
    
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//排序
        int i;
        NSString *strA = ((UserModel *)obj1).pinyin;
        NSString *strB = ((UserModel *)obj2).pinyin;
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;//上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;//下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    for (UserModel *user in serializeArray) {
        char c = [user.pinyin characterAtIndex:0];
        if (!isalpha(c)) {
            [oth addObject:user];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:user];
        }
        else {
            [data addObject:user];
        }
    }
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    return ans;
}


- (NSMutableArray *)getFriendListSectionBy:(NSMutableArray *)array{
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [section addObject:UITableViewIndexSearch];
    for (NSArray *item in array) {
        UserModel *user = [item objectAtIndex:0];
        char c = [user.pinyin characterAtIndex:0];
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return section;
}


- (void)getData {
    
    __weak __typeof(self)weakSelf = self;
    [[AppHttpManager shareInstance] getBothHeartWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *dic in dict[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                model.isSelected = @"";
                model.readyToDelete = @"";
                [weakSelf filterSelectedData:model];
                [self.contacts addObject:model];
            }
            [self filterData];
            
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];

}

- (void)filterSelectedData:(UserModel*)model {
    for (UserModel*selectedItem in self.selectedDatas) {
        if ([selectedItem.use_id isEqualToString:model.use_id]) {
            model.isSelected = @"isSelected";
        }
    }
    
}

#pragma mark searchBar delegate

- (void)contactSearchBar:(ECContactSearchBar *)searchBar model:(UserModel *)model isClear:(BOOL)isClear {
    
    [self.tableView reloadData];
    if (isClear) {
        isSearching = NO;
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
//    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    isSearching = NO;
    [self.tableView reloadData];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (!isSearching) {
        isSearching = YES;
        [self.tableView reloadData];
    }
    [_searchController.searchBar resignFirstResponder];
}



#pragma mark SearchController Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    [_searchBar setShowsCancelButton:YES animated:NO];
    UIView *topView = controller.searchBar.subviews[0];
    controller.searchResultsTableView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
   
    
    for (UIView *v in topView.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            [v removeFromSuperview];
        }
    }
}


- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    
    for (UIView *subview in controller.searchContentsController.view.subviews) {
        
        if ([subview isKindOfClass:NSClassFromString(@"UISearchDisplayControllerContainerView")])
        {
            UIView*searchView = subview.subviews[1];
            for (UIView*v in searchView.subviews) {
                if ([v isKindOfClass:NSClassFromString(@"ECContactSearchBar")]) {
                    NSLog(@"%f",v.frame.origin.y);
                    CGRect frame = v.frame;
                    NSLog(@"%f---%f",frame.origin.y,frame.size.height);
                    frame.origin.y = -20;
                    v.frame = frame;
                }
            }
        }
    }

}


- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    isSearching = NO;
    [self.tableView reloadData];
    
    
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
    for (UIView *subview in tableView.subviews)
    {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewWrapperView"])
        {
            subview.frame = CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height);
        }
    }
}

- (void) keyboardWillHide {
    
   
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    isSearching = NO;
    [self.tableView reloadData];

}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:searchOption]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]  objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}


#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < self.contacts.count; i++) {
        NSString *storeString = [(UserModel *)self.contacts[i] nickname];
        
        NSRange storeRange = NSMakeRange(0, storeString.length);
        
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            
            [tempResults addObject:self.contacts[i]];
        }
    }
    
    [_searchResultArr removeAllObjects];
    [_searchResultArr addObjectsFromArray:tempResults];
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedDatas.count == 10) {
        [SVProgressHUD showImage:nil status:@"最多选择10人"];
        return;
    }
    
    UserModel*model = nil;
    if (isSearching) {
        model = self.searchResultArr[indexPath.row];
    }else {
        model = self.rowDatas[indexPath.section][indexPath.row];
    }
    
    if ([model.isSelected isEqualToString:@"isSelected"]) {
        model.isSelected = @"";
        [self.selectedDatas removeObject:model];
    }else {
        model.isSelected = @"isSelected";
        [self.selectedDatas addObject:model];
    }
    ECContactCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.model = model;
    _searchBar.datas = self.selectedDatas;
    
}


#pragma mark UITableViewDataSource

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isSearching) {
        return nil;
    }
    return self.sectionDatas;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isSearching) {
        return 0.1;
    }
    return 22.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ECContactCell*cell = [tableView dequeueReusableCellWithIdentifier:kContactCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECContactCell" owner:self options:nil] lastObject];
    }
    UserModel*model = nil;
    if (isSearching) {
        NSLog(@"%@",self.searchResultArr);
        if (self.searchResultArr.count) {
            model = self.searchResultArr[indexPath.row];
        }
    }else {
        if (self.rowDatas.count) {
            model = self.rowDatas[indexPath.section][indexPath.row];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = model.nickname;
    cell.model = model;
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:model.photourl] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
    return cell;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //viewforHeader
    id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!label) {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14.5f]];
        [label setTextColor:[UIColor grayColor]];
        [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    }
    if (_sectionDatas.count > 0 && !isSearching) {
        [label setText:[NSString stringWithFormat:@"  %@",_sectionDatas[section]]];
    }
    return label;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching) {
        return _searchResultArr.count;
    }else{
        NSArray * arr = _rowDatas[section];
        return arr.count;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isSearching) {
        return 1;
    }else{
        return self.rowDatas.count;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
