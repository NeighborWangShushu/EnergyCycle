//
//  CacheManager.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager

- (long long)fileSizeAtPath:(NSString *)path {
    // 创建NSFileManager对象来对文件进行管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 判断获取到的路径是否正确,如果不正确就直接返回大小为0
    if ([fileManager fileExistsAtPath:path]) {
        // NSFileManager对象根据路径获取文件的属性,从而得到文件的大小
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

- (CGFloat)folderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:path];
    long long folderSize = 0;
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            NSString *fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
            long long size = [self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
        }
        
        // SDWebImage
        folderSize += [[SDImageCache sharedImageCache] getSize];
        return folderSize/1024.0/1024.0;
    }
    return 0;
}

- (void)clearCache:(NSString *)path {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            NSString *fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}


/**
 
 *获取缓存大小
 
 */

+ (CGFloat)getCachesSizeCount {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *contents = [fileManager subpathsAtPath:caches];
    CGFloat totolCount = 0;
    for (NSString * fileName in contents) {
//        NSLog(@"%@",fileName);
        //拼接当前文件夹的名字
        NSString * path = [caches stringByAppendingPathComponent:fileName];
        //判断当前文件中是否存在该文件
        if ([fileManager fileExistsAtPath:path ]) {
            //计算当前的文件夹的大小
            CGFloat size = [[fileManager attributesOfItemAtPath:path error:nil][NSFileSize] floatValue];
            //累加
            totolCount += size;
        }
    }
    // SDWebImage的缓存
    totolCount += [[SDImageCache sharedImageCache] getSize];
    return totolCount/1024.0/1024.0;
}

/**
 
 *清除本地缓存
 
 */
+ (void)cleadDisk {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSArray *contents = [fileManager subpathsAtPath:caches];
    for (NSString * fileName in contents) {
//        NSLog(@"%@",fileName);
        //拼接当前文件夹的名字
        NSString *path = [caches stringByAppendingPathComponent:fileName];
        //判断当前文件中是否存在该文件
        if ([fileManager fileExistsAtPath:path ]) {
            [fileManager removeItemAtPath:path error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearDisk];
}

@end
