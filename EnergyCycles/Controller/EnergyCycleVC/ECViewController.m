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
#import "CommentUserModel.h"
#import "ECTimeLineCell.h"
#import "ECTimeLineCellLikeItemModel.h"
#import "ECTimeLineCellCommentItemModel.h"
#import "XMShareView.h"
#import "GifHeader.h"
#import "ECRecommendCell.h"
#import "AFHttpRequestOperation.h"
#import "JSONKit.h"
#import "NavMenuView.h"
#import "ECNavMenuModel.h"

#define kTimeLineTableViewCellId @"ECTimeLineCell"
#define kCommentUserCellId @"ECCommentUserCell"


@interface ECViewController ()<UITableViewDelegate,UITableViewDataSource,ECTimeLineCellDelegate,UITextFieldDelegate,NavMenuViewDelegate>{
    XMShareView*shareView;
    UILabel*titleLabel;
    UIImageView *arrowImg;
    NSInteger pageType;//0 能量圈  1关注的人
    NSInteger currentPage;
    NSString * userId;
    NSInteger maxPageSize; //总页数
    UITextField*text;
    
    ECNavMenuModel*selectedModel;
    ECTimeLineModel * commendModel;
    ECTimeLineModel * selectedLikeModel;
}

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NavMenuView *navMenuView;
@property (nonatomic,strong)NSMutableArray *menuDataArray;


@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * commentArray;
@property (nonatomic,strong)NSMutableArray * newerArray;


@end

@implementation ECViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    
    [self setup];
    
    [self getData];
    
    
    // Do any additional setup after loading the view.
}

