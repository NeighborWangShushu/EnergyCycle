//
//  EveryDayPKTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ToDayPKTableViewController.h"
#import "ToDayPKTableViewCell.h"
#import "BrokenLineViewController.h"

#import "XMShareView.h"

@interface ToDayPKTableViewController () {
    XMShareView *shareView;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL noData;

@end

@implementation ToDayPKTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)getData:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *userId = dic[@"userId"];
    [self getToDayPKDataWithUserId:userId];
}

- (void)getToDayPKDataWithUserId:(NSString *)userId {
    [[AppHttpManager shareInstance] getGetReportByUserWithUserid:[User_ID intValue] Token:User_TOKEN OUserId:[userId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in dict[@"Data"][@"reportItemInfo"]) {
                OtherReportModel *model = [[OtherReportModel alloc] initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:@"ToDayTableViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toDayViewControllerShare) name:@"ToDayViewControllerShare" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toDayViewControllerPost) name:@"ToDayViewControllerPost" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)toDayViewControllerShare {
    if (self.dataArray.count) {
        NSString *contentStr = @"";
        for (NSInteger i=0; i<self.dataArray.count; i++) {
            OtherReportModel *model = (OtherReportModel *)self.dataArray[i];
            
            if (i == self.dataArray.count-1) {
                contentStr = [NSString stringWithFormat:@"%@%@%@%@",contentStr,model.RI_Name,model.RI_Num,model.RI_Unit];
            }else {
                contentStr = [NSString stringWithFormat:@"%@%@%@%@、",contentStr,model.RI_Name,model.RI_Num,model.RI_Unit];
            }
        }
        NSString *shareStr = [NSString stringWithFormat:@"我今天%@，加入能量圈，和我一起PK吧！",contentStr];
        shareView = [[XMShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
        shareView.alpha = 0.0;
        shareView.shareTitle = shareStr;
        shareView.shareText = @"";
        NSString * share_url = @"";
        share_url = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",MYJYAppId];
        shareView.shareUrl = [NSString stringWithFormat:@"%@&is_Share=1",share_url];
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        [UIView animateWithDuration:0.25 animations:^{
            shareView.alpha = 1.0;
        }];
    } else {
        [SVProgressHUD showImage:nil status:@"今天你还没有进行PK哦"];
    }
}

- (void)toDayViewControllerPost {
    if (self.dataArray.count) {
        NSString *contentStr = @"";
        for (NSInteger i=0; i<self.dataArray.count; i++) {
            OtherReportModel *model = (OtherReportModel *)self.dataArray[i];
            
            if (i == self.dataArray.count-1) {
                contentStr = [NSString stringWithFormat:@"%@%@%@%@",contentStr,model.RI_Name,model.RI_Num,model.RI_Unit];
            }else {
                contentStr = [NSString stringWithFormat:@"%@%@%@%@、",contentStr,model.RI_Name,model.RI_Num,model.RI_Unit];
            }
        }
        NSString *postStr = [NSString stringWithFormat:@"我今天完成了%@，欢迎到每日PK来挑战我！【来自每日PK】",contentStr];
        NSLog(@"%@", postStr);
        [[AppHttpManager shareInstance] postAddArticleWithTitle:@"" Content:postStr VideoUrl:@"" UserId:[User_ID intValue] token:User_TOKEN List:nil Location:@"" UserList:nil PostOrGet:@"post" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                [SVProgressHUD showImage:nil status:@"能量帖发布成功!"];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    } else {
        [SVProgressHUD showImage:nil status:@"今天你还没有进行PK哦"];
    }
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
    if ([self.dataArray count] == 0) {
        self.noData = YES;
        return 1;
    } else {
        self.noData = NO;
        return  [self.dataArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *toDayPKTableViewCell = @"toDayPKTableViewCell";
        ToDayPKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:toDayPKTableViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ToDayPKTableViewCell" owner:self options:nil].lastObject;
        }
        
        if (self.noData) {
            [cell noData];
            return cell;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        OtherReportModel *model = self.dataArray[indexPath.row];
        [cell updateDataWithModel:model];
        
        // Configure the cell...
        
        return cell;
//    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    BrokenLineViewController *blVC = MainStoryBoard(@"BrokenLineViewController");
//    OtherReportModel *model = self.dataArray[indexPath.row];
//    blVC.projectID = model.repItemId;
//    blVC.showStr = model.RI_Name;
//    [self.navigationController pushViewController:blVC animated:YES];
//}

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
