//
//  ECAlbumListTableViewCell.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PHSubtype) {
    PHSubtypeAlbumRegular, //用户在 Photos 中创建的相册，也就是我所谓的逻辑相册
    PHSubtypeAlbumSyncedEvent, //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。然而，在iTunes 12 以及iOS 9.0 beta4上，选用该类型没法获取同步的事件相册，而必须使用AlbumSyncedAlbum。
    PHSubtypeAlbumSyncedFaces, //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
    PHSubtypeAlbumSyncedAlbum, //做了 AlbumSyncedEvent 应该做的事
    PHSubtypeAlbumImported, //从相机或是外部存储导入的相册，完全没有这方面的使用经验，没法验证。
    PHSubtypeAlbumMyPhotoStream, //用户的 iCloud 照片流
    PHSubtypeAlbumCloudShared, //用户使用 iCloud 共享的相册
    PHSubtypeSmartAlbumGeneric, //文档解释为非特殊类型的相册，主要包括从 iPhoto 同步过来的相册。由于本人的 iPhoto 已被 Photos 替代，无法验证。不过，在我的 iPad mini 上是无法获取的，而下面类型的相册，尽管没有包含照片或视频，但能够获取到。
    PHSubtypeSmartAlbumPanoramas, //相机拍摄的全景照片
    PHSubtypeSmartAlbumVideos, //相机拍摄的视频
    PHSubtypeSmartAlbumFavorites, //收藏文件夹
    PHSubtypeSmartAlbumTimelapses, //延时视频文件夹，同时也会出现在视频文件夹中
    PHSubtypeSmartAlbumAllHidden, //包含隐藏照片或视频的文件夹
    PHSubtypeSmartAlbumRecentlyAdded, //相机近期拍摄的照片或视频
    PHSubtypeSmartAlbumBursts, //连拍模式拍摄的照片，在 iPad mini 上按住快门不放就可以了，但是照片依然没有存放在这个文件夹下，而是在相机相册里。
    PHSubtypeSmartAlbumSlomoVideos, //Slomo 是 slow motion 的缩写，高速摄影慢动作解析，在该模式下，iOS 设备以120帧拍摄。
    PHSubtypeSmartAlbumUserLibrary, //这个命名最神奇了，就是相机相册，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
    PHSubtypeAny //包含所有类型
};

@interface ECAlbumListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImage *headerImage;

- (void)updateDataWithTitle:(NSString *)title Count:(NSInteger)count;

@end