- (void)initialize {
    
    currentPage = 1;
    self.dataArray = [NSMutableArray array];
    self.commentArray = [NSMutableArray array];
    self.newerArray = [NSMutableArray array];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSLog(@"NSDocumentDirectory:%@",documentsDirectory);
    
    NSLog(@"%@",[User_ID class]);
    userId = User_ID == 0?@"0":User_ID;
    [self getNavData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
}



#pragma mark  GET

- (void)getNavData {
    NSArray * all = [ECNavMenuModel findAll];
    if ([all count]) {
        [self.menuDataArray addObjectsFromArray:all];
        for (ECNavMenuModel*model in all) {
            if (model.isSelected) {
                selectedModel = model;
            }
        }
        
    }else {
        ECNavMenuModel*model1 = [ECNavMenuModel new];
        model1.name = @"能量圈";
        model1.isSelected = YES;
        
        ECNavMenuModel*model2 = [ECNavMenuModel new];
        model2.name = @"关注的人";
        
        [model1 save];
        [model2 save];
        [self.menuDataArray addObject:model1];
        [self.menuDataArray addObject:model2];
    }
}

- (void)getData {
    __weak typeof(self) weakSelf = self;

    if (pageType == 0) {
        //能量圈
        NSString * jingxuan = [NSString stringWithFormat:@"%@%@?type=2&userId=%@&token=%@&pageIndex=%@&pageSize=%@",INTERFACE_URL,GetArticleList,userId,User_TOKEN,@"1",@"10"];
        NSString * tuijian = [NSString stringWithFormat:@"%@%@?userId=%@",INTERFACE_URL,GetRecommendUser,@"0"];
        NSString * zuixin = [NSString stringWithFormat:@"%@%@?type=1&userId=%@&token=%@&pageIndex=%@&pageSize=%@",INTERFACE_URL,GetArticleList,userId,User_TOKEN,@"1",@"10"];
        
        NSURLRequest * request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:jingxuan]];
        NSURLRequest * request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:tuijian]];
        NSURLRequest * request3 = [NSURLRequest requestWithURL:[NSURL URLWithString:zuixin]];
        //任务1 精选动态
        AFHTTPRequestOperation * operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
        //任务2 推荐用户
        AFHTTPRequestOperation * operation2 = [[AFHTTPRequestOperation alloc] initWithRequest:request2];
        //任务3 最新用户
        AFHTTPRequestOperation * operation3 = [[AFHTTPRequestOperation alloc] initWithRequest:request3];
        
        
        NSArray * operations = [AFHTTPRequestOperation batchOfRequestOperations:@[operation1,operation2,operation3] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
            NSLog(@"%ld",numberOfFinishedOperations);
            
        } completionBlock:^(NSArray * _Nonnull operations) {
            
            
        }];
        
        [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            AFHTTPRequestOperation * result1 = operation;
            NSDictionary * dict1 = [result1.responseString objectFromJSONString];
            for (NSDictionary * data in dict1[@"Data"]) {
                ECTimeLineModel*model = [self sortByData:data];
                [weakSelf.dataArray addObject:model];
            }
            NSLog(@"operation1 is complete");
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
            
        }];
        
        [operation2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            AFHTTPRequestOperation * result2 = operation;
            NSDictionary * dict2 = [result2.responseString objectFromJSONString];
            for (NSDictionary * data in dict2[@"Data"]) {
                CommentUserModel*model = [CommentUserModel new];
                model.name = data[@"nickName"];
                model.url = data[@"photoUrl"];
                model.ID = [data[@"userId"] integerValue];
                model.isHeart = [data[@"isHeart"] boolValue];
                [weakSelf.commentArray addObject:model];
            }
            NSLog(@"operation2 is complete");
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        [operation3 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            AFHTTPRequestOperation * result3 = operation;
            NSDictionary * dict3 = [result3.responseString objectFromJSONString];
            for (NSDictionary * data in dict3[@"Data"]) {
                    ECTimeLineModel*model = [self sortByData:data];
                maxPageSize = [[data objectForKey:@"RowCounts"] integerValue]/10;
                    [weakSelf.newerArray addObject:model];
                }
            NSLog(@"operation3 is complete");
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"tableview reloaddata");
                self.tableView.hidden = NO;
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            }];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
    
        
        [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
        
    }else {
        //关注的人
        
        
    }
    
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
    if ([data[@"LikeUserList"] count]) {
        for (NSDictionary * like in data[@"LikeUserList"]) {
            ECTimeLineCellLikeItemModel*likeModel = [ECTimeLineCellLikeItemModel new];
            likeModel.userId = like[@"UserID"];
            likeModel.userName = like[@"NickName"];
            [likeArr addObject:likeModel];
        }
    }
   
    NSMutableArray * commentArr = [NSMutableArray array];
    if ([data[@"commentList"] count]) {
        for (NSDictionary * comment in data[@"commentList"]) {
            ECTimeLineCellCommentItemModel*commentModel = [ECTimeLineCellCommentItemModel new];
            commentModel.firstUserName = comment[@"commNickName"];
            NSString * commentText = [comment[@"commContent"] stringByRemovingPercentEncoding];
            commentText = [commentText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            commentText = [commentText stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            commentModel.commentString = commentText;
            commentModel.firstUserId = comment[@"commUserId"];
            [commentArr addObject:commentModel];
        }
    }
    model.likeItemsArray = likeArr;
    model.commentItemsArray = commentArr;
    return model;
}

/**
 *  GET
 */

- (UIView*)navMenuView {
    if (!_navMenuView) {
        _navMenuView = [[NavMenuView alloc] initWithDatas:self.menuDataArray];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_navMenuView];
    }
    return _navMenuView;
}

- (NSMutableArray*)menuDataArray {
    if (!_menuDataArray) {
        _menuDataArray = [NSMutableArray array];
    }
    return _menuDataArray;
}


- (void)toolBar {
    
    if (!text) {
        text = [UITextField new];
        [self.view addSubview:text];
        text.delegate = self;
    }
    
    UITextField*toolText = [[UITextField alloc] initWithFrame:CGRectMake(5, 3, self.view.frame.size.width - 30, 45)];
    toolText.borderStyle = UITextBorderStyleRoundedRect;
    toolText.placeholder = @"评论";
    toolText.delegate = self;
    toolText.returnKeyType = UIReturnKeySend;
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithCustomView:toolText],
                           
                           nil];
    [numberToolbar sizeToFit];

    text.inputAccessoryView = numberToolbar;
    [text becomeFirstResponder];
    [toolText becomeFirstResponder];
    
}


- (void)setup {
    
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(200, 10, 150, 50)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(showFromNavigation) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:button];
    
    titleLabel = [UILabel new];
    titleLabel.text = selectedModel.name;
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
    [tableView registerClass:[ECRecommendCell class] forCellReuseIdentifier:kCommentUserCellId];
    [self.view addSubview:tableView];
    tableView.hidden = YES;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.tableView = tableView;
    self.tableView.mj_header = [GifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}


#pragma mark Actions

