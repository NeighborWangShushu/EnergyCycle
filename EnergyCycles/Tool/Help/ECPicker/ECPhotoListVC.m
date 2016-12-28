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
#import "ECPhotoScrollVC.h"

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

// 临时存储图片的PHAsset对象
@property (nonatomic, strong) NSMutableArray *assetArr;

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) UIButton *rightItem;

@end

static NSString * const photoReuseIdentifier = @"ECPhotoListCell";
static CGSize itemSize;

@implementation ECPhotoListVC

- (NSMutableArray *)imageIDArr {
    if (!_imageIDArr) {
        self.imageIDArr = [NSMutableArray array];
    }
    return _imageIDArr;
}

- (NSMutableArray *)assetArr {
    if (!_assetArr) {
        self.assetArr = [NSMutableArray array];
    }
    return _assetArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFetchResult:) name:@"UpdateECAlbumPhoto" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAssetArr:) name:@"UpdateAssetArr" object:nil];
    
    [self setup];
    
    [self localIdentifier];
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

/*
    localIdentifier是每个资源元数据都拥有的唯一标识符,所以我们可以利用localIdentifier来将图片保存在本地,因为相同的一张相片在不同的设备中的localIdentifier是不同的,localIdentifier是以字符串的形式存在的,需要注意的是在iOS中对相片进行编辑后的资源元数据会发生改变,localIdentifier也会有所变化,但是不用担心这个改变并不是localIdentifier变了,而是编辑后的图片会在原有基础上再添加一个localIdentifier用来区分编辑前的数据和编辑后的数据,当然这个PHAsset就会拥有多个localIdentifier标签了
 
    注:因为在PhotoKit框架中,照片影片之类的东西都是以资源元数据的形式存在的,既同一张相片以不同的大小或像素显示,但是底部的数据来源都是指向同一个资源元数据
 */
// 通过传进来的localIdentifier数组来获取图片PHAsset对象
- (void)localIdentifier {
    // PHFetchOptions是为获取数据时候的配置对象,用来设置获取时候的需要的条件
    PHFetchOptions *photosOptions = [[PHFetchOptions alloc] init];
    
    // 图片配置中设置其排序规则-----降序
    photosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    if (self.imageIDArr) {
        PHFetchResult *imageData = [PHAsset fetchAssetsWithLocalIdentifiers:self.imageIDArr options:photosOptions];
        for (PHAsset *asset in imageData) {
            [self.assetArr addObject:asset];
        }
        [self.rightItem setFrame:CGRectMake(0, 0, 80, 25)];
        [self.rightItem setTitle:[NSString stringWithFormat:@"下一步(%ld)", self.imageIDArr.count] forState:UIControlStateNormal];
        [self.rightItem setBackgroundImage:[UIImage imageNamed:@"ecpicker_next_enable"] forState:UIControlStateNormal];
        UIBarButtonItem *rightButtontItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItem];
        self.navigationItem.rightBarButtonItem = rightButtontItem;
    }
}

// 每次选中操作时更新保存PHAsset对象数组
- (void)updateAssetArr:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    PHAsset *asset = dic[@"asset"];
    // 获取选中的状态
    BOOL selected = [dic[@"selected"] boolValue];
    // 判断原有的数组中是否有这个PHAsset对象
    BOOL asseted = [self.assetArr containsObject:asset];
    
    if (asseted && !selected) {
        [self.assetArr removeObject:asset];
        if ([self.imageIDArr containsObject:asset.localIdentifier]) {
            [self.imageIDArr removeObject:asset.localIdentifier];
        }
        if (self.assetArr.count < 9) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JudgeDisable" object:@{@"disable" : @(NO)}];
        }
    }
    if (!asseted && selected) {
        [self.assetArr addObject:asset];
        if (![self.imageIDArr containsObject:asset.localIdentifier]) {
            [self.imageIDArr addObject:asset.localIdentifier];
        }
        if (self.assetArr.count >= 9) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JudgeDisable" object:@{@"disable" : @(YES)}];
        }
    }
    
    if (self.imageIDArr.count >= 1) {
        [self.rightItem setFrame:CGRectMake(0, 0, 80, 25)];
        [self.rightItem setTitle:[NSString stringWithFormat:@"下一步(%ld)", self.imageIDArr.count] forState:UIControlStateNormal];
        [self.rightItem setBackgroundImage:[UIImage imageNamed:@"ecpicker_next_enable"] forState:UIControlStateNormal];
        UIBarButtonItem *rightButtontItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItem];
        self.navigationItem.rightBarButtonItem = rightButtontItem;
    } else {
        [self.rightItem setFrame:CGRectMake(0, 0, 60, 25)];
        [self.rightItem setTitle:@"" forState:UIControlStateNormal];
        [self.rightItem setBackgroundImage:[UIImage imageNamed:@"ecpicker_next_disable"] forState:UIControlStateNormal];
        UIBarButtonItem *rightButtontItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItem];
        self.navigationItem.rightBarButtonItem = rightButtontItem;
    }
    
}

