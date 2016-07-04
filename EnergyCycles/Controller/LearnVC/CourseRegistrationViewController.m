//
//  CourseRegistrationViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CourseRegistrationViewController.h"

#import "CourseRrgOneViewCell.h"
#import "CourseRegTwoViewCell.h"
#import "CourseRegThrViewCell.h"
#import "LearnCustomChooseClassView.h"
#import "CoursesCompletedViewController.h"

#import "CourseTimeModel.h"
#import "ServerModel.h"

@interface CourseRegistrationViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate> {
    UIButton *rightButton;
    
    LearnCustomChooseClassView *learnCustomChoosrClassView;
    NSMutableDictionary *postDict;
    NSMutableArray *downBiaoJiArr;
    
    NSMutableArray *_timeArr;
    NSMutableArray *_fuwuArr;
}

@end

@implementation CourseRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程";
    
    postDict = [[NSMutableDictionary alloc] init];
    downBiaoJiArr = [[NSMutableArray alloc] init];
    
    _timeArr = [[NSMutableArray alloc] init];
    _fuwuArr = [[NSMutableArray alloc] init];
    
    courseRegisterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    courseRegisterTableView.showsHorizontalScrollIndicator = NO;
    courseRegisterTableView.showsVerticalScrollIndicator = NO;
    
    //
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    //
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 48, 30);
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    [self getCourseTimeData];
    [self getCourseFuWuData];
    
    [postDict setObject:@"" forKey:@"courseTime"];
    [postDict setObject:@"" forKey:@"courseServer"];
    [postDict setObject:@"" forKey:@"people"];
    [postDict setObject:@"" forKey:@"coursePath"];
    [postDict setObject:@"" forKey:@"back"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 右按键响应事件,下一步
- (void)rightAction {
    if ([postDict[@"people"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请选择填表人"];
    }else if ([postDict[@"courseTime"] length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请选择课程时间"];
    }else {
        NSString *zengzhiStr = @"";
        for (NSInteger i=0; i<downBiaoJiArr.count; i++) {
            if ([downBiaoJiArr[i] isEqualToString:@"1"]) {
                ServerModel *model = (ServerModel *)_fuwuArr[i];
                zengzhiStr = [NSString stringWithFormat:@"%@,%@",zengzhiStr,model.serverContent];
            }
        }
        [postDict setObject:zengzhiStr forKey:@"courseServer"];
        
        [self performSegueWithIdentifier:@"CourseRrgViewToCourseCompletedView" sender:nil];
    }
}

#pragma mark - 获取课程时间
- (void)getCourseTimeData {
    [[AppHttpManager shareInstance] getGetcourseTimeByIdWithcourseId:[self.courseID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                CourseTimeModel *model = [[CourseTimeModel alloc] initWithDictionary:subDict error:nil];
                [_timeArr addObject:model];
            }
        }
        [courseRegisterTableView reloadData];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 获取增值服务
- (void)getCourseFuWuData {
    [[AppHttpManager shareInstance] getGetcourseServerByIdWithCourseId:[self.courseID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                ServerModel *serverModel = [[ServerModel alloc] initWithDictionary:subDict error:nil];
                [_fuwuArr addObject:serverModel];
            }
        }
        
        for (NSInteger i=0; i<_fuwuArr.count; i++) {
            [downBiaoJiArr addObject:@"0"];
        }
        [courseRegisterTableView reloadData];
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - UITableView方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2 || section == 4) {
        return 1;
    }else if (section == 1) {
        return _timeArr.count;
    }
    return _fuwuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 55.f;
    }else if (indexPath.section == 4) {
        return 170.f;
    }
    if (indexPath.row == 2) {
        return 85.f;
    }
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        static NSString *CourseRrgOneViewCellId = @"CourseRrgOneViewCellId";
        CourseRrgOneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseRrgOneViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CourseRrgOneViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for (UIView *subView in cell.subviews) {
            if (subView.tag == 3401) {
                [subView removeFromSuperview];
            }
        }
        
        if (indexPath.section == 2) {
            cell.leftTwoLabel.text = @"";
            cell.leftOneLabel.text = @"了解途径";
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 1)];
            lineView.tag = 3401;
            lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
            [cell addSubview:lineView];
        }
        
        return cell;
    }else if (indexPath.section == 1 || indexPath.section == 3) {
        static NSString *CourseRegTwoViewCellId = @"CourseRegTwoViewCellId";
        
        CourseRegTwoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseRegTwoViewCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CourseRegTwoViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = 3031*indexPath.section + indexPath.row;
        
        if (indexPath.section == 1) {//课程时间
            if (_timeArr.count) {
                CourseTimeModel *model = (CourseTimeModel *)_timeArr[indexPath.row];
                cell.titleLabel.text = model.timeTitle;
                cell.timeLabel.text = model.timeContent;
            }
        }else {//增值服务
            if (_fuwuArr.count) {
                ServerModel *model = (ServerModel *)_fuwuArr[indexPath.row];
                cell.titleLabel.text = model.serverTitle;
                cell.timeLabel.text = model.serverContent;
            }
        }
        
        return cell;
    }
    
    static NSString *CourseRegThrViewCellId = @"CourseRegThrViewCellId";
    CourseRegThrViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseRegThrViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CourseRegThrViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.inputTextView.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 0.1f;
    }
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return nil;
    }
    UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 50.f)];
    headBackView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 1)];
    lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 17, 65, 20)];
    oneLabel.font = [UIFont systemFontOfSize:16];
    [headBackView addSubview:oneLabel];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 18, 50, 20)];
    twoLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    twoLabel.font = [UIFont systemFontOfSize:12];
    [headBackView addSubview:twoLabel];
    
    if (section == 1) {
        [headBackView addSubview:lineView];
        oneLabel.text = @"课程时间";
        twoLabel.text = @"(必选)";
    }else if (section == 3) {
        [headBackView addSubview:lineView];
        oneLabel.text = @"增值服务";
        twoLabel.text = @"(可选)";
    }else {
        oneLabel.text = @"备注";
    }
    
    return headBackView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 10.f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 10)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self creatLearnCustomChooseClassWithIndex:2];
    }else if (indexPath.section == 2) {
        [self creatLearnCustomChooseClassWithIndex:1];
    }else if (indexPath.section == 1) {//课程时间
        for (NSInteger i=0; i<_timeArr.count; i++) {
            CourseRegTwoViewCell *cell = (CourseRegTwoViewCell *)[self.view viewWithTag:3031*indexPath.section + i];
            cell.backView.layer.borderWidth = 1.f;
            cell.backView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
            cell.backView.backgroundColor = [UIColor whiteColor];
        }
        
        CourseRegTwoViewCell *cell = (CourseRegTwoViewCell *)[self.view viewWithTag:3031*indexPath.section + indexPath.row];
        cell.backView.layer.borderWidth = 2.f;
        cell.backView.layer.borderColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1].CGColor;
        cell.backView.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:0.2];
        
        [postDict setObject:@"" forKey:@"courseTime"];
        if (_timeArr.count) {
            CourseTimeModel *model = (CourseTimeModel *)_timeArr[indexPath.row];
            [postDict setObject:model.courseId forKey:@"courseTime"];
        }
    }else {//增值服务
        if ([downBiaoJiArr[indexPath.row] isEqualToString:@"0"]) {
            [downBiaoJiArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }else {
            [downBiaoJiArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }
        
        for (NSInteger i=0; i<_fuwuArr.count; i++) {
            CourseRegTwoViewCell *cell = (CourseRegTwoViewCell *)[self.view viewWithTag:3031*indexPath.section + i];
            if ([downBiaoJiArr[i] integerValue] == 1) {
                cell.backView.layer.borderWidth = 2.f;
                cell.backView.layer.borderColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1].CGColor;
                cell.backView.backgroundColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:0.2];
            }else {
                cell.backView.layer.borderWidth = 1.f;
                cell.backView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
                cell.backView.backgroundColor = [UIColor whiteColor];
            }
        }
    }
}