//Navigation Action
- (void)showFromNavigation {
    if (self.navMenuView) {
        self.navMenuView.delegate = self;
        [self.navMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@60);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(@150);
            make.height.equalTo(@(self.menuDataArray.count * 50));
        }];
        
        
    }else {
        [self.navMenuView removeFromSuperview];
        self.navMenuView = nil;
    }
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

- (void)loadMoreData {
    currentPage ++;
    if (currentPage >= maxPageSize) {
        currentPage = maxPageSize;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [[AppHttpManager shareInstance] getGetArticleListWithType:@"1" Userid:userId Token:User_TOKEN PageIndex:[NSString stringWithFormat:@"%ld",(long)currentPage] PageSize:@"10" PostOrGet:@"get" success:^(NSDictionary *dict) {
        for (NSDictionary * data in dict[@"Data"]) {
            ECTimeLineModel*model = [self sortByData:data];
            [weakSelf.newerArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        });
        
    } failure:^(NSString *str) {
        
    }];
}

/**
 *  发送评论接口
 *
 *  @return
 */

- (void)sendCommend:(NSString*)message {
    
    [[AppHttpManager shareInstance] postAddCommentOfArticleWithArticleId:[commendModel.ID intValue] PId:0 Content:message CommUserId:[userId intValue] token:User_TOKEN PostOrGet:@"get" success:^(NSDictionary *dict) {
        
        
    } failure:^(NSString *str) {
        
    }];
}

- (void)sendReply:(NSString*)message {
    
}


#pragma mark NavMenuViewDelegate
- (void)didSelected:(NSIndexPath *)indexPath item:(ECNavMenuModel *)model {
    pageType = indexPath.row;
    titleLabel.text = model.name;
    [self.navMenuView removeFromSuperview];
    self.navMenuView = nil;
    [self getData];
}


#pragma mark UITableViewDelegate

- (void)didActionInCell:(UITableViewCell *)cell actionType:(ECTimeLineCellActionType)type atIndexPath:(NSIndexPath *)indexPath {
    
    switch (type) {
        case ECTimeLineCellActionTypeShare:
            [self share:self.dataArray[indexPath.row]];
            break;
        case ECTimeLineCellActionTypeLike:
            [self doLike:self.dataArray[indexPath.row] indexPath:indexPath];
            break;
        case ECTimeLineCellActionTypeComment:
            [self doComment:self.dataArray[indexPath.row] indexPath:indexPath];
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        id model = indexPath.section == 0? self.dataArray[indexPath.row]:self.newerArray[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ECTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
    }else {
        return 150;
    }
    
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
    if (section == 0) {
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
    }else
    {
        return [UIView new];
    }

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 2) {
        ECTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
        cell.indexPath = indexPath;
        __weak typeof(self) weakSelf = self;
        if (!cell.moreButtonClickedBlock) {
            [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
                ECTimeLineModel *model = indexPath.section == 0? weakSelf.dataArray[indexPath.row]:weakSelf.newerArray[indexPath.row];
                model.isOpening = !model.isOpening;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            cell.delegate = self;
        }
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        cell.model = indexPath.section == 0? weakSelf.dataArray[indexPath.row]:weakSelf.newerArray[indexPath.row];
        
        if (indexPath.section == 2 && indexPath.row == [self.newerArray count] - 1) {
            [self loadMoreData];
        }
        
        
        return cell;
    }else {
        
        ECRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentUserCellId];
        cell.datas = self.commentArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.dataArray count];
    }else if (section == 2){
        return [self.newerArray count];
    }
    else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
- (void)doComment:(ECTimeLineModel*)model indexPath:(NSIndexPath*)indexPath{
    
//    UITableViewCell*cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    CGFloat cellBottom = cell.frame.size.height + cell.frame.origin.y;
    commendModel = model;
    
    [self toolBar];
}


//点赞
- (void)doLike:(ECTimeLineModel*)model indexPath:(NSIndexPath*)indexPath{
    selectedLikeModel = model;
}


#pragma mark  UIKeyboardNotification 
- (void)keyboardWillShow:(NSNotification*)notifi {
    
}

- (void)keyboardWillHide:(NSNotification*)notifi {
    
}

- (void)keyboardDidChange:(NSNotification*)notifi {
    [text resignFirstResponder];
    
}


#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //发送评论
    
    
    
    [textField resignFirstResponder];
    return YES;
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
