//
//  HealthModel.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    HealthModelTypeVideo,
    HealthModelTypeArticle
}HealthModelType;

@interface HealthModel : NSObject

@property (nonatomic,copy)NSString * title;

@property (nonatomic,copy)NSString * desc;

@property (nonatomic,copy)NSString * pic;

@property (nonatomic)HealthModelType type;

@property (nonatomic,assign)NSString * typeName;

@property (nonatomic,copy)NSString * from;

@property (nonatomic,copy)NSString * course; //课程

@property NSInteger like,message;

@property (nonatomic)NSInteger videoTime; //视频时长

@property (nonatomic,copy)NSString * time; //发布时间 （多少时间前）

@property (nonatomic,copy)NSString * read_count;

@property (nonatomic)NSInteger  ID;

@property (nonatomic)NSInteger  goodCount;

@property (nonatomic)NSInteger  commentCount;

@property (nonatomic,copy)NSString * url;

@property (nonatomic,assign)BOOL isVideo;

@end
