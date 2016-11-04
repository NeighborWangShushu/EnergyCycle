//
//  BadgeRulesCollectionViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BadgeRulesCollectionViewController.h"
#import "BadgeRulesCollectionViewCell.h"
#import "BadgeModel.h"

@interface BadgeRulesCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger getCount;
@property (nonatomic, strong) UIButton *detailBackgroundView;
@property (nonatomic, strong) UIView *detailView;

@end

@implementation BadgeRulesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const headerViewIdentifier = @"headerView";
static NSString * const footerViewIdentifier = @"footerView";

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"徽章规则";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    [self getData];
    
    // Do any additional setup after loading the view.
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData {
    [[AppHttpManager shareInstance] getMyBedgeWithUserID:[User_ID intValue] PostOrGet:@"get" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            self.getCount = 0;
            for (NSDictionary *data in dict[@"Data"]) {
                BadgeModel *model = [[BadgeModel alloc] initWithDictionary:data error:nil];
                if ([model.flag isEqualToString:@"1"]) {
                    self.getCount ++;
                }
                [self.dataArr addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setup];
            });
        }
    } failure:^(NSString *str) {
        NSLog(@"%@", str);
    }];
}

- (void)setup {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(Screen_width, 50);
    layout.footerReferenceSize = CGSizeMake(Screen_width, 50);
    layout.itemSize = CGSizeMake(Screen_width / 3, (Screen_Height - 64 - 50) / 4);
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    // 初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 注册collectionViewCell
    [self.collectionView registerNib:[UINib nibWithNibName:@"BadgeRulesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
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

#pragma mark <UICollectionViewDataSource>

//// 返回的section个数
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}

// 返回每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BadgeRulesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    BadgeModel *model = self.dataArr[indexPath.row];
    [cell updateImageViewWithDays:model.day flag:model.flag];
    
    // Configure the cell
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // 创建collection的headerView以及footerView
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        // 创建collection的headerView
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        
        NSString *string = [NSString stringWithFormat:@"我的徽章：已获得 %ld 枚", self.getCount];
        // 根据文本创建属性字符创
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
        // 利用属性字符串将文本颜色替换
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(5, text.length - 5)];
        CGRect frame = reusableView.bounds;
        frame.origin.x = 12;
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.font = [UIFont systemFontOfSize:12];
        label.attributedText = text;
        [reusableView addSubview:label];
    } else if (kind == UICollectionElementKindSectionFooter) {
        // 创建collection的footerView
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier forIndexPath:indexPath];
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:reusableView.bounds];
        footerLabel.text = @"*根据您发布每日PK汇报的累积天数，获得相应的徽章";
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont systemFontOfSize:12];
        footerLabel.textColor = [UIColor grayColor];
        [reusableView addSubview:footerLabel];
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BadgeModel *model = self.dataArr[indexPath.row];
    [self createDetailViewWithModel:model];
}

- (void)createDetailViewWithModel:(BadgeModel *)model {
    self.detailBackgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailBackgroundView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.detailBackgroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.75];
    self.detailBackgroundView.alpha = 0;
    [self.detailBackgroundView addTarget:self action:@selector(removeDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    self.detailView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height, 260, 320)];
//    CGPoint center = CGPointMake(self.detailBackgroundView.frame.size.width/2, -Screen_Height);
    CGPoint center = self.detailBackgroundView.center;
    center.y = -Screen_Height;
    self.detailView.center = center;
    self.detailView.backgroundColor = [UIColor whiteColor];
    self.detailView.layer.cornerRadius = 10;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@signIn", model.day]]];
    imageView.center = CGPointMake(self.detailView.frame.size.width/2, 120);;
    [self.detailView addSubview:imageView];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, self.detailView.frame.size.width, 10)];
    [lineImageView setImage:[UIImage imageNamed:@"BadgeDetailLine"]];
    [self.detailView addSubview:lineImageView];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    detailLabel.center = CGPointMake(self.detailView.frame.size.width/2, 240);
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.text = [NSString stringWithFormat:@"连续训练%@天", model.day];
    detailLabel.font = [UIFont systemFontOfSize:18];
    detailLabel.textColor = [UIColor colorWithRed:200/255.0 green:106/255.0 blue:106/255.0 alpha:1];
    [self.detailView addSubview:detailLabel];
    UILabel *getCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 12)];
    getCountLabel.center = CGPointMake(self.detailView.frame.size.width/2, 270);;
    getCountLabel.textAlignment = NSTextAlignmentCenter;
    getCountLabel.text = [NSString stringWithFormat:@"已有%@人获得",model.HasNum];
    getCountLabel.font = [UIFont systemFontOfSize:12];
    getCountLabel.textColor = [UIColor colorWithRed:200/255.0 green:106/255.0 blue:106/255.0 alpha:1];
    [self.detailView addSubview:getCountLabel];
    
    center.y = self.detailBackgroundView.frame.size.height / 2;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:2
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
                            self.detailView.center = center;
                            self.detailBackgroundView.alpha = 1;
    } completion:nil];
    
    [self.detailBackgroundView addSubview:self.detailView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.detailBackgroundView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.detailView];
}

- (void)removeDetailView {
    CGPoint center = self.detailView.center;
    center.y += Screen_Height;
//    center.y = Screen_Height;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:2
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
                            self.detailView.center = center;
//                            [self.detailBackgroundView removeFromSuperview];
                            self.detailBackgroundView.alpha = 0;
                        } completion:^(BOOL finished) {
                            [self.detailBackgroundView removeFromSuperview];
//                            [self.detailView removeFromSuperview];
                        }];
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