- (void)creatLearnCustomChooseClassWithIndex:(NSInteger)index {
    learnCustomChoosrClassView = [[LearnCustomChooseClassView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height) WithType:index];
    learnCustomChoosrClassView.alpha = 0;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    [learnCustomChoosrClassView setChooseClassStr:^(NSString *str,NSInteger showType) {
        [weakSelf getChooseWithStr:str withShowType:showType];
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:learnCustomChoosrClassView];
    
    [UIView animateWithDuration:0.25 animations:^{
        learnCustomChoosrClassView.alpha = 1;
    }];
}

#pragma mark - 获取选择的分类
- (void)getChooseWithStr:(NSString *)str withShowType:(NSInteger)index {
    [learnCustomChoosrClassView removeFromSuperview];
    
    if (index == 2) {//0分区
        if (![str isEqualToString:@" "]) {//填表人
            CourseRrgOneViewCell *cell = [courseRegisterTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.chooseBackLabel.text = str;
            
            [postDict setObject:str forKey:@"people"];
        }
    }else {//2分区
        if (![str isEqualToString:@" "]) {//了解途径
            CourseRrgOneViewCell *cell = [courseRegisterTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            cell.chooseBackLabel.text = str;
            
            [postDict setObject:str forKey:@"coursePath"];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [postDict setObject:textView.text forKey:@"back"];//备注
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CourseRrgViewToCourseCompletedView"]) {
        CoursesCompletedViewController *comVC = segue.destinationViewController;
        comVC.getSubDict = postDict;
        comVC.courseID = self.courseID;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
