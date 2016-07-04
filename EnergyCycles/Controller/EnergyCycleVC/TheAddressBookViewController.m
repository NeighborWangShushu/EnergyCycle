//
//  TheAddressBookViewController.m
//  EnergyCycles
//
//  Created by Adinnet on 15/12/16.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TheAddressBookViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "PhoneNumberModel.h"
#import "PhoneNumberViewCell.h"
#import "pinyin.h"

#import "GetPhoneModel.h"

@interface TheAddressBookViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    UISearchBar *mySearchBar;
    NSMutableArray *indexArr;
    
    NSMutableArray *phoneArr;
    NSMutableArray *getPhoneArr;
    NSMutableArray *searchArr;
}

@property (strong,nonatomic)  NSMutableArray *sourceContactArray;
@property (strong,nonatomic)  NSMutableArray *sortedContactArray;


@end

@implementation TheAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录好友";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
    
    searchArr = [[NSMutableArray alloc] init];
    phoneArr = [[NSMutableArray alloc] init];
    getPhoneArr = [[NSMutableArray alloc] init];
    
    self.sortedContactArray = [[NSMutableArray alloc] init];
    self.sourceContactArray = [[NSMutableArray alloc] init];
    indexArr = [[NSMutableArray alloc] init];
    
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 50)];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"搜索";
    mySearchBar.searchBarStyle = UISearchBarStyleMinimal;
    mySearchBar.showsCancelButton = YES;
    [self.searchBackView addSubview:mySearchBar];
    
    for(UIView *view in  [[[mySearchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel = (UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    
    UIView *headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, Screen_width, 1)];
    headLineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self.searchBackView addSubview:headLineView];
    
    addressBookTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    addressBookTableView.showsHorizontalScrollIndicator = NO;
    addressBookTableView.showsVerticalScrollIndicator = NO;
    addressBookTableView.backgroundColor = [UIColor clearColor];
    
    //设置索引属性
    addressBookTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    addressBookTableView.sectionIndexColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    addressBookTableView.sectionIndexTrackingBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    [self updateContact];
    //
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 实现搜索框代理事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchArr removeAllObjects];
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length==0) {
        searchArr = [NSMutableArray arrayWithArray:self.sortedContactArray];
        [addressBookTableView reloadData];
    }else {
        for (NSDictionary *dic in self.sortedContactArray) {
            NSArray *contentArray = dic[@"data"];
            NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",searchBar.text];
            NSArray *resultArray = [contentArray filteredArrayUsingPredicate:resultPredicate];
            if (resultArray.count) {
                [searchArr addObject:@{@"indexTitle": dic[@"indexTitle"],
                                       @"data":resultArray}];
            }
        }
        
        [addressBookTableView reloadData];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    [searchArr removeAllObjects];
    for (NSDictionary *dict in self.sortedContactArray) {
        [searchArr addObject:dict];
    }
    [addressBookTableView reloadData];
}

#pragma mark - 导入通讯录
-(void)updateContact {
    NSMutableArray *phoneNumberArray = [[NSMutableArray alloc] init];
    ABAddressBookRef addressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    int peopleCount;
    if (results) {
        peopleCount = (int)CFArrayGetCount(results);
    } else {
        peopleCount = 0;
    }
    
    for (int i=0; i<peopleCount; i++) {
        PhoneNumberModel *phoneModel=[[PhoneNumberModel alloc] init];
        ABRecordRef record = CFArrayGetValueAtIndex(results, i);
        NSString *fn,*ln,*fullname;
        fn = ln = fullname = nil;
        CFTypeRef vtmp = NULL;
        vtmp = ABRecordCopyValue(record, kABPersonFirstNameProperty);
        if (vtmp){
            fn = [NSString stringWithString:(__bridge NSString *)(vtmp)];
            CFRelease(vtmp);
            vtmp = NULL;
        }
        vtmp = ABRecordCopyValue(record, kABPersonLastNameProperty);
        if (vtmp){
            ln = [NSString stringWithString:(__bridge NSString *)(vtmp)];
            CFRelease(vtmp);
            vtmp = NULL;
        }
        
        //头像
        NSData *photoData = CFBridgingRelease(ABPersonCopyImageData(record));
        phoneModel.photoData=photoData;
        
        fullname=[NSString stringWithFormat:@"%@%@",ln?ln:@"",fn?fn:@""];
        // 读取电话
        ABMultiValueRef phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        CFStringRef phonenumber = ABMultiValueCopyValueAtIndex(phones, 0);
        phoneModel.name=fullname;
        phoneModel.phoneNumber=(__bridge NSString *)phonenumber;
        phoneModel.phoneNumber = [self getOriginPhoneNumber:phoneModel.phoneNumber];
        NSLog(@"通讯录联系人：%@",phoneModel.name);
        NSLog(@"通讯录号码：%@",phoneModel.phoneNumber);
        
        //将电话号码存到上传数据数组中
        NSString *phoneStr = @"";
        if ([phoneModel.phoneNumber isKindOfClass:[NSNull class]] || [phoneModel.phoneNumber isEqual:[NSNull null]] || phoneModel.phoneNumber == nil) {
            phoneStr = @"";
        }else {
            phoneStr = phoneModel.phoneNumber;
        }
        [phoneArr addObject:phoneStr];
        
        [phoneNumberArray addObject:phoneModel];
        if (phonenumber)
            CFRelease(phonenumber);
        if (phones)
            CFRelease(phones);
        record = NULL;
    }
    
    if (results)
        CFRelease(results);
    results = nil;
    
    if (addressBook)
        CFRelease(addressBook);
    addressBook = NULL;
    
    [self sortPhoneNameArrayByIndexTitleWithArr:phoneNumberArray];
    
    //
    if (phoneArr.count) {
        [self postPhoneMemberWithArr:phoneArr];
    }
}

