//
//  EnergyPostTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "EnergyPostTableViewController.h"
#import "SDAutoLayout.h"
#import "ECTimeLineModel.h"
#import "ECTimeLineCell.h"
#import "ECTimeLineCellLikeItemModel.h"
#import "ECTimeLineCellCommentItemModel.h"
#import "XMShareView.h"

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
    NSLog(@"%@",[notification.userInfo[@"userId"] class]);
    NSDictionary *dic = notification.userInfo;
    NSString *userId = dic[@"userId"];
//    NSString *token = dic[@"token"];
    
    [[AppHttpManager shareInstance] getGetArticleListWithType:@"0" Userid:userId Token:@"" PageIndex:[NSString stringWithFormat:@"%ld", self.startPage] PageSize:@"10" PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1)  {
            for (NSDictionary *data in dict[@"Data"]) {
                ECTimeLineModel *model = [self sortByData:data];
                NSLog(@"222%@", model.name);
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            NSLog(@"1%@",self.dataArray);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"%@",dic[@"Msg"]);
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startPage = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:@"EnergyPostTableViewController" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ECTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
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
    [self like:model indexPath:indexPath];
}

- (void)like:(ECTimeLineModel*)model indexPath:(NSIndexPath*)indexPath{
    
    model.liked = !model.liked;
    NSMutableArray * likes = model.likeItemsArray;
    if (!model.liked) {
        //删除点赞名
        for (ECTimeLineCellLikeItemModel *model in likes) {
            if ([model.userId isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
                NSLog(@"删除了点赞人%@",model.userName);
                [likes removeObject:model];
            }
        }
        
    }else {
        //添加点赞名
        ECTimeLineCellLikeItemModel *likeModel = [ECTimeLineCellLikeItemModel new];
        likeModel.userId = [NSString stringWithFormat:@"%@",User_ID];
        likeModel.userName = User_NAME;
        [model.likeItemsArray addObject:likeModel];
    }
    
    if (pageType == 0) {
        if (indexPath.section == 0) {
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        }else if (indexPath.section == 0) {
            [self.newerArray replaceObjectAtIndex:indexPath.row withObject:model];
        }
    }else {
        [self.attentionArray replaceObjectAtIndex:indexPath.row withObject:model];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self postLike:model];
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
