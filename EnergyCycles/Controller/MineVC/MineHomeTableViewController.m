//
//  MineHomeTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineHomeTableViewController.h"

#import "MineHomeView.h"
#import "HMSegmentedControl.h"

#import "ChatViewController.h"
#import "MyProfileViewController.h"

#import "EnergyPostTableViewController.h"
#import "PKRecordTableViewController.h"
#import "ToDayPKTableViewController.h"

@interface MineHomeTableViewController ()
<TabelViewScrollingProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UserModel *model;
@property (nonatomic, strong) UserInfoModel *infoModel;

@property (nonatomic, strong) MineHomeView *mineView;
@property (nonatomic, strong) HMSegmentedControl *segControl;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) EnergyPostTableViewController *energyVC;
@property (nonatomic, strong) PKRecordTableViewController *pkVC;
@property (nonatomic, strong) ToDayPKTableViewController *toDayVC;

@end

@implementation MineHomeTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self getUserInfo];
    [self getUserInfoModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnergyPostTableViewController" object:self userInfo:@{@"userId" : self.userId}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PKRecordTableViewController" object:self userInfo:@{@"userId" : self.userId}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToDayTableViewController" object:self userInfo:@{@"userId" : self.userId}];
    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mineHomePageReloadView) name:@"mineHomePageReloadView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headViewChangeHeadImage) name:@"headViewChangeHeadImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headViewChangeBackgroundImage) name:@"headViewChangeBackgroundImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToAttentionController) name:@"jumpToAttentionController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToFansController) name:@"jumpToFansController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToIntroViewController) name:@"jumpToIntroViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HomePageViewControllerReloadData) name:@"HomePageViewControllerReloadData" object:nil];
}

- (void)HomePageViewControllerReloadData {
    [self getUserInfo];
    [self getUserInfoModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 获取用户基本数据
- (void)getUserInfo {
    [[AppHttpManager shareInstance] getGetInfoByUseridWithUserid:self.userId PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if ([dict[@"Data"] count]) {
                for (NSDictionary *subDict in dict[@"Data"]) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:subDict error:nil];
                    self.model = model;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addNavgationTitle];
                [self.mineView getdateDataWithModel:self.model userInfoModel:self.infoModel];
            });
        }
        
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

// 获取关注数,粉丝数等数据
- (void)getUserInfoModel {
    
    [[AppHttpManager shareInstance] getGetUserInfoWithUserid:[User_ID == NULL ? 0 : User_ID intValue] OtherUserID:[self.userId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dict[@"Data"][0] error:nil];
            self.infoModel = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 判断是否是自己的主页
                if ([self.userId integerValue] == [User_ID integerValue]) {
                    [self moreButton];
                } else {
                    [self attentionButton];
                }
                //                [self addNavgationTitle];
                self.titleLabel.text = self.model.nickname;
                [self.mineView getdateDataWithModel:self.model userInfoModel:self.infoModel];
            });
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

// 添加更多按钮
- (void)moreButton {
    UIImage *image = [UIImage imageNamed:@"more"];
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickMoreButton)];
    self.navigationItem.rightBarButtonItem = moreButton;
}

- (void)clickMoreButton {
    MyProfileViewController *myVC = MainStoryBoard(@"MyProfileViewController");
    myVC.model = self.model;
    [self.navigationController pushViewController:myVC animated:YES];
}