-(void)sortPhoneNameArrayByIndexTitleWithArr:(NSArray *)arr {
    NSMutableArray *contactArray = [[NSMutableArray alloc] init];
    NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:27];
    for (PhoneNumberModel *phoneModel in arr) {
        NSString *upstring;
        if ((phoneModel.name.length>0)&&phoneModel.name) {
            if ([[phoneModel.name substringToIndex:1] canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSString *mystring;
                if (phoneModel.name.length>0) {
                    mystring = [NSString stringWithFormat:@"%c",[phoneModel.name characterAtIndex:0]];
                }else{
                    mystring = @"";
                }
                NSString *regex = @"[a-zA-z]";
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                if ([predicate evaluateWithObject:mystring] == YES) {
                    upstring=[[NSString stringWithFormat:@"%c",[phoneModel.name characterAtIndex:0]]uppercaseString];
                }else{
                    upstring = @"#";
                }
                
            }else{
                upstring=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([phoneModel.name characterAtIndex:0])] uppercaseString];
            }
        }else{
            phoneModel.name = @" ";
            upstring = @"#";
        }
        phoneModel.indexTitle = upstring;
        //找出所有索引 并去重
        if (![indexArray containsObject:upstring]) {
            [indexArray addObject:upstring];
        }
        [contactArray addObject:phoneModel];
    }
    
    //索引数组
    NSArray *sortedIndexArray = [[NSArray alloc] init];
    sortedIndexArray = [indexArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        id object1 = obj1;
        id object2 = obj2;
        
        return [object1 compare:object2];
    }];
    
    for (NSInteger i=0; i<sortedIndexArray.count; i++) {
        [indexArr addObject:sortedIndexArray[i]];
    }
    
    //存放排序过的model数组 用于原生搜索
    NSArray *sortedArray = [[NSArray alloc] init];
    sortedArray = [contactArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PhoneNumberModel *object1 = (PhoneNumberModel *)obj1;
        PhoneNumberModel *object2 = (PhoneNumberModel *)obj2;
        if ([[object1.name substringToIndex:1] canBeConvertedToEncoding:NSASCIIStringEncoding]&&(![[object2.name substringToIndex:1] canBeConvertedToEncoding:NSASCIIStringEncoding])) {
            return NSOrderedDescending;
        }else if ((![[object1.name substringToIndex:1] canBeConvertedToEncoding:NSASCIIStringEncoding])&&[[object2.name substringToIndex:1] canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            return NSOrderedAscending;
        }else {
            return NSOrderedSame;
        }
    }];
    self.sourceContactArray = (NSMutableArray*)sortedArray;
    
    for (NSString *indexString in sortedIndexArray) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.indexTitle = %@",indexString];
        NSMutableArray *tempGroupArray = [[NSMutableArray alloc] initWithArray:[sortedArray filteredArrayUsingPredicate:resultPredicate]];
        NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:indexString,@"indexTitle",tempGroupArray,@"data", nil];
        [self.sortedContactArray addObject:tempDic];
    }
    
    //
    for (NSDictionary *dict in self.sortedContactArray) {
        [searchArr addObject:dict];
    }
}

-(NSString*)getOriginPhoneNumber:(NSString*)phoneStr{
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
    return phoneStr;
}

