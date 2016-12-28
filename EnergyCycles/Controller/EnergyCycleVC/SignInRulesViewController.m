//
//  SignInRulesViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SignInRulesViewController.h"

#import "SignInRuslutViewCell.h"

@interface SignInRulesViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation SignInRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分规则";
    
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    showTableView.backgroundColor = [UIColor clearColor];
    showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    showTableView.delegate = self;
    showTableView.dataSource = self;
    
    [self.view insertSubview:self.backImageView atIndex:0];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Screen_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SignInRuslutViewCellID = @"SignInRuslutViewCellID";
    SignInRuslutViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SignInRuslutViewCellID];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