// 添加关注按钮
- (void)attentionButton {
    UIImage *image = [[UIImage alloc] init];
    if ([self.infoModel.IsGuanZhu intValue] == 1) {
        image = [UIImage imageNamed:@"Guanzhu"];
    } else {
        image = [UIImage imageNamed:@"addGuanzhu"];
    }
    UIButton *attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionButton.frame = CGRectMake(30, 0, 49, 20);
    [attentionButton setImage:image forState:UIControlStateNormal];
    [attentionButton addTarget:self action:@selector(clickAttentionButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *attentionBarButton = [[UIBarButtonItem alloc] initWithCustomView:attentionButton];
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.frame = CGRectMake(20, 0, 49, 20);
    [chatButton setImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(jumpChatViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *chatBarButton = [[UIBarButtonItem alloc] initWithCustomView:chatButton];
    self.navigationItem.rightBarButtonItems = @[attentionBarButton, chatBarButton];
    //    self.navigationItem.rightBarButtonItem = chatButton;
    //    self.navigationItem.rightBarButtonItem = attentionButton;
}

- (void)jumpChatViewController {
    ChatViewController *chatVC = MainStoryBoard(@"ChatViewVCID");
    chatVC.otherName = self.model.nickname;
    chatVC.otherID = self.userId;
    [self.navigationController pushViewController:chatVC animated:YES];
    //    MineChatViewController *chatVC = MainStoryBoard(@"MineChatViewController");
    //    chatVC.useredId = self.userId;
    //    chatVC.chatName = self.model.nickname;
    //    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)clickAttentionButton {
    if ([self.infoModel.IsGuanZhu intValue] == 1) {
        [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:2 UserId:[User_ID intValue] Token:User_TOKEN OUserId:[self.userId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"已取消关注" maskType:SVProgressHUDMaskTypeClear];
                self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"addGuanzhu"];
                [self getUserInfoModel];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    } else {
        [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:1 UserId:[User_ID intValue] Token:User_TOKEN OUserId:[self.userId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"关注成功" maskType:SVProgressHUDMaskTypeClear];
                self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"Guanzhu"];
                [self getUserInfoModel];
            }else {
                [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] size:CGSizeMake(kScreenWidth, 64)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    [self createHeaderView];
    [self addControl];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)createHeaderView {
    self.mineView = [[NSBundle mainBundle] loadNibNamed:@"MineHomeView" owner:nil options:nil].lastObject;
    self.mineView.frame = CGRectMake(0, 0, kScreenWidth, kHeaderImgHeight);
    self.tableView.tableHeaderView = self.mineView;
}

- (void)addNavgationTitle {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.model.nickname;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel sizeToFit];
    self.titleLabel.hidden = YES;
    self.navigationItem.titleView = self.titleLabel;
}

// 创建分段控件
- (void)createSegmentControl {
    self.segControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 40)];
    self.segControl.sectionTitles = @[@"能量帖          ",@"PK记录          ",@"今日PK          "];
    // 横线的高度
    self.segControl.selectionIndicatorHeight = 2.0f;
    // 背景颜色
    self.segControl.backgroundColor = [UIColor whiteColor];
    // 横线的颜色
    self.segControl.selectionIndicatorColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    // 横线在底部出现
    self.segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    // 横线根据文本的长度自适应长度
    self.segControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    // 为选中时的文本样式
    self.segControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:14]};
    // 选中后的文本样式
    self.segControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:242/ 255.0 green:77/255.0 blue:77/255.0 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:14]};
    // 初始位置
    if (self.isPK) {
        self.segControl.selectedSegmentIndex = 2;
    } else {
        self.segControl.selectedSegmentIndex = 0;
    }
    // 边界样式
    self.segControl.borderType = HMSegmentedControlBorderTypeBottom;
    // 边界颜色
    self.segControl.borderColor = [UIColor lightGrayColor];
    // 触发方法
    [self.segControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

// 添加列表
- (void)addControl {
    self.energyVC = [[EnergyPostTableViewController alloc] init];
    self.energyVC.tableView.showsVerticalScrollIndicator = NO;
    self.energyVC.delegate = self;
    self.pkVC = [[PKRecordTableViewController alloc] init];
    self.pkVC.tableView.showsVerticalScrollIndicator = NO;
    self.pkVC.delegate = self;
    self.toDayVC = [[ToDayPKTableViewController alloc] init];
    self.toDayVC.tableView.showsVerticalScrollIndicator = NO;
    self.toDayVC.delegate = self;
    
    CGRect frame = self.view.bounds;
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    CGSize size = frame.size;
    size.width = frame.size.width * 3;
    self.scrollView.contentSize = size;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:self.energyVC.view];
    frame.origin.x += frame.size.width;
    self.pkVC.view.frame = frame;
    [self.scrollView addSubview:self.pkVC.view];
    frame.origin.x += frame.size.width;
    self.toDayVC.view.frame = frame;
    [self.scrollView addSubview:self.toDayVC.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.scrollView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self createSegmentControl];
    return self.segControl;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    cell.frame = self.view.bounds;
    [cell addSubview:self.scrollView];
    // Configure the cell...
    
    return cell;
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
