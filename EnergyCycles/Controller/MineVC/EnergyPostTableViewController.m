//
//  EnergyPostTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "EnergyPostTableViewController.h"
#import "MineHomePageViewController.h"
#import "SDAutoLayout.h"
#import "ECTimeLineModel.h"
#import "ECTimeLineCell.h"
#import "ECTimeLineCellLikeItemModel.h"
#import "ECTimeLineCellCommentItemModel.h"
#import "XMShareView.h"
#import "PostingViewController.h"
#import "CommentUserModel.h"
#import "Masonry.h"
#import "GifHeader.h"
#import "WebVC.h"

#define kTimeLineTableViewCellId @"ECTimeLineCell"

@interface EnergyPostTableViewController ()<ECTimeLineCellDelegate,UITextFieldDelegate> {
    UITextField *text; // 键盘弹出框
    
    ECTimeLineModel *commendModel; // 评论model
    NSInteger commentIndex; // 点击评论的索引(那条cell)
    NSInteger commentSection; // 点击评论在那个组
    
    ECTimeLineModel *selectedLikeModel; // 点赞model
    
}

@property (nonatomic, strong) XMShareView *shareView;

@property (nonatomic, assign) NSInteger startPage;

@property (nonatomic, assign) NSInteger maxPage;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation EnergyPostTableViewController

// 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

// 获取数据
- (void)getData:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *userId = dic[@"userId"];
    self.userId = userId;
    NSLog(@"notification userid = %@", self.userId);
    [self getDataWithUserId:self.userId];
}

- (void)getDataWithUserId:(NSString *)userId {
    [[AppHttpManager shareInstance] getGetArticleListWithType:@"0" Userid:[NSString stringWithFormat:@"%@", User_ID] OtherUserId:userId Token:@"" PageIndex:[NSString stringWithFormat:@"%ld", self.startPage] PageSize:@"10" PostOrGet:@"get" success:^(NSDictionary *dict) {
        if (self.startPage == 0) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *data in dict[@"Data"]) {
            ECTimeLineModel *model = [self sortByData:data];
            [self.dataArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRefresh];
            if ((self.startPage + 1) * 10 >= self.dataArray.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        });
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@", str);
    }];
}


- (void)loadNewData {
    self.startPage = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnergyPostTableViewController" object:self userInfo:@{@"userId" : self.userId}];
}

- (void)loadMoreData {
    self.startPage ++;
    if (self.startPage >= self.maxPage) {
        self.startPage = self.maxPage;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnergyPostTableViewController" object:self userInfo:@{@"userId" : self.userId}];
}

// 数据转模型
- (ECTimeLineModel *)sortByData:(NSDictionary *)data {
    ECTimeLineModel*model = [ECTimeLineModel new];
    model.iconName = data[@"photoUrl"];
    model.name = data[@"nickName"];
    model.ID = [NSString stringWithFormat:@"%@",data[@"artId"]];
    NSString *informationStr = [data[@"artContent"] stringByRemovingPercentEncoding];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    informationStr = [informationStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    model.UserID = [NSString stringWithFormat:@"%@", data[@"userId"]];
    model.msgContent = informationStr;
    model.location = data[@"address"];
    model.time = data[@"createTime"];
    model.picNamesArray = data[@"artPic"];
    model.liked = [data[@"isHasLike"] boolValue];
    NSLog(@"liked is = %@", model.liked ? @"YES" : @"NO");
    NSMutableArray * likeArr = [NSMutableArray array];
    for (NSDictionary * like in data[@"LikeUserList"]) {
        ECTimeLineCellLikeItemModel*likeModel = [ECTimeLineCellLikeItemModel new];
        likeModel.userId = [NSString stringWithFormat:@"%@",like[@"UserID"]];
        likeModel.userName = like[@"NickName"];
        [likeArr addObject:likeModel];
    }
    NSMutableArray * commentArr = [NSMutableArray array];
    for (NSDictionary * comment in data[@"commentList"]) {
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

- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        self.startPage = 0;
        [weakSelf getDataWithUserId:self.userId];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.startPage ++;
        [weakSelf getDataWithUserId:self.userId];
    }];
//    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startPage = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.isMineTableView) {
        [self getDataWithUserId:self.userId];
        self.tableView.tableHeaderView = nil;
        self.title = @"能量贴";
        self.navigationController.navigationBar.translucent = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 50);
        [self setupLeftNavBarWithimage:@"loginfanhui"];

//        self.tabBarController.tabBar.hidden = YES;
        
    }
    
    [self setUpMJRefresh];
    
    [IQKeyboardManager sharedManager].enable = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:@"EnergyPostTableViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCyclePostView:) name:@"EnergyCycleViewToPostView" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataArray[indexPath.row];
    CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ECTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
    return height;
}

// cell 高度适配
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

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

// cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    ///////////////////////////////////////////////////////////////////////
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ECTimeLineModel *model = self.dataArray[indexPath.row];
    WebVC *webVC = MainStoryBoard(@"WebVC");
    webVC.titleName = @"动态详情";
    webVC.url = [NSString stringWithFormat:@"%@%@?aid=%@&userId=%@",INTERFACE_URL,ArticleDetailAspx,model.ID,[NSString stringWithFormat:@"%@",User_ID]];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 分享
