//
//  ECAlbumListTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECAlbumListTableViewController.h"

@interface ECAlbumListTableViewController ()<PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) NSMutableArray *allAlbums;

@property (nonatomic, strong) PHFetchOptions *photosOptions;

@end

static NSString * const ECAlbumListCellReuseIdentifier = @"ECAlbumListTableViewCell";

@implementation ECAlbumListTableViewController

- (NSMutableArray *)allAlbums {
    if (!_allAlbums) {
        _allAlbums = [NSMutableArray array];
    }
    return _allAlbums;
}

- (void)setupData {
    
    // PHFetchOptions是为获取数据时候的配置对象,用来设置获取时候的需要的条件
    self.photosOptions = [[PHFetchOptions alloc] init];
    
    // 图片配置中设置其排序规则-----升序
    self.photosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
//    // 根据配置对象来获取所有的图片资源
//    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:photosOptions];
//    
//    // 获取类型为智能相册的图片资源
//    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    // 获取相机胶卷相册资源
    PHFetchResult *userLibraryAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    for (PHAssetCollection *collection in userLibraryAlbum) {
        [self.allAlbums addObject:collection];
    }
    
    // 获取最近添加的相册资源
    PHFetchResult *recentlyAddedAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
    for (PHAssetCollection *collection in recentlyAddedAlbum) {
        [self.allAlbums addObject:collection];
    }
    
    // 获取屏幕快照的相册资源
    PHFetchResult *screenshotsAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
    for (PHAssetCollection *collection in screenshotsAlbum) {
        [self.allAlbums addObject:collection];
    }
    
    // 获取用户自定义的相册资源
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    for (PHAssetCollection *collection in userAlbums) {
        [self.allAlbums addObject:collection];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = left;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];

    [self setupData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allAlbums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ECAlbumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ECAlbumListCellReuseIdentifier];
    
    if (cell == nil) {
        cell = [[ECAlbumListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ECAlbumListCellReuseIdentifier];
    }
    
    PHAssetCollection *collection = self.allAlbums[indexPath.row];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:self.photosOptions];
    if (fetchResult.count) {
        [[PHCachingImageManager defaultManager] requestImageForAsset:fetchResult[0] targetSize:CGSizeMake(50, 50) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                cell.headerImage = result;
            }
            NSLog(@"haha");
        }];
    }
    [cell updateDataWithTitle:collection.localizedTitle Count:fetchResult.count];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
