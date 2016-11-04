//
//  ECPickerController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECPickerController.h"

@interface ECPickerController ()

@property (nonatomic, strong) ECPhotoListVC *photoVC;

@end

@implementation ECPickerController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)imageIDArr {
    if (!_imageIDArr) {
        self.imageIDArr = [NSMutableArray array];
    }
    return _imageIDArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoVC = [[ECPhotoListVC alloc] init];
    self.photoVC.imageIDArr = self.imageIDArr;
    self.photoVC.delegate = self.delegate;
    self.viewControllers = @[self.photoVC];
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
//    
//    self.navigationItem.leftBarButtonItem = left;
//    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    rightButton.frame = CGRectMake(0, 0, 40, 40);
//    [rightButton setImage:[[UIImage imageNamed:@"fenxiang_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [rightButton setImage:[[UIImage imageNamed:@"fenxiang_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
//    [rightButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.hidden = YES;
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = item;
//    self.navigationController

    // Do any additional setup after loading the view.
}

- (void)cancel {
    [self popViewControllerAnimated:YES];
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