// 相册
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

// 布局
- (void)setup {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat itemWidth = (Screen_width - (columnCount - 1) * 5) / columnCount;
    itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.itemSize = itemSize;
    
    // 初始化collectionView
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
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

#pragma mark - 导航栏设置

- (void)navigationView {
    
    // 取消导航栏半透明
    self.navigationController.navigationBar.translucent = NO;
    
    // 导航栏左按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [left setTintColor:[UIColor redColor]];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    self.rightItem = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightItem.frame = CGRectMake(0, 0, 60, 25);
    [self.rightItem setTitle:@"" forState:UIControlStateNormal];
    [self.rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.rightItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rightItem setBackgroundImage:[UIImage imageNamed:@"ecpicker_next_disable"] forState:UIControlStateNormal];
    [self.rightItem addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButtontItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItem];
    self.navigationItem.rightBarButtonItem = rightButtontItem;
    
}

// 下一步按钮的方法
- (void)next {
    NSMutableArray *imageData = [NSMutableArray array];
    NSMutableArray *imageID = [NSMutableArray array];
    /*
        iphone的照片进行了编辑后,图片源文件的数据会发生改变,所以为了拿到正确的图片我们需要对文件的属性进行设置,
        PHImageRequestOptions中有一个属性是version,我们可以通过这个属性来有选择的拿到相册中的图片(原图,编辑后的图片)
     */
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.version = PHImageRequestOptionsVersionCurrent;
    
    for (PHAsset *asset in self.assetArr) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 result 中
                BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (downloadFinined) {
                    [imageData addObject:result];
                    [imageID addObject:asset.localIdentifier];
                    if (imageData.count == self.assetArr.count && imageID.count == self.assetArr.count) {
                        if ([self.delegate respondsToSelector:@selector(exportImageData:ID:)]) {
                            [self.delegate exportImageData:imageData ID:imageID];
                            [self cancel];
                        }
                    }
                }
            }
        }];
    }
}

// 取消按钮方法
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

// 创建相册列表
- (void)createListTableView {
    
    CGRect frame = CGRectMake(0, -tableViewHeight, Screen_width, tableViewHeight);
    self.albumListVC = [[ECAlbumListVC alloc] init];
    self.albumListVC.view.frame = frame;
    drop = NO;
    [self.view addSubview:self.albumListVC.view];
    
}

#pragma mark -----UICollectionViewDataSource-----

// 一个相册中一共有多少图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoReuseIdentifier forIndexPath:indexPath];
    
    PHAsset *asset = self.albumData[indexPath.row];
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:itemSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            cell.thumbnailImage = result;
            cell.asset = asset;
            if ([self.imageIDArr containsObject:asset.localIdentifier]) {
                cell.isSelected = YES;
                cell.indexPath = indexPath;
                [cell selected];
            }
        }
    }];
    cell.indexPath = indexPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECPhotoScrollVC *psVC = [[ECPhotoScrollVC alloc] init];
    psVC.albumData = self.albumData;
    psVC.indexPath = indexPath;
    [self.navigationController pushViewController:psVC animated:YES];
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
