//
//  ProjectVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ProjectVC.h"
#import "ProjectCollectionViewCell.h"
#import "PromiseCollectionFlowLayout.h"
#import "PKSelectedModel.h"
#import "SetProjectVC.h"

@interface ProjectVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ProjectVC

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"项目";
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    [self setup];
    [self getData];
    
    // Do any additional setup after loading the view.
}

- (void)getData {
    [[AppHttpManager shareInstance] getGetProjectWithPostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            for (NSDictionary *subDict in dict[@"Data"]) {
                PKSelectedModel *model = [[PKSelectedModel alloc] initWithDictionary:subDict error:nil];
                [_dataArr addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            
        }
    } failure:^(NSString *str) {
        NSLog(@"%@",str);
    }];
}

- (void)setup {
//    PromiseCollectionFlowLayout *layout = [[PromiseCollectionFlowLayout alloc] init];
//    layout.lineSpacing = 10;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat itemWidth = (Screen_width - 40) / 3;
    layout.itemSize = CGSizeMake(itemWidth, (itemWidth * 6) / 5);
    
    CGRect rect = self.view.bounds;
    rect.size.height -= 64;
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PKSelectedModel *model = self.dataArr[indexPath.row];
    
    [cell getDataWithModel:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProjectCollectionViewCell *cell = (ProjectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        [UIView animateWithDuration:0.2
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:2
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
//                             cell.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                             cell.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
//                             cell.layer.shadowOpacity = 0.8;
//                             cell.layer.shadowRadius = 5;
//                             cell.layer.shadowOffset = CGSizeMake(0, 0);
//                             [collectionView bringSubviewToFront:cell];
                             cell.projectImageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                             cell.projectImageView.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
                             cell.projectImageView.layer.shadowOpacity = 0.8;
                             cell.projectImageView.layer.shadowRadius = 5;
                             cell.projectImageView.layer.shadowOffset = CGSizeMake(0, 0);
                             [collectionView bringSubviewToFront:cell];
        } completion:^(BOOL finished) {
            cell.projectImageView.transform = CGAffineTransformMakeScale(1, 1);
            cell.projectImageView.layer.shadowColor = [UIColor clearColor].CGColor;
            PKSelectedModel *model = self.dataArr[indexPath.row];
            
            SetProjectVC *setVC = [[SetProjectVC alloc] init];
            
            setVC.model = model;
            [self.navigationController pushViewController:setVC animated:YES];
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
