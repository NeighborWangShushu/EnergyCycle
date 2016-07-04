//
//  LearnPageViewController.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LearnPageViewController.h"
#import "ReferralPageView.h"
#import "HotPageView.h"
#import "OtherPageView.h"
#import "Masonry.h"
#import "AppHttpManager.h"

@interface LearnPageViewController () {
    
}

@property (nonatomic,strong)NSDictionary * data;

@property (nonatomic,strong)NSString * postType;
@end

@implementation LearnPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PageViewChanged" object:nil userInfo:@{@"name":self.model.name}];

    
}

- (void)initialize {
    
}

- (void)loadData {
    
    NSString * content = @"1";
    if ([self.postType isEqualToString:@"1"]) {
        content = self.type;
    }
    
    [[AppHttpManager shareInstance] getSearchWithTypes:self.postType withContent:content PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            _data = dict;
            
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}



- (void)setType:(NSString *)type {
    _type = type;
    if ([_type isEqualToString:@"推荐"]) {
        self.postType = @"3";
    }else if ([_type isEqualToString:@"热门"]){
        self.postType = @"4";
    }else {
        self.postType = @"1";
    }
    [self setup];
}

- (void)setup {
    if ([_type isEqualToString:@"推荐"]) {
        ReferralPageView * revc = [[ReferralPageView alloc] init];
        revc.data = self.data;
        revc.type = _type;
        revc.postType = self.postType;
        [self.view addSubview:revc];
        [revc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        [revc reloadData];
    }else if ([_type isEqualToString:@"热门"]){
        HotPageView * hvc = [[HotPageView alloc] init];
        hvc.data = self.data;
        hvc.type = _type;
        hvc.postType = self.postType;
        [self.view addSubview:hvc];
        
        [hvc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        [hvc reloadData];
    }else {
        OtherPageView * hvc = [[OtherPageView alloc] init];
        hvc.data = self.data;
        [self.view addSubview:hvc];
        hvc.type = _type;
        hvc.postType = self.postType;
        [hvc reloadData];
        [hvc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
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
