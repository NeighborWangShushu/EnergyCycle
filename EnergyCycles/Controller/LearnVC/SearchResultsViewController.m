//
//  SearchResultsViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SearchResultsViewController.h"

#import "SearchResultTableViewCell.h"
#import "CourseTuiJianModel.h"

#import "LearnDetailViewController.h"

@interface SearchResultsViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    UIButton *rightButton;
    
    NSMutableArray *_dataArr;
    UISearchBar *mySearchBar;
}

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchResultTableView.showsHorizontalScrollIndicator = NO;
    searchResultTableView.showsVerticalScrollIndicator = NO;
    searchResultTableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
    
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
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(12, 0, Screen_width-63-12, 44)];
    mySearchBar.searchBarStyle = UISearchBarStyleMinimal;
    mySearchBar.barTintColor = [UIColor grayColor];
    mySearchBar.delegate = self;
    [self.navigationController.navigationBar addSubview:mySearchBar];
    [self getSearchData];
}

- (void)leftAction {
    
}

#pragma mark - 返回按键
- (void)rightAction {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 获取搜索数据
- (void)getSearchData {
    NSString * type = (NSString*)self.myType;
    [[AppHttpManager shareInstance] getSearchWithTypes:type withContent:self.mySearchStr PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [_dataArr removeAllObjects];
            if ([dict[@"Data"] count] == 0) {
                [SVProgressHUD showImage:nil status:@"无搜索结果"];
                return;
            }
            
            for (NSDictionary *subDict in dict[@"Data"]) {
                CourseTuiJianModel *model = [[CourseTuiJianModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            [searchResultTableView reloadData];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark -
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.mySearchStr = searchBar.text;
    self.myType = @"2";
    [self getSearchData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [mySearchBar removeFromSuperview];
    mySearchBar = nil;
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SearchResultTableViewCellId = @"SearchResultTableViewCellId";
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchResultTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil].lastObject;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bakcView.layer.borderWidth = 1.f;
    cell.bakcView.layer.borderColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1].CGColor;
    
    if (_dataArr.count) {
        CourseTuiJianModel *model = (CourseTuiJianModel *)_dataArr[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.img]] placeholderImage:[UIImage imageNamed:@"placepic.png"]];
        cell.titleLabel.text = model.title;
        cell.chankanLabel.text = model.readCount;
        
        cell.classLabel.textColor = [UIColor whiteColor];
        cell.classLabel.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1];
        cell.classLabel.layer.masksToBounds = YES;
        cell.classLabel.layer.cornerRadius = 2.f;
        cell.classLabel.text = model.studyType;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count) {
        CourseTuiJianModel *model = (CourseTuiJianModel *)_dataArr[indexPath.row];
        LearnDetailViewController *learnDetailVC = MainStoryBoard(@"LearnDetailVCID");
        learnDetailVC.learnAtriID = model.courseId;
        learnDetailVC.courseType = model.studyType;
        learnDetailVC.learnTitle = model.title;
        learnDetailVC.learnContent = model.contents;
        
        [self.navigationController pushViewController:learnDetailVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