#pragma mark - UITableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.sortedContactArray.count;
    return searchArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.sortedContactArray[section][@"data"] count];
    return [searchArr[section][@"data"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PhoneNumberViewCellId = @"PhoneNumberViewCellId";
    PhoneNumberViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PhoneNumberViewCellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PhoneNumberViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if (self.sortedContactArray.count) {
    if (searchArr.count) {
//        NSDictionary *dict = (NSDictionary *)self.sortedContactArray[indexPath.section];
        NSDictionary *dict = (NSDictionary *)searchArr[indexPath.section];
        PhoneNumberModel *model = (PhoneNumberModel *)[[dict objectForKey:@"data"] objectAtIndex:indexPath.row];
        cell.nameLabel.text = model.name;
        cell.rightButton.tag = 1401 + 1000*indexPath.section + indexPath.row;
        
        cell.rightButton.layer.borderWidth = 1.f;
        cell.rightButton.layer.borderColor = [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1].CGColor;
        cell.rightButton.layer.masksToBounds = YES;
        cell.rightButton.layer.cornerRadius = 2.f;
        
        [cell.rightButton setBackgroundColor:[UIColor whiteColor]];
        cell.rightButton.userInteractionEnabled = YES;
        
        [cell.rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
        
        if (getPhoneArr.count) {
            for (GetPhoneModel *getModel in getPhoneArr) {
                if ([model.phoneNumber isEqualToString:getModel.phone]) {
                    if ([getModel.commState integerValue] == 1) {//1-不是会员，显示邀请
                        [cell.rightButton setImage:[[UIImage imageNamed:@"11xin.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                        [cell.rightButton setTitle:@"邀请" forState:UIControlStateNormal];
                    }else if ([getModel.commState integerValue] == 2) {//2-是我关注的，显示已关注
                        [cell.rightButton setImage:[[UIImage imageNamed:@"46gou_.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                        [cell.rightButton setTitle:@"已关注" forState:UIControlStateNormal];
                        [cell.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.rightButton setBackgroundColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1]];
                        cell.rightButton.userInteractionEnabled = NO;
                    }else if ([getModel.commState integerValue] == 3) {//3-是会员，但是不是我关注的，显示关注
                        [cell.rightButton setImage:[[UIImage imageNamed:@"45tianjia01.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                        [cell.rightButton setTitle:@"关注" forState:UIControlStateNormal];
                    }
                }else if ([model.phoneNumber isKindOfClass:[NSNull class]] || [model.phoneNumber isEqual:[NSNull null]] || model.phoneNumber == nil) {
                    cell.rightButton.userInteractionEnabled = NO;
                    [cell.rightButton setTitle:@"无手机号" forState:UIControlStateNormal];
                }
            }
        }
        [cell.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 25                   )];
    headView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, 100, 20)];
    titleLabel.text = self.sortedContactArray[section][@"indexTitle"];
    [headView addSubview:titleLabel];
    
    return headView;
}

#pragma mark - 返回索引数组
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObjectsFromArray:indexArr];
    
    return arr;
}

#pragma mark - 获取通讯录手机号与当前用户的关系
- (void)postPhoneMemberWithArr:(NSArray *)myPhoneArr {
    [[AppHttpManager shareInstance] getJudgeCommunicationRelationWithuserId:[User_ID intValue] Token:User_TOKEN Phones:myPhoneArr PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                GetPhoneModel *model = [[GetPhoneModel alloc] initWithDictionary:subDict error:nil];
                [getPhoneArr addObject:model];
            }
            [addressBookTableView reloadData];
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 右按键响应事件
- (void)rightButtonClick:(UIButton *)button {
    NSInteger buttonSection = (button.tag-1401)/1000;
    NSInteger buttonIndex = (button.tag-1401)%1000;
    
    if (self.sortedContactArray.count) {
        NSDictionary *dict = (NSDictionary *)self.sortedContactArray[buttonSection];
        PhoneNumberModel *model = (PhoneNumberModel *)[[dict objectForKey:@"data"] objectAtIndex:buttonIndex];
        if (getPhoneArr.count) {
            for (GetPhoneModel *getModel in getPhoneArr) {
                if ([model.phoneNumber isEqualToString:getModel.phone]) {
                    if ([getModel.commState integerValue] == 1) {//1-不是会员，显示邀请
                        [self inviteUserWithPhone:getModel.phone];
                    }else if ([getModel.commState integerValue] == 2) {//2-是我关注的，显示已关注
                        
                    }else {//3-是会员，但是不是我关注的，显示关注
                        [self guanzhuUserWithOtherUserId:getModel.userId withIndex:buttonIndex withSection:buttonSection];
                    }
                }
            }
        }
    }
}

#pragma mark - 邀请
- (void)inviteUserWithPhone:(NSString *)phone {
    [[AppHttpManager shareInstance] getSendSmsFromInviteWithuserId:[User_ID intValue] Token:User_TOKEN SendPhone:phone PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] intValue]==200 || [dict[@"IsSuccess"] intValue]==1) {
            [SVProgressHUD showImage:nil status:@"已发送邀请"];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

#pragma mark - 关注
- (void)guanzhuUserWithOtherUserId:(NSString *)otherUserId withIndex:(NSInteger)index withSection:(NSInteger)section {
    [[AppHttpManager shareInstance] getAddOrCancelFriendWithType:1 UserId:[User_ID intValue] Token:User_TOKEN OUserId:[otherUserId intValue] PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] intValue]==200 || [dict[@"IsSuccess"] intValue]==1) {
            for (NSInteger i=0; i<getPhoneArr.count; i++) {
                GetPhoneModel *model = (GetPhoneModel *)getPhoneArr[i];
                if ([model.userId integerValue] == [otherUserId integerValue]) {
                    model.commState = @"2";
                }
                [getPhoneArr replaceObjectAtIndex:i withObject:model];
            }
            
            [addressBookTableView reloadData];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
