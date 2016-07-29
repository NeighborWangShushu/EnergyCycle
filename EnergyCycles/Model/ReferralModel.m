//
//  ReferralModel.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ReferralModel.h"

@implementation ReferralModel


- (id)initWithReferral:(NSDictionary *)data {
    self = [super init];
    if (self) {
        [self initialize];
        [self configReferral:data];
    }
    return self;
}

- (id)initWithHot:(NSDictionary *)data {
    self = [super init];
    if (self) {
        [self initialize];
        [self configOtherData:data];
    }
    return self;
}

- (id)initWithOther:(NSDictionary *)data {
    self = [super init];
    if (self) {
        [self initialize];
        [self configOtherData:data];
    }
    return self;
}

- (void)initialize {
    self.banners = [NSMutableArray array];
    self.health = [NSMutableArray array];
    self.radios = [NSMutableArray array];
}

//对数据进行排序，根据studyType字段把数据放入不同的字典里，每个字典代表一个版块，它的值为以HealthModel为元素的数组
- (void)filterHealthData:(HealthModel*)model {
    
    if ([self.health count] == 0) {
        NSMutableDictionary*newdic = [NSMutableDictionary new];
        [newdic setObject:[NSMutableArray arrayWithObjects:model, nil] forKey:model.typeName];
        [self.health addObject:newdic];
        return;
    }
    __block BOOL isHasModel = false;
    __block NSUInteger index = 0;

    //如果health不是空数组
    for (NSMutableDictionary*dic in self.health) {
        //查找是否有目标模块组
       isHasModel = [dic objectForKey:model.typeName];
    }
    
    [self.health enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([[obj allKeys][0] isEqualToString:model.typeName]) {
            isHasModel = YES;
            index = idx;
        }
    }];
    
    if (isHasModel) {
        [self.health[index][model.typeName] addObject:model];
    }else {
        NSMutableDictionary*newdic = [NSMutableDictionary new];
        [newdic setObject:[NSMutableArray arrayWithObjects:model, nil] forKey:model.typeName];
        [self.health addObject:newdic];
    }
    
//    [[dic objectForKey:model.typeName]addObject:model];
    
}

