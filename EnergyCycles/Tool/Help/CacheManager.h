//
//  CacheManager.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CacheManager : NSObject
/**
 *  本地缓存的计算以及清除
 */


- (CGFloat)fileSizeAtPath:(NSString *)path;

- (CGFloat)folderSizeAtPath:(NSString *)path;

- (void)clearCache:(NSString *)path;

+ (CGFloat)getCachesSizeCount;

+ (void)cleadDisk;

@end
