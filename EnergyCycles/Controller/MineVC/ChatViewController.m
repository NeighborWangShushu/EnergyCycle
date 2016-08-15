//
//  ChatViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/22.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "ChatViewController.h"

#import "JiaoLiuListModel.h"

#import "UUInputFunctionView.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "GifHeader.h"

@interface ChatViewController () <UITableViewDataSource,UITableViewDelegate,UUInputFunctionViewDelegate,UUMessageCellDelegate> {
    NSMutableArray *_dataArr;
    NSMutableArray *_subDataArr;
    
    UITableView *chatTableView;
    
    BOOL _isRefresh;
    BOOL _isAddData;
    int _showPage;
    
    int dataCount;
}

@property (strong, nonatomic) ChatModel *chatModel;

@end

@implementation ChatViewController {
    UUInputFunctionView *IFView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.chatTitleStr;
    _dataArr = [[NSMutableArray alloc] init];
    _subDataArr = [[NSMutableArray alloc] init];
    
    self.title = self.otherName;
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height-50-64) style:UITableViewStylePlain];
    chatTableView.showsHorizontalScrollIndicator = NO;
    chatTableView.showsVerticalScrollIndicator = NO;
    chatTableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    chatTableView.dataSource = self;
    chatTableView.delegate = self;
    [chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;// 1.注册cell
    [chatTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:chatTableView];
    
    [self loadDataWithIndexPage:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    
    _showPage = 0;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

//设置MJResfresh
- (void)setUpMJRefresh {
    __unsafe_unretained __typeof(self) weakSelf = self;
    chatTableView.mj_header = [GifHeader headerWithRefreshingBlock:^{
        _showPage++;
        [weakSelf loadDataWithIndexPage:_showPage];
    }];
    
    [chatTableView.mj_header beginRefreshing];
}
//结束刷新
- (void)endRefresh {
    [chatTableView.mj_header endRefreshing];
}
//加载网络数据
- (void)loadDataWithIndexPage:(NSInteger)pages {
    //
    if (self.touchIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isNewsTwoDetailChange" object:@{@"type":@"1",@"index":self.touchIndex}];
    }
    
    [[AppHttpManager shareInstance] getGetTalkListWithUserid:[User_ID intValue] withUseredId:[self.otherID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        [_subDataArr removeAllObjects];
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            NSMutableArray *subArr = [[NSMutableArray alloc] init];
            for (NSDictionary *subDict in dict[@"Data"]) {
                MessageModel *model = [[MessageModel alloc] initWithDictionary:subDict error:nil];
                [subArr addObject:model];
            }
            
            //
            for (NSInteger i=subArr.count-1; i>=0; i--) {
                MessageModel *model = (MessageModel *)subArr[i];
                [_subDataArr addObject:model];
            }
            [self endRefresh];
        }else {
            [self endRefresh];
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
        
        if (_subDataArr.count) {
            for (MessageModel *messageModel in _subDataArr) {
                JiaoLiuListModel *model = [[JiaoLiuListModel alloc] init];
                model.nickname = @"";
                
                model.content = [messageModel.MessageContent stringByRemovingPercentEncoding];
                model.mark = @"3";
                model.type = @"0";
                model.ismy = @"0";
                
                if ([User_ID integerValue] == [messageModel.MessagePeople integerValue]) {
                    model.isitself = @"1";
                    model.headpic = messageModel.bImg;
                }else {
                    model.isitself = @"0";
                    model.headpic = messageModel.bImg;
                }
                
                if ([model.headpic isEqual:[NSNull null]] || [model.headpic isKindOfClass:[NSNull class]] || model.headpic == nil) {
                    model.headpic = @"";
                }
                NSArray *timeArr = [messageModel.MessageTime componentsSeparatedByString:@"T"];
                NSArray *subTimeArr = [timeArr.lastObject componentsSeparatedByString:@"."];
                model.createtime = [NSString stringWithFormat:@"%@ %@",timeArr.firstObject,subTimeArr.firstObject];
                
                [_dataArr addObject:model];
            }
            
        }
        [self loadBaseViewsAndData];
    } failure:^(NSString *str) {
        [self endRefresh];
        NSLog(@"%@",str);
    }];
}

#pragma mark - 返回按键
- (void)leftAction {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] resignFirstResponder];
}

- (void)loadBaseViewsAndData {
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    [self.chatModel populateRandomDataSourceWithModel:_dataArr];
    
    IFView = [[UUInputFunctionView alloc] initWithSuperVC:self];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    
    [chatTableView reloadData];
    [self tableViewScrollToBottom];
}

-(void)keyboardChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView animateWithDuration:0.1 animations:^{
        if (notification.name == UIKeyboardWillShowNotification) {
            CGRect rect = chatTableView.frame;
            rect.size.height = Screen_Height-64-keyboardEndFrame.size.height-50;
            chatTableView.frame = rect;
        }else{
            CGRect rect = chatTableView.frame;
            rect.size.height = Screen_Height-50-64;
            chatTableView.frame = rect;
        }
    }];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        CGRect rect = chatTableView.frame;
        rect.size.height = Screen_Height-64-keyboardEndFrame.size.height-50;
        chatTableView.frame = rect;
        
//        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
        IFView.frame = CGRectMake(0, Screen_Height-64-keyboardEndFrame.size.height-50, Screen_width, 50);
    }else{
        CGRect rect = chatTableView.frame;
        rect.size.height = Screen_Height-50-64;
        chatTableView.frame = rect;
        
//        self.bottomConstraint.constant = 40;
        IFView.frame = CGRectMake(0, Screen_Height-64-50, Screen_width, 50);
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
//    CGRect newFrame = IFView.frame;
//    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
//    IFView.frame = newFrame;
    
    [UIView commitAnimations];
}

#pragma mark - tableView滚动到底部
- (void)tableViewScrollToBottom {
    if (self.chatModel.dataSource.count==0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    
    if (dataCount != 0) {
        if (_isRefresh) {
            indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-dataCount inSection:0];
            _isRefresh = NO;
        }
    }
    
    [chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    dataCount = (int)self.chatModel.dataSource.count;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    cell.delegate = self;
    
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 将输入的内容放到数组里面
- (void)dealTheFunctionData:(NSDictionary *)dic {
    [self.chatModel addSpecifiedItem:dic];
    
    [chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - InputFunctionViewDelegate
//上传文字
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message {
    if (message.length > 0) {
        NSDictionary *dic = @{@"strContent": message,
                              @"type": @(UUMessageTypeText)};
        funcView.TextViewInput.text = @"";
        [funcView changeSendBtnWithPhoto:YES];
        [self dealTheFunctionData:dic];
        
        [self postContentDataWith:message withMark:0];
        [[IQKeyboardManager sharedManager] resignFirstResponder];
    }
}
//上传图片
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image {
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    [self updateUserHeadImageViewWithData:imageData withType:1];
}
//上传声音
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second {
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
    
    [self updateUserHeadImageViewWithData:voice withType:2];
}

#pragma mark - 上传文字数据
- (void)postContentDataWith:(NSString *)str withMark:(int)mark {
    NSString *postStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[AppHttpManager shareInstance] getAddMessageWithUserid:[User_ID intValue] withUseredId:[self.otherID intValue] content:postStr PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
//            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }else {
//            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 上传图片，音频数据
- (void)updateUserHeadImageViewWithData:(NSData *)data withType:(int)type {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