//解析推荐页面数据
- (void)configReferral:(NSDictionary*)data {
    
    [self.banners removeAllObjects];
    [self.radios removeAllObjects];
    
    if (data) {
        if ([data objectForKey:@"Data"]) {
            NSArray * arr = [data objectForKey:@"Data"];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary * dic = arr[i];
                if ([dic[@"IS_Recommend"] integerValue] == 1) {
                    
                    HealthModel*model = [[HealthModel alloc] init];
                    model.title = dic[@"title"];
                    model.course = dic[@"summary"];
                    model.pic = dic[@"img"];
                    model.time = dic[@"addTime"];
                    model.typeName = dic[@"studyType"];
                    model.videoTime = dic[@"VideoTime"] == [NSNull null]?0:[dic[@"VideoTime"] integerValue];
                    model.like = [dic[@"GoodCount"] integerValue];
                    model.ID = [dic[@"id"] integerValue];
                    model.message = [dic[@"CommentCount"] integerValue];
                    model.isVideo = model.videoTime > 0;
                    model.read_count = [NSString stringWithFormat:@"%d",[dic[@"readCount"] integerValue]];
                    model.type = [[dic objectForKey:@"Video"] isEqualToString:@""]?HealthModelTypeArticle:HealthModelTypeVideo;
                    [self filterHealthData:model];
                    
                }else if ([dic[@"IS_Recommend"] integerValue] == 0) {
                    
                    BannerItem * item = [[BannerItem alloc] init];
                    item.pic = [dic objectForKey:@"img"];
                    item.url = [dic objectForKey:@"summary"];
                    item.name = [dic objectForKey:@"summary"];
                    item.type = [[dic objectForKey:@"studyType"]integerValue];
                    [self.banners addObject:item];
                }
            }
        }
        
        NSArray * radios = @[@{@"pic":@"bbc",@"url":@"http://bbcwssc.ic.llnwd.net/stream/bbcwssc_mp1_ws-einws"},
                             
                             @{@"pic":@"cnn",@"url":@"http://stream.eudic.net/en_cnn.mp3?agent=%2feusoft_ting_en_iphone%2f6.2.2%2fDB6B1191-8DC3-4859-AB43-B7A6FA95411F_mac_02%3a00%3a00%3a00%3a00%3a00%2f&token=QYN+eyJ0b2tlbiI6IiIsInVzZXJpZCI6IiIsInVybHNpZ24iOiJSeTM5UDZkOXBSdnkvSk8ySFFqbGQ1bjhTVVU9In0%3d&stamp=636016921048138325"},
                             
                             @{@"pic":@"fox",@"url":@"http://stream.eudic.net/en_fox.mp3?agent=%2feusoft_ting_en_iphone%2f6.2.2%2fDB6B1191-8DC3-4859-AB43-B7A6FA95411F_mac_02%3a00%3a00%3a00%3a00%3a00%2f&token=QYN+eyJ0b2tlbiI6IiIsInVzZXJpZCI6IiIsInVybHNpZ24iOiJJRlhlUStoYXQ1RXJwc09STWFoT2tpNjgxdDA9In0%3d&stamp=636016934789934311"},
                             
                             @{@"pic":@"npr",@"url":@"http://stream.eudic.net/en_cnn.mp3?agent=%2feusoft_ting_en_iphone%2f6.2.2%2fDB6B1191-8DC3-4859-AB43-B7A6FA95411F_mac_02%3a00%3a00%3a00%3a00%3a00%2f&token=QYN+eyJ0b2tlbiI6IiIsInVzZXJpZCI6IiIsInVybHNpZ24iOiJSeTM5UDZkOXBSdnkvSk8ySFFqbGQ1bjhTVVU9In0%3d&stamp=636016921048138325"},
                             
                             @{@"pic":@"australia",@"url":@"http://live-radio02.mediahubaustralia.com/PBW/aac/;?agent=%2feusoft_ting_en_iphone%2f6.2.2%2fDB6B1191-8DC3-4859-AB43-B7A6FA95411F_mac_02%3a00%3a00%3a00%3a00%3a00%2f&token=QYN+eyJ0b2tlbiI6IiIsInVzZXJpZCI6IiIsInVybHNpZ24iOiJ6TkJaa256QVdKczVMVThOK09jbTM3OEN4ZWM9In0%3d&stamp=636016916682598631"},
                             
                             @{@"pic":@"ted",@"url":@"http://50.31.213.82/TEDTalks"}];
        
        for (int i = 0; i < radios.count; i++) {
            NSDictionary * dic = radios[i];
            RadioItem * item = [RadioItem new];
            item.url = dic[@"url"];
            item.pic = dic[@"pic"];
            [self.radios addObject:item];
        }
    }
}


//解析其他页面数据
- (void)configOtherData:(NSDictionary*)data {
    [self.health removeAllObjects];
    if (data) {
        if ([data objectForKey:@"Data"]) {
            NSArray * arr = [data objectForKey:@"Data"];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary * dic = arr[i];
                HealthModel*model = [[HealthModel alloc] init];
                model.title = dic[@"title"];
                model.course = dic[@"summary"];
                model.pic = dic[@"img"];
                model.ID = [dic[@"id"] integerValue];
                model.typeName = dic[@"studyType"];
                model.videoTime = dic[@"VideoTime"] == [NSNull null]?0:[dic[@"VideoTime"] integerValue];
                model.type = [[dic objectForKey:@"Video"] isEqualToString:@""]?HealthModelTypeArticle:HealthModelTypeVideo;
                model.like = [dic[@"GoodCount"] integerValue];
                model.isVideo = model.videoTime > 0;
                model.read_count = [NSString stringWithFormat:@"%ld",[dic[@"readCount"] integerValue]];
                model.message = [dic[@"CommentCount"] integerValue];
                model.time = dic[@"addTime"];
                [self.health addObject:model];
            }
        }
    }
}


@end
