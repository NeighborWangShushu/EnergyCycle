//
//  ECViewController.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECViewController.h"
#import "Masonry.h"
#import "SDAutoLayout.h"
#import "ECTimeLineModel.h"
#import "ECTimeLineCell.h"
#import "ECTimeLineCellLikeItemModel.h"
#import "ECTimeLineCellCommentItemModel.h"
#import "XMShareView.h"
#import "GifHeader.h"


#define kTimeLineTableViewCellId @"ECTimeLineCell"


@interface ECViewController ()<UITableViewDelegate,UITableViewDataSource,ECTimeLineCellDelegate>{
    XMShareView*shareView;
    UILabel*titleLabel;
    UIImageView *arrowImg;
}

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;


@end

@implementation ECViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self getData];
    
    [self setup];
    
    // Do any additional setup after loading the view.
}

- (void)getData {
    __weak typeof(self) weakSelf = self;

    [[AppHttpManager shareInstance] getGetArticleListWithType:@"1" Userid:User_ID Token:User_TOKEN PageIndex:[NSString stringWithFormat:@"%d",1] PageSize:@"10" PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            
            for (NSDictionary * data in dict[@"Data"]) {
                ECTimeLineModel*model = [self sortByData:data];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSString *str) {
        [weakSelf.tableView.mj_header endRefreshing];
        
    }];

}

- (ECTimeLineModel*)sortByData:(NSDictionary*)data {
    ECTimeLineModel*model = [ECTimeLineModel new];
    model.iconName = data[@"photoUrl"];
    model.name = data[@"nickName"];
    model.ID = [NSString stringWithFormat:@"%@",data[@"artId"]];
    NSString *informationStr = [data[@"artContent"] stringByRemovingPercentEncoding];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    model.msgContent = informationStr;
    model.location = data[@"address"];
    model.time = data[@"createTime"];
    model.picNamesArray = data[@"artPic"];
    NSMutableArray * likeArr = [NSMutableArray array];
    for (NSDictionary * like in data[@"LikeUserList"]) {
        ECTimeLineCellLikeItemModel*likeModel = [ECTimeLineCellLikeItemModel new];
        likeModel.userId = like[@"UserID"];
        likeModel.userName = like[@"NickName"];
        [likeArr addObject:likeModel];
    }
    NSMutableArray * commentArr = [NSMutableArray array];
    for (NSDictionary * comment in data[@"CommentList"]) {
        ECTimeLineCellCommentItemModel*commentModel = [ECTimeLineCellCommentItemModel new];
        commentModel.firstUserName = comment[@"commNickName"];
        commentModel.commentString = comment[@"commContent"];
        commentModel.firstUserId = comment[@"commUserId"];
        [commentArr addObject:commentModel];
    }
    model.likeItemsArray = likeArr;
    model.commentItemsArray = commentArr;
    
    return model;
}


- (void)setup {

    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(200, 10, 150, 50)];

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(showFromNavigation) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:button];

    titleLabel = [UILabel new];
    titleLabel.text = @"能量圈";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [navView addSubview:titleLabel];
    
    arrowImg = [UIImageView new];
    [arrowImg setImage:[UIImage imageNamed:@"ec_arrow"]];
    [navView addSubview:arrowImg];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(navView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView.mas_centerX);
        make.centerY.equalTo(navView.mas_centerY);
    }];
    
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).with.offset(5);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    self.navigationItem.titleView = navView;
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightbutton.frame = CGRectMake(0, 0, 21, 25);
    [rightbutton setBackgroundImage:[UIImage imageNamed:@"ec_sign"] forState:UIControlStateNormal];
    rightbutton.tag = 1001;
    [rightbutton addTarget:self action:@selector(energyRightActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItems = @[item];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftbutton.frame = CGRectMake(0, 0, 21, 25);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"ec_invite"] forState:UIControlStateNormal];
    leftbutton.tag = 1002;
    [leftbutton addTarget:self action:@selector(energyLeftActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftitem];
    
    UITableView * tableView   = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate        = self;
    tableView.dataSource      = self;
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerClass:[ECTimeLineCell class] forCellReuseIdentifier:@"TestCell2"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.tableView = tableView;
    self.tableView.mj_header = [GifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}

//签到
- (void)energyRightActionWithBtn:(id)sender {
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        [self performSegueWithIdentifier:@"EnergyCycleViewToSignInView" sender:nil];
    }

}

//邀请
- (void)energyLeftActionWithBtn:(id)sender {
    [self performSegueWithIdentifier:@"EnergyCycleViewToInviteView" sender:nil];

}


- (void)loadNewData {
    [self getData];
}

#pragma mark UITableViewDelegate

- (void)didActionInCell:(UITableViewCell *)cell actionType:(ECTimeLineCellActionType)type atIndexPath:(NSIndexPath *)indexPath{
    switch (type) {
        case ECTimeLineCellActionTypeShare:
            [self share:self.dataArray[indexPath.row]];
            break;
        case ECTimeLineCellActionTypeLike:
            [self doLike:self.dataArray[indexPath.row]];
            break;
        case ECTimeLineCellActionTypeComment:
            [self doComment:self.dataArray[indexPath.row]];
            break;
            
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ECTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
}


- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark UITableViewDataSource

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    UILabel*title = [UILabel new];
    title.text = @"精彩推荐";
    title.textColor = [UIColor colorWithRed:(74 / 255.0) green:(74 / 255.0) blue:(74 / 255.0) alpha:1.0];
    title.font = [UIFont systemFontOfSize:18];
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(10);
        make.centerY.equalTo(view.mas_centerY);
    }];
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ECTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            ECTimeLineModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        cell.delegate = self;
    }
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showFromNavigation {
    NSLog(@"showFromNavigation");
    
}

#pragma mark - 分享
- (void)share:(ECTimeLineModel*)model {
    
    shareView = [[XMShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
    shareView.alpha = 0.0;
    shareView.shareTitle = model.msgContent;
    shareView.shareText = @"";
    NSString * share_url = @"";
    share_url = [NSString stringWithFormat:@"%@/%@?id=%@",INTERFACE_URL,StudyDetailAspx,model.ID];
    shareView.shareUrl = [NSString stringWithFormat:@"%@&is_Share=1",share_url];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    [UIView animateWithDuration:0.25 animations:^{
        shareView.alpha = 1.0;
    }];
}

//评论
- (void)doComment:(ECTimeLineModel*)model {
   
}

//点赞
- (void)doLike:(ECTimeLineModel*)model {
  
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
