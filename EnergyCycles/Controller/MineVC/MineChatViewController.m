//
//  MineChatViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MineChatViewController.h"
#import "MineChatTableViewCell.h"
#import "MineChatLeftTableViewCell.h"

@interface MineChatViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation MineChatViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = self.dataArray[indexPath.row];
    if ([model.MessagePeople isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
        static NSString *mineChatTableViewCell = @"mineChatTableViewCell";
        MineChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineChatTableViewCell];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineChatTableViewCell" owner:self options:nil].firstObject;
        }
        
        cell.userInteractionEnabled = NO;
        
        [cell updateDataWithModel:model];
        
        return cell;
    } else {
        static NSString *mineChatLeftTableViewCell = @"mineChatLeftTableViewCell";
        MineChatLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineChatLeftTableViewCell];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MineChatLeftTableViewCell" owner:self options:nil].firstObject;
        }
        
        cell.userInteractionEnabled = NO;
        
        [cell updateDataWithModel:model];
        
        return cell;
    }
    
}

- (void)updateData {
    [[AppHttpManager shareInstance] getGetTalkListWithUserid:[User_ID intValue] withUseredId:[self.useredId intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in dict[@"Data"]) {
                MessageModel *model = [[MessageModel alloc] initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
    [self createTableView];
    [self createTextField];
    [self updateData];
    // Do any additional setup after loading the view.
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineChatTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MineChatTableViewCell class])];
    [self.view addSubview:self.tableView];
}
- (IBAction)sendButton:(id)sender {
    NSLog(@"%@",self.textField.text);
    if (![self.textField.text isEqualToString:@""] && self.textField.text != nil) {
        [[AppHttpManager shareInstance] getAddMessageWithUserid:[User_ID intValue] withUseredId:[self.useredId intValue] content:self.textField.text PostOrGet:@"get" success:^(NSDictionary *dict) {
            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
                self.textField.text = @"";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else {
//            [SVProgressHUD showImage:nil status:dict[@"Msg"] maskType:SVProgressHUDMaskTypeClear];
            }
        } failure:^(NSString *str) {
            NSLog(@"%@", str);
        }];
    }
}

- (void)createTextField {
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
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
