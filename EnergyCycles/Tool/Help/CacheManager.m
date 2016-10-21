//
//  CacheManager.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager

- (CGFloat)fileSizeAtPath:(NSString *)path {
    // 创建NSFileManager对象来对文件进行管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 判断获取到的路径是否正确,如果不正确就直接返回大小为0
    if ([fileManager fileExistsAtPath:path]) {
        // NSFileManager对象根据路径获取文件的属性,从而得到文件的大小
        CGFloat size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

- (CGFloat)folderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    CGFloat folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
//        NSLog(@"系统缓存%f",folderSize);
        // SDWebImage
        folderSize = [[SDImageCache sharedImageCache] getSize];
//        NSLog(@"缓存大小%f",folderSize);
        return folderSize/1024.0/1024.0;
    }
    return 0;
}

- (void)clearCache:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}


/**
 
 *获取缓存大小
 
 */

+ (CGFloat)getCachesSizeCount {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    return [[CacheManager alloc] folderSizeAtPath:path];
}

/**
 
 *清除本地缓存
 
 */
+ (void)cleadDisk {
//    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearDisk];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths lastObject];
//    [[CacheManager alloc] clearCache:path];
}

@end
