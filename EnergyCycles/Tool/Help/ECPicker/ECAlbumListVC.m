//
//  ECAlbumListTableViewController.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECAlbumListVC.h"
#import "ECAlbumListTableViewCell.h"

@interface ECAlbumListVC ()<PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) NSMutableArray *allAlbums;

@property (nonatomic, strong) PHFetchOptions *photosOptions;

@end

static NSString * const ECAlbumListCellReuseIdentifier = @"ECAlbumListTableViewCell";

@implementation ECAlbumListVC

- (NSMutableArray *)allAlbums {
    if (!_allAlbums) {
        _allAlbums = [NSMutableArray array];
    }
    return _allAlbums;
}

- (void)setupData {
    
    // PHFetchOptions是为获取数据时候的配置对象,用来设置获取时候的需要的条件
    self.photosOptions = [[PHFetchOptions alloc] init];
    
    // 图片配置中设置其排序规则-----降序
    self.photosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 注册观察相册变换的观察者
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc {
    // 销毁观察者
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self isPhotoAlbumPermissions];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)isPhotoAlbumPermissions {
    if ([self isPhotoAlbumNotDetermined]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
                {
                    // 用户拒绝
                }
                else if (status == PHAuthorizationStatusAuthorized)
                {
                    // 用户授权，弹出相册对话框
                    [self setupData];
                    
                    [self getData];
                }
            });
        }];
        
    } else {
        [self setupData];
        
        [self getData];
    }
}

- (BOOL)isPhotoAlbumNotDetermined {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusNotDetermined)
    {
        return YES;
    }
    return NO;
}

- (void)getData {
    
    if (self.allAlbums.count > 0) {
        
        PHAssetCollection *collection = self.allAlbums[0];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateECAlbumPhoto" object:@{@"assetCollection" : collection, @"allAlbumsCount" : @(self.allAlbums.count)}];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAssetCollection *collection = self.allAlbums[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateECAlbumPhoto" object:@{@"assetCollection" : collection, @"allAlbumsCount" : @(self.allAlbums.count)}];
    
}

#pragma mark -----PHPhotoLibraryChangeObserver-----

// 如果出现相册中的资源变化时,执行这个方法
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{ 
        NSMutableArray *updateAllAlbums = [self.allAlbums mutableCopy];
        __block BOOL reload = NO;
        
        [self.allAlbums enumerateObjectsUsingBlock:^(PHObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHObjectChangeDetails *changeDetails = [changeInstance changeDetailsForObject:obj];
            
            if (changeDetails) {
                PHAssetCollection *collection = [changeDetails objectAfterChanges];
                [updateAllAlbums replaceObjectAtIndex:idx withObject:collection];
                reload = YES;
            }
            
        }];
        
        if (reload) {
            self.allAlbums = updateAllAlbums;
            [self.tableView reloadData];
        }
    });
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
