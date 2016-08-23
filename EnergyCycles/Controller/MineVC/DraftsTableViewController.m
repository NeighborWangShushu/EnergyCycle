//
//  DraftTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DraftsTableViewController.h"
#import "DraftsTableViewCell.h"

@interface DraftsTableViewController () {
    NSMutableArray *_selectImgArrayLocal;
    NSInteger _tempIndex;
    NSMutableDictionary *postDict;
}

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, assign) NSIndexPath *index;

@end

@implementation DraftsTableViewController

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

//- (NSMutableArray *)imgArr {
//    if (!_imgArr) {
//        self.imgArr = [[NSMutableArray alloc] init];
//    }
//    return _imgArr;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *draftsTableViewCell = @"draftsTableViewCell";
    DraftsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:draftsTableViewCell];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DraftsTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DraftsModel *model = self.dataArr[indexPath.row];
    [cell getDraftsData:model indexPath:indexPath];
    return cell;
}

- (void)updateData {
//    [self.dataArr addObject:[DraftsModel findAll]];
    self.dataArr = [NSMutableArray arrayWithArray:[DraftsModel findAll]];
}

- (void)data {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [file stringByAppendingPathComponent:@"test.plist"];
    [manager createFileAtPath:filePath contents:nil attributes:nil];
//    NSURL *url = [NSURL URLWithString:@"http://upload.jianshu.io/users/upload_avatars/906714/d20e7718bb4a?imageMogr/thumbnail/90x90/quality/100"];
    NSString *string = @"http://upload.jianshu.io/users/upload_avatars/906714/d20e7718bb4a?imageMogr/thumbnail/90x90/quality/100";
    NSArray *array = @[string];
    [array writeToFile:filePath atomically:YES];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:filePath];
    NSLog(@"%@",plistArr);
}

- (void)addData {
    DraftsModel *model = [[DraftsModel alloc] init];
    model.context = @"foasdbofibdoiasfbsfb";
    model.time = @"2016-08-23";
//    model.imgLocalURL = @"test.plist";
    [model save];
    [self updateData];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    
}

- (void)republish:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    DraftsModel *model = dic[@"model"];
    self.index = dic[@"indexPath"];
    [postDict setObject:@"" forKey:@"title"];
    [postDict setObject:model.context forKey:@"content"];
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [file stringByAppendingPathComponent:model.imgLocalURL];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    for (int i = 0; i < array.count; i ++) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:array[i]]]];
        [_selectImgArrayLocal addObject:image];
    }
    [self submit];
}

- (void)submit {
    NSString * title=[postDict valueForKey:@"title"];
    NSString * context=[postDict valueForKey:@"content"];
    NSLog(@"title:%@----context:%@",title,context);
    if (context == nil ||[context isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"内容不能为空"];
        return;
    }
    if (context.length < 30) {
        [SVProgressHUD showImage:nil status:@"30字以上才能发表哦~"];
        return;
    }
    if ([User_TOKEN length] > 0) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"提交中.."];
        
        if(_selectImgArrayLocal.count) {
            
            NSData * data=UIImageJPEGRepresentation(_selectImgArrayLocal[0], 0.05);
            [self submitImage:data];
        }else {
            [self getURLContext];
        }
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }
    
}


-(void)submitImage:(NSData*)imageData {
    
    [[AppHttpManager shareInstance] postPostFileWithImageData:imageData PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            _tempIndex++;
            NSString * imgURL=[dict[@"Data"] firstObject];
            [_imgArr addObject:imgURL];
            NSLog(@"selectImgArrayLocal:%lu",(unsigned long)[_selectImgArrayLocal count]);
            if (_selectImgArrayLocal.count) {// 九张
                if(_tempIndex<_selectImgArrayLocal.count){
                    NSData * data=UIImageJPEGRepresentation(_selectImgArrayLocal[_tempIndex], 0.05);
                    NSLog(@"_tempIndex:%ld",(long)_tempIndex);
                    [self submitImage:data];
                }else{
                    // 提交数据
                    [self getURLContext];
                }
            }
        }else {
            // 网络出错
            [SVProgressHUD showImage:nil status:@"请检查网络"];
        }
    } failure:^(NSString *str) {
        NSLog(@"错误：%@",str);
        [SVProgressHUD dismiss];
    }];
}

-(void)getURLContext {
    
    NSString * title=[postDict valueForKey:@"title"];
    NSString * context=[postDict valueForKey:@"content"];
    
    title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    context = [context stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (context==nil) {
        [SVProgressHUD showImage:nil status:@"内容不能为空"];
        return;
    }
 
//    NSString *viderUrl = @"";
//    if (![postDict valueForKey:@"videoUrl"]) {
//        viderUrl = @"";
//    }else {
//        viderUrl = [postDict valueForKey:@"videoUrl"];
//    }
    
    [[AppHttpManager shareInstance] postAddArticleWithTitle:@"" Content:context VideoUrl:@"" UserId:[User_ID intValue] token:User_TOKEN List:_imgArr PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [SVProgressHUD showImage:nil status:@"发布成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView deleteRowsAtIndexPaths:@[self.index] withRowAnimation:UITableViewRowAnimationFade];
                DraftsModel *model = self.dataArr[self.index.row];
                [model deleteObject];
                [self.dataArr removeObjectAtIndex:self.index.row];
                [self.tableView reloadData];
            });
        }else {
            [_imgArr removeAllObjects];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"发布失败 %@",str);
        [SVProgressHUD dismiss];
        [_imgArr removeAllObjects];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateData];
    self.title = @"草稿箱";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    postDict = [[NSMutableDictionary alloc] init];
    _imgArr = [[NSMutableArray alloc] init];
    
    self.editButtonItem.title = @"编辑";
    self.editButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(republish:) name:@"Republish" object:nil];
    
    // Do any additional setup after loading the view.
}

#pragma mark -----删除-----

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (self.editing) {
        self.editButtonItem.title = @"完成";
    } else {
        self.editButtonItem.title = @"编辑";
    }
    [self.tableView setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    DraftsModel *model = self.dataArr[indexPath.row];
    [model deleteObject];
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [tableView endUpdates];
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
