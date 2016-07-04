//
//  CourseViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "CourseViewController.h"

#import "CourseTableViewCell.h"
#import "LearnViewShowModel.h"

#import "CourseDetailViewController.h"
#import "GifHeader.h"


@interface CourseViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_dataArr;
    int page;
    
    NSInteger touchIndex;
}

@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:240/255.0 alpha:1];
    _dataArr = [[NSMutableArray alloc] init];
    
    courseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    courseTableView.backgroundColor = [UIColor clearColor];
    courseTableView.showsHorizontalScrollIndicator = NO;
    courseTableView.showsVerticalScrollIndicator = NO;
    
    [self setUpMJRefresh];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    courseTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        page = 0;
        [weakSelf loadDataWithIndexWithPage:page];
    }];
    
    courseTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf loadDataWithIndexWithPage:page];
    }];
    
    [courseTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [courseTableView.mj_header endRefreshing];
    [courseTableView.mj_footer endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexWithPage:(int)pages {
    [[AppHttpManager shareInstance] getGetStudyListByTabWithTabName:@"课程" PostOrGet:@"get" useId:[User_ID intValue] withPage:pages withSize:10 success:^(NSDictionary *dict) {
        if (pages == 0) {
            [_dataArr removeAllObjects];
        }
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                LearnViewShowModel *model = [[LearnViewShowModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            
            NSMutableArray *subArr = [[NSMutableArray alloc] initWithArray:_dataArr];
            [_dataArr removeAllObjects];
            for (NSInteger i=subArr.count-1; i>=0; i--) {
                NSDictionary *subDict = (NSDictionary *)subArr[i];
                [_dataArr addObject:subDict];
            }
            
            [courseTableView reloadData];
            [self endRefresh];
            
            if ([dict[@"Data"] count] <= 0) {
                if (pages == 0) {
                    [SVProgressHUD showImage:nil status:@"暂时还没有课程"];
                }else {
                    [SVProgressHUD showImage:nil status:@"没有更多的数据了~"];
                }
            }
        }else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        [self endRefresh];
        page--;
        NSLog(@"%@",str);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count) {
        LearnViewShowModel *showModel = (LearnViewShowModel *)_dataArr[indexPath.row];
        CGRect rect = [showModel.studyType boundingRectWithSize:CGSizeMake(SIZE_MAX, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] context:nil];
        CGFloat titleHight = [self textHeightFromTextString:showModel.title width:Screen_width-(12+rect.size.width+10+20) fontSize:16];
        return 220.f+([self textHeightFromTextString:showModel.summary width:Screen_width-24 fontSize:14]>51?51:[self textHeightFromTextString:showModel.summary width:Screen_width-24 fontSize:14]) + titleHight;
    }
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CourseTableViewCellId = @"CourseTableViewCellId";
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CourseTableViewCell" owner:self options:nil].lastObject;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArr.count) {
        LearnViewShowModel *model = (LearnViewShowModel *)_dataArr[indexPath.row];
        
        NSArray *imageArr = [model.img componentsSeparatedByString:@","];
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:imageArr.firstObject] placeholderImage:nil];
        cell.titleLabel.text = model.title;
        cell.biaoLabel.text = model.studyType;
        cell.contentLabel.text = model.summary;
        cell.liulanLabel.text = model.readCount;
        
        CGRect rect = [model.studyType boundingRectWithSize:CGSizeMake(SIZE_MAX, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] context:nil];
        cell.typeLabelAutoLayout.constant = rect.size.width+10;
    }
    
    return cell;
}
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    touchIndex = indexPath.row;
    [self performSegueWithIdentifier:@"CourseViewToCourseDetailView" sender:nil];
}

#pragma mark - Navigation传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CourseViewToCourseDetailView"]) {
        CourseDetailViewController *couDetailVC = segue.destinationViewController;
        if (_dataArr.count) {
            LearnViewShowModel *model = (LearnViewShowModel *)_dataArr[touchIndex];
            couDetailVC.courseID = model.learnId;
            couDetailVC.courseType = model.studyType;
            couDetailVC.courseTitle = model.title;
            couDetailVC.courseContent = model.contents;
        }
        [couDetailVC setCourseDetail:^{
            LearnViewShowModel *model = (LearnViewShowModel *)_dataArr[touchIndex];
            model.readCount = [NSString stringWithFormat:@"%d",[model.readCount intValue] + 1];
            [_dataArr replaceObjectAtIndex:touchIndex withObject:model];
            [courseTableView reloadData];
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
