//
//  CourseDetailViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CourseDetailViewController.h"

#import "LearnDetailViewCell.h"
#import "CourseTuiJianModel.h"

#import "CourseRegistrationViewController.h"
#import "XMShareView.h"

#import "LearnDetailViewController.h"

@interface CourseDetailViewController () <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate> {
    NSMutableArray *_dataArr;
    XMShareView *shareView;
    
    UIActivityIndicatorView *_activityView;
    NSString *loadStr;
}

@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程详情";
    
    _dataArr = [[NSMutableArray alloc] init];
    
    self.tuijianTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tuijianTableView.showsVerticalScrollIndicator = NO;
    self.tuijianTableView.showsHorizontalScrollIndicator = NO;
    
    [self creatDownButtonBackView];
    
    //创建分享按键
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 28, 28);
    [button setBackgroundImage:[[UIImage imageNamed:@"fenxiang_.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(detailRightActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [self setupLeftNavBarWithimage:@"whiteback_normal.png"];
    
    [UIView setAnimationsEnabled:NO];
    //加载网页
    showWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 80)];
    showWebView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    showWebView.delegate = self;
    loadStr = [NSString stringWithFormat:@"%@/%@?id=%@",INTERFACE_URL,StudyDetailAspx,self.courseID];
    [showWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadStr]]];
    
    showWebView.allowsInlineMediaPlayback = YES;
    showWebView.mediaPlaybackRequiresUserAction = YES;
    showWebView.scrollView.scrollEnabled=NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    
    [self getTuiJianData];
}

- (void)leftAction {
    [UIView setAnimationsEnabled:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    [showWebView removeFromSuperview];
    showWebView = nil;
}

#pragma mark - 加载动画
- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        UIActivityIndicatorView *indicator =[[UIActivityIndicatorView alloc] init];
        indicator.tag = 10000;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityView =indicator;
        indicator.center =self.view.center;
        
        [self.view addSubview:indicator];
    }
    return _activityView;
}

#pragma mark - webView
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self activityView];
    [_activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityView stopAnimating];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = CGRectMake(frame.origin.x, frame.origin.y, Screen_width, frame.size.height);
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    CGRect rect = showWebView.frame;
    rect.size.height = height+80;
    showWebView.frame = rect;
    
    //
    showWabBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 80+height)];
    self.tuijianTableView.tableHeaderView = showWabBackView;
    [showWabBackView addSubview:showWebView];
    
    if (_courseDetail) {
        _courseDetail();
    }
}

#pragma mark - 创建底部按键
- (void)creatDownButtonBackView {
    UIView *downBackView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height-50-64, Screen_width, 50)];
    [self.view addSubview:downBackView];
    
    UIButton *regButton = [UIButton buttonWithType:UIButtonTypeSystem];
    regButton.frame = CGRectMake(0, 0, Screen_width-80, 50);
    [regButton setBackgroundColor:[UIColor colorWithRed:67/255.0 green:154/225.0 blue:238/255.0 alpha:1]];
    [regButton setTitle:@"我要报名" forState:UIControlStateNormal];
    [regButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    regButton.titleLabel.font = [UIFont systemFontOfSize:20];
    regButton.tag = 3301;
    [regButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [downBackView addSubview:regButton];
    
    UIButton *calButton = [UIButton buttonWithType:UIButtonTypeSystem];
    calButton.frame = CGRectMake(Screen_width-80, 0, 80, 50);
    [calButton setBackgroundColor:[UIColor colorWithRed:46/255.0 green:124/225.0 blue:232/255.0 alpha:1]];
    [calButton setImage:[[UIImage imageNamed:@"dianhua_.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    calButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [calButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    calButton.tag = 3302;
    [downBackView addSubview:calButton];
}

#pragma mark - 底部按键响应事件
- (void)buttonClick:(UIButton *)button {
    if (button.tag == 3301) {//报名
        [self performSegueWithIdentifier:@"CourseDetailViewToBaoMingView" sender:nil];
    }else {//打电话
        NSString *phoneStr = [[NSString alloc]initWithFormat:@"telprompt://%@",@"400-800-6258"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }
}

#pragma mark - 获取推荐数据
- (void)getTuiJianData {
    [[AppHttpManager shareInstance] getGetAboutCourseListWithStudyType:self.courseType PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                CourseTuiJianModel *model = [[CourseTuiJianModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
        }
        [self.tuijianTableView reloadData];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LearnDetailViewCellId = @"LearnDetailViewCellId";
    LearnDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LearnDetailViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LearnDetailViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count) {
        CourseTuiJianModel *model = (CourseTuiJianModel *)_dataArr[indexPath.row];
        cell.titleLabel.text = model.title;
        cell.typeLabel.text = model.studyType;
        cell.typeLabel.textColor = [UIColor whiteColor];
        
        cell.typeLabel.backgroundColor = [UIColor orangeColor];
        cell.typeLabel.layer.masksToBounds = YES;
        cell.typeLabel.layer.cornerRadius = 2.f;
        
        cell.liulanLabel.text = model.readCount;
    }
    
    return cell;
}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTuiJianModel *model = (CourseTuiJianModel *)_dataArr[indexPath.row];
    LearnDetailViewController *learnDetailVC = MainStoryBoard(@"LearnDetailVCID");
    learnDetailVC.learnAtriID = model.courseId;
    learnDetailVC.courseType = model.studyType;
    learnDetailVC.learnTitle = model.title;
    learnDetailVC.learnContent = model.contents;

    [self.navigationController pushViewController:learnDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 50)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, Screen_width, 40)];
    subView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:subView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, Screen_width-24, 16)];
    label.text = @"相关推荐";
    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    label.font = [UIFont systemFontOfSize:16];
    [subView addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, Screen_width, 1)];
    lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [subView addSubview:lineView];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CourseDetailViewToBaoMingView"]) {
        CourseRegistrationViewController *courVC = segue.destinationViewController;
        courVC.courseID = self.courseID;
    }
}

#pragma mark - 右按键响应事件
- (void)detailRightActionWithBtn:(UIButton *)button {
    //分享
    shareView = [[XMShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
    shareView.alpha = 0.0;
    shareView.shareTitle = self.courseTitle;;
    shareView.shareText = @"";
    shareView.shareUrl = loadStr;
    
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    [UIView animateWithDuration:0.25 animations:^{
        shareView.alpha = 1.0;
    }];
}

//实现消息中心方法
- (void)removeShareView:(NSNotification *)notification {
    [shareView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
