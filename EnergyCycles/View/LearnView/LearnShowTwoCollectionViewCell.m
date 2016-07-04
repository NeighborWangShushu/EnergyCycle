//
//  LearnShowTwoCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet on 16/3/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LearnShowTwoCollectionViewCell.h"
#import "LearnTwoTableViewCell.h"
#import "GifHeader.h"

@interface LearnShowTwoCollectionViewCell () <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_dataArr;
    
    NSString *pmStr;
}

@end

@implementation LearnShowTwoCollectionViewCell

- (void)awakeFromNib {
    _dataArr = [[NSMutableArray alloc] init];
    
    self.learnTwoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.learnTwoTableView.backgroundColor = [UIColor clearColor];
    self.learnTwoTableView.showsVerticalScrollIndicator = NO;
    self.learnTwoTableView.dataSource = self;
    self.learnTwoTableView.delegate = self;
    
    [self setUpMJRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(learnNotification:) name:@"isLearnNotification" object:nil];
}

- (void)learnNotification:(NSNotification *)notification {
    [self.learnTwoTableView.mj_header beginRefreshing];
}

#pragma mark - 获取index
- (void)creatTwoCollectionViewWithIndex:(NSString *)indexStr {
    [_dataArr removeAllObjects];
    [self.learnTwoTableView.mj_header beginRefreshing];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.learnTwoTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        [_dataArr removeAllObjects];
        [weakSelf loadDataWithIndexWithType:@"学霸榜" Page:0];
    }];
    
    [self.learnTwoTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [self.learnTwoTableView.mj_header endRefreshing];
    [self.learnTwoTableView.mj_footer endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexWithType:(NSString *)type Page:(int)pages {
    //学霸搒
    [[AppHttpManager shareInstance] getGetStudyGoodListWithUserId:User_ID PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            //获取学习值排名
            [[AppHttpManager shareInstance] getGetMyStudyValCountWithUserid:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *sdict) {
                if ([sdict[@"Code"] integerValue] == 200 && [sdict[@"IsSuccess"] integerValue] == 1) {
                    pmStr = sdict[@"Data"];
                }
                
                for (NSDictionary *subDict in dict[@"Data"]) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                    [_dataArr addObject:model];
                }
                
                [self.learnTwoTableView reloadData];
            } failure:^(NSString *str) {
                NSLog(@"%@",str);
            }];
            [self endRefresh];
        }else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        [self endRefresh];
        [self.learnTwoTableView reloadData];
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
    return 70.f;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LearnTwoTableViewCellId = @"LearnTwoTableViewCellId";
    LearnTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LearnTwoTableViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LearnTwoTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.headLearnButton.tag = 3001+indexPath.row;
    [cell.headLearnButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setLearnCellTouchuZan:^(NSInteger cellTouchIndex) {
        UserModel *subModel = (UserModel *)_dataArr[cellTouchIndex];
        [self touchZanWithModel:subModel withIndex:cellTouchIndex];
    }];
    
    static NSInteger process = 0;
    if (_dataArr.count) {
        UserModel *model = (UserModel *)_dataArr[indexPath.row];
        if (indexPath.row == 0) {
            process = [model.studyVal integerValue];
        }
        [cell updateEveryDayPKDataWithIndex:indexPath.row withModel:model];
        
        if (indexPath.row == 0) {
            if (process != 0) {
                cell.lingLearnProgressView.progress = 1.0;
            }else {
                cell.lingLearnProgressView.progress = 0.0;
            }
        }else {
            if (process != 0) {
                cell.lingLearnProgressView.progress = [model.studyVal floatValue]/process;
            }else {
                cell.lingLearnProgressView.progress = 0.0;
            }
        }
    }
    
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (_dataArr.count) {
//        UserModel *model = (UserModel *)_dataArr[indexPath.row];
//        if (_learnBaShowSelectCell) {
//            _learnBaShowSelectCell(model,@"学霸榜");
//        }
//    }
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 200)];
    headBackView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    //
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, Screen_width, 17)];
    titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的学习值";
    titleLabel.font = [UIFont systemFontOfSize:12];
    [headBackView addSubview:titleLabel];
    
    //
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 160)];
    numLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserStudyValues"]];
    numLabel.font = [UIFont systemFontOfSize:64];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.center = CGPointMake(Screen_width/2, 100);
    [headBackView addSubview:numLabel];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = numLabel.bounds;
    gradientLayer.colors = @[(id)[UIColor colorWithRed:112/255.0 green:203/255.0 blue:246/255.0 alpha:1].CGColor, (id)[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1].CGColor];
    [headBackView.layer addSublayer:gradientLayer];
    
    gradientLayer.mask = numLabel.layer;
    numLabel.frame = gradientLayer.frame;
    
    //
    UIImageView *yinyingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_width/2-50, 110, 100, 40)];
    yinyingImageView.image = [UIImage imageNamed:@"learbyinying"];
    [headBackView addSubview:yinyingImageView];
    
    //
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, Screen_width, 40)];
    subView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247 /255.0 alpha:1];
    [headBackView addSubview:subView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 9, Screen_width-24, 22)];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    nameLabel.text = [NSString stringWithFormat:@"%@ 第%@名",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserNickName"],pmStr];
    [subView addSubview:nameLabel];
    
    return headBackView;
}

#pragma mark -
- (void)headButtonClick:(UIButton *)button {
    if (_dataArr.count) {
        UserModel *model = (UserModel *)_dataArr[button.tag - 3001];
        _learnShowOtherSelect(model);
    }
}

#pragma mark - 点赞、取消赞
- (void)touchZanWithModel:(UserModel *)model withIndex:(NSInteger)index {
    [[AppHttpManager shareInstance] getSendGoodWithUserId:[User_ID intValue] withUseredId:[model.use_id intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            UserModel *subModel = (UserModel *)_dataArr[index];
            if ([subModel.flag integerValue] == 0) {
                subModel.flag = @"1";
                [SVProgressHUD showImage:nil status:@"点赞成功"];
            }else {
                subModel.flag = @"0";
                [SVProgressHUD showImage:nil status:@"取消点赞"];
            }
            [_dataArr replaceObjectAtIndex:index withObject:subModel];
            [self.learnTwoTableView reloadData];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

//根据字符串的实际内容的多少,在固定的宽度和字体的大小,动态的计算出实际的高度
- (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size {
    // 设置行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size],NSParagraphStyleAttributeName:paragraphStyle1};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    //返回计算出的行高
    return rect.size.height;
}


@end
