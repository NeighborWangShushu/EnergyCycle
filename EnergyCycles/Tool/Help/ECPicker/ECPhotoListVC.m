//
//  ECPhotoListViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECPhotoListVC.h"
#import "ECPhotoListCell.h"

#import "ECAlbumListVC.h"

#define columnCount 3

#define dropImage @"ecpicker_drop"

@interface ECPhotoListVC ()<PHPhotoLibraryChangeObserver, UICollectionViewDataSource, UICollectionViewDelegate> {
    BOOL drop;
    UIButton *titleButton;
    CGFloat tableViewHeight;
}
@property (nonatomic, strong) PHFetchResult *albumData;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ECAlbumListVC *albumListVC;
@property (nonatomic, strong) UIButton *maskButton;

@end

static NSString * const photoReuseIdentifier = @"ECPhotoListCell";
static CGSize itemSize;

@implementation ECPhotoListVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFetchResult:) name:@"UpdateECAlbumPhoto" object:nil];
    
    [self setup];
    
    // Do any additional setup after loading the view.
}

- (void)updateFetchResult:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    // PHFetchOptions是为获取数据时候的配置对象,用来设置获取时候的需要的条件
    PHFetchOptions *photosOptions = [[PHFetchOptions alloc] init];
    
    // 图片配置中设置其排序规则-----降序
    photosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHAssetCollection *collection = dic[@"assetCollection"];
    self.albumData = [PHAsset fetchAssetsInAssetCollection:collection options:photosOptions];
    NSInteger albumsCount = [dic[@"allAlbumsCount"] integerValue];
    
    tableViewHeight = albumsCount * 60 < Screen_Height - 300 ? albumsCount * 60 : Screen_Height - 300;
    
    if (drop) {
        [self popupList];
    }
    
    [self titleViewWith:collection.localizedTitle];

    [self.collectionView reloadData];
}

- (void)titleViewWith:(NSString *)title {
    // 添加navgation的titleView
    titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton addTarget:self action:@selector(popupList) forControlEvents:UIControlEventTouchUpInside];
    titleButton.frame = CGRectMake(0, 0, 200, 40);
    [titleButton setImage:[UIImage imageNamed:dropImage] forState:UIControlStateNormal];
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 在UIButton中默认图片在左文字在右,利用edgeInsets来改变图片和文字的位置
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -titleButton.imageView.bounds.size.width, 0, titleButton.imageView.bounds.size.width)];
    [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleButton.titleLabel.bounds.size.width, 0, -titleButton.titleLabel.bounds.size.width)];
    self.navigationItem.titleView = titleButton;
}


- (void)setup {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat itemWidth = (Screen_width - (columnCount - 1) * 5) / columnCount;
    itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.itemSize = itemSize;
    
    // 初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册collectionViewCell
    [self.collectionView registerClass:[ECPhotoListCell class] forCellWithReuseIdentifier:photoReuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    self.maskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.maskButton.frame = self.collectionView.bounds;
    [self.maskButton setBackgroundColor:[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.3]];
    [self.maskButton addTarget:self action:@selector(popupList) forControlEvents:UIControlEventTouchUpInside];
    self.maskButton.alpha = 0;
    [self.view addSubview:self.maskButton];
    
    [self createListTableView];
    [self navigationView];
}

- (void)navigationView {
    
    // 取消导航栏半透明
    self.navigationController.navigationBar.translucent = NO;
    
    // 导航栏左按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 弹出相册列表
- (void)popupList {
    if (drop) {
        drop = NO;
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:1
                            options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.maskButton.alpha = 0;
        [self.albumListVC.view setFrame:CGRectMake(0, -tableViewHeight, Screen_width, tableViewHeight)];
        titleButton.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);

                            } completion:nil];
    } else {
        drop = YES;
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:1
                            options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.maskButton.alpha = 1;
        [self.albumListVC.view setFrame:CGRectMake(0, 0, Screen_width, tableViewHeight)];
        titleButton.imageView.transform = CGAffineTransformMakeScale(1.0, -1.0);

                            } completion:nil];
    }

}

- (void)createListTableView {
    
    CGRect frame = CGRectMake(0, -tableViewHeight, Screen_width, tableViewHeight);
    self.albumListVC = [[ECAlbumListVC alloc] init];
    self.albumListVC.view.frame = frame;
    drop = NO;
    [self.view addSubview:self.albumListVC.view];
    
}

#pragma mark -----UICollectionViewDataSource-----

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoReuseIdentifier forIndexPath:indexPath];
    
    PHAsset *asset = self.albumData[indexPath.row];
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:itemSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.thumbnailImage = result;
    }];
    
    return cell;
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
