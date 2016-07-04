//
//  MoreVC.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MoreVC.h"
#import "Masonry.h"
#import "OtherPageView.h"

@interface MoreVC ()

@end

@implementation MoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    
    OtherPageView * hvc = [[OtherPageView alloc] init];
    hvc.data = nil;
    [self.view addSubview:hvc];
    hvc.type = self.name;
    hvc.postType = @"1";
    [hvc reloadData];
    [hvc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    
    // Do any additional setup after loading the view.
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