- (void)share:(ECTimeLineModel*)model {
    
    self.shareView = [[XMShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
    self.shareView.alpha = 0.0;
    self.shareView.shareTitle = model.msgContent;
    
    self.shareView.shareText = @"";
    NSString * share_url = @"";
    share_url = [NSString stringWithFormat:@"%@/%@?id=%@",INTERFACE_URL,StudyDetailAspx,model.ID];
    self.shareView.shareUrl = [NSString stringWithFormat:@"%@&is_Share=1",share_url];
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
    [UIView animateWithDuration:0.25 animations:^{
        self.shareView.alpha = 1.0;
    }];
}

//评论
- (void)doComment:(ECTimeLineModel*)model indexPath:(NSIndexPath*)indexPath{
    
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
        return;
    }
    commentIndex = indexPath.row;
    commentSection = indexPath.section;
    commendModel = model;
    [self showKeyboard];
}

//点赞
- (void)doLike:(ECTimeLineModel*)model indexPath:(NSIndexPath*)indexPath{
    
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
        return;
    }
    selectedLikeModel = model;
    NSLog(@"2liked is = %@", model.liked ? @"YES" : @"NO");
    [self like:model indexPath:indexPath];
}

- (void)like:(ECTimeLineModel*)model indexPath:(NSIndexPath*)indexPath{
    
    model.liked = !model.liked;
    NSLog(@"3liked is = %@", model.liked ? @"YES" : @"NO");
    NSMutableArray * likes = model.likeItemsArray;
    if (!model.liked) {
        //删除点赞名
        for (ECTimeLineCellLikeItemModel *model in likes) {
            if ([model.userId isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
                NSLog(@"删除了点赞人%@",model.userName);
                [likes removeObject:model];
                break;
            }
        }
        
    } else {
        //添加点赞名
        ECTimeLineCellLikeItemModel *likeModel = [ECTimeLineCellLikeItemModel new];
        likeModel.userId = [NSString stringWithFormat:@"%@",User_ID];
        
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        likeModel.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserNickName"];
        [model.likeItemsArray addObject:likeModel];
    }

    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self postLike:model];
    
}

/**
 *  调用点赞接口
 */
- (void)postLike:(ECTimeLineModel*)model {
    
    NSInteger OpeType = !model.liked;
    NSLog(@"4liked is = %@", model.liked ? @"YES" : @"NO");
    [[AppHttpManager shareInstance] postAddLikeOrNoLikeWithType:@"1" OpeType:[NSString stringWithFormat:@"%ld",(long)OpeType] ArticleId:[model.ID intValue] UserId:[User_ID intValue] token:[NSString stringWithFormat:@"%@",User_TOKEN] PostOrGet:@"post" success:^(NSDictionary *dict) {
        NSLog(@"5liked is = %@", model.liked ? @"YES" : @"NO");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mineHomePageReloadView" object:self];
        });
        
    } failure:^(NSString *str) {
        
    }];
   
}

/**
 *  弹出评论键盘
 */
- (void)showKeyboard {
    [self toolBar];
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

#pragma mark  Notification
- (void)keyboardWillShow:(NSNotification*)notifi {
    
}

- (void)keyboardWillHide:(NSNotification*)notifi {
    
}

- (void)keyboardDidChange:(NSNotification*)notifi {
    [text resignFirstResponder];
    
}


- (void)gotoCyclePostView:(NSNotification*)notifi {
    
    if ([User_TOKEN length] <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }else {
        PostingViewController * postView = MainStoryBoard(@"EnergyCycleViewToPostView");
        [self presentViewController:postView animated:YES completion:nil];
    }
    
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //发送评论
    NSLog(@"%@",textField.text);
    [self sendCommend:textField.text index:commentIndex section:commentSection];
    
    [textField resignFirstResponder];
    return YES;
}

/**
 *  发送评论接口
 *
 *  @return
 */

- (void)sendCommend:(NSString*)message index:(NSInteger)index section:(NSInteger)section {
    
    __weak typeof(self) weakSelf = self;
    
    [[AppHttpManager shareInstance] postAddCommentOfArticleWithArticleId:[commendModel.ID intValue] PId:0 Content:message CommUserId:[User_ID intValue] type:@"0" token:[NSString stringWithFormat:@"%@",User_TOKEN] PostOrGet:@"post" success:^(NSDictionary *dict) {
        NSDictionary*data = dict[@"Data"];
        ECTimeLineModel*model = [self sortByData:data];
        NSIndexPath*indexPath = [NSIndexPath indexPathForRow:index inSection:section];
        NSLog(@"%@",model.commentItemsArray);
        [weakSelf.dataArray replaceObjectAtIndex:index withObject:model];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mineHomePageReloadView" object:self];
        });
        
        [SVProgressHUD showImage:nil status:@"评论成功"];
        
    } failure:^(NSString *str) {
        
        
    }];
}

- (void)didDelete:(ECTimeLineModel *)model atIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除这条能量贴" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[AppHttpManager shareInstance] getDeleteArticleWithuserId:[model.UserID intValue] Token:User_TOKEN AType:1 AId:[model.ID intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"删除成功"];
                [self.dataArray removeObject:model];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didClickOtherUser:(UITableViewCell *)cell userId:(NSString *)userId userName:(NSString *)name {
    MineHomePageViewController *otherUserVC = MainStoryBoard(@"MineHomePageViewController");
    otherUserVC.userId = userId;
    [self.navigationController pushViewController:otherUserVC animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
