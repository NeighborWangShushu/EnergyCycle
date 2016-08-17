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

#define kContactCellId @"kContactCellId"


@interface ECContactVC ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate,UISearchResultsUpdating> {
    BOOL isSearching;
}
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,strong)NSMutableArray * sectionDatas;

@property (nonatomic,strong)NSMutableArray * selectedDatas;

@property (nonatomic,strong)NSMutableArray * rowDatas;

@property (nonatomic,strong)NSMutableArray * searchResultArr;

@property (nonatomic,strong) ECContactSearchBar *searchBar;//搜索框
@property(strong, nonatomic) UISearchController *searchController;


@property (nonatomic,strong)NSMutableArray * contacts;
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation ECContactVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setup];
    [self getData];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)initialize {
    self.sectionDatas = [NSMutableArray array];
    self.contacts = [NSMutableArray array];
    self.datas = [NSMutableArray array];
    self.selectedDatas = [NSMutableArray array];
    self.searchResultArr=[NSMutableArray array];

    
}

- (void)filterData {
    
    self.rowDatas = [self getFriendListDataBy:self.contacts];
    self.sectionDatas = [self getFriendListSectionBy:[self.rowDatas copy]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (void)setup {
    
    UIView * nav = [UIView new];
    nav.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0];
    [self.view addSubview:nav];
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [nav addSubview:cancel];
    
    UIButton * sure = [UIButton buttonWithType:UIButtonTypeSystem];
    [sure.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [nav addSubview:sure];
    

    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionIndexTrackingBackgroundColor=[UIColor clearColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
//    _searchBar=[[ECContactSearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 44)];
//    [_searchBar sizeToFit];
//    _searchBar.delegate = self;
//    _searchBar.hasCentredPlaceholder = NO;
//    [_searchBar setPlaceholder:@"搜索"];
//    [_searchBar setContentMode:UIViewContentModeLeft];
//    [_searchBar.layer setBorderWidth:0.5];
//    [_searchBar.layer setBorderColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1].CGColor];
//    [_searchBar setDelegate:self];
//    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
//    self.tableView.tableHeaderView = self.searchBar;
    
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@60);
    }];
    
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nav.mas_left).with.offset(20);
        make.centerY.equalTo(nav.mas_centerY).with.offset(10);
    }];
    
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nav.mas_right).with.offset(-20);
        make.centerY.equalTo(nav.mas_centerY).with.offset(10);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(nav.mas_bottom);
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
    
    [[AppHttpManager shareInstance] getBothHeartWithUserid:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *dic in dict[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                [self.contacts addObject:model];
            }
            [self filterData];

        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];

}

#pragma mark searchBar delegate

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


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserModel*model = self.rowDatas[indexPath.section][indexPath.row];
    if (model.isSelected) {
        model.isSelected = nil;
        [self.selectedDatas removeObject:model];
    }else {
        model.isSelected = @"selected";
        [self.selectedDatas addObject:model];
    }
    ECContactCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.model = model;
    _searchBar.datas = self.selectedDatas;
    
}

#pragma mark SearchController Delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString * searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString scope:[searchController.searchBar scopeButtonTitles][searchController.searchBar.selectedScopeButtonIndex]];
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
            NSDictionary *dic=@{@"name":storeString};
            UserModel*newmodel = [[UserModel alloc] initWithDictionary:dic error:nil];
            [tempResults addObject:newmodel];
        }
    }
    
    [_searchResultArr removeAllObjects];
    [_searchResultArr addObjectsFromArray:tempResults];
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
    
    return 22.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ECContactCell*cell = [tableView dequeueReusableCellWithIdentifier:kContactCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECContactCell" owner:self options:nil] lastObject];
    }
    UserModel*model = nil;
    if (isSearching) {
       model = self.searchResultArr[indexPath.row];
    }else {
        model = self.rowDatas[indexPath.section][indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = model.nickname;
    cell.model = model;
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:model.pkImg] placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
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
    if (_sectionDatas.count > 0) {
        [label setText:[NSString stringWithFormat:@"  %@",_sectionDatas[section+1]]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
