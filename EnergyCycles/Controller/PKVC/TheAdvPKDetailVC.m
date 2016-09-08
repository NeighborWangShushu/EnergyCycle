//
//  TheAdvPKDetailVC.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TheAdvPKDetailVC.h"
#import "XMShareView.h"

@interface TheAdvPKDetailVC () {
    XMShareView *shareView;
    BOOL isHasLike;
}
@property (nonatomic, strong) UIButton *likeButton;

@end

@implementation TheAdvPKDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isHasLike = [self.model.isHasLike isEqualToString:@"1"];

    [self createRightButton];
    // Do any additional setup after loading the view.
}

- (void)createRightButton {
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton.frame = CGRectMake(0, 0, 28, 28);
    if (isHasLike) {
        [self.likeButton setImage:[UIImage imageNamed:@"32xin02_.png"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"50zan_.png"] forState:UIControlStateNormal];
    }
    [self.likeButton addTarget:self action:@selector(clickLikeButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *likeBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.likeButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0, 0, 28, 28);
    [shareButton setImage:[UIImage imageNamed:@"fenxiang_.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    self.navigationItem.rightBarButtonItems = @[shareBarButton, likeBarButton];
    
}

- (void)clickLikeButton {
    [[AppHttpManager shareInstance] getPKAddLikeOrNoLikeWithType:1 ArticleId:[self.model.postId intValue] UserId:User_ID Token:User_TOKEN PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            if (isHasLike) {
                isHasLike = NO;
                [self.likeButton setImage:[UIImage imageNamed:@"50zan_.png"] forState:UIControlStateNormal];
                [SVProgressHUD showImage:nil status:@"取消点赞成功"];
            } else {
                isHasLike = YES;
                [self.likeButton setImage:[UIImage imageNamed:@"32xin02_.png"] forState:UIControlStateNormal];
                [SVProgressHUD showImage:nil status:@"点赞成功"];
            }
        }else if ([dict[@"Code"] integerValue] == 10000) {
            [SVProgressHUD showImage:nil status:@"登录失效"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

- (void)clickShareButton {
    
    shareView = [[XMShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
    shareView.alpha = 0.0;
    shareView.shareTitle = [self md5StringForString:self.model.title];
    shareView.shareText = [self md5StringForString:self.model.content];
    shareView.shareUrl = [NSString stringWithFormat:@"%@&is_Share=1",self.url];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    [UIView animateWithDuration:0.25 animations:^{
        shareView.alpha = 1.0;
    }];
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
