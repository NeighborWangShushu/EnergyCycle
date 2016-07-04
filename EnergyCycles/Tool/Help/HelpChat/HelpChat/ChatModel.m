//
//  ChatModel.m
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChatModel.h"

#import "UUMessage.h"
#import "UUMessageFrame.h"

@implementation ChatModel

- (void)populateRandomDataSourceWithModel:(NSMutableArray *)arr {
    self.dataSource = [NSMutableArray array];
    
    JiaoLiuListModel *model = [[JiaoLiuListModel alloc] init];
    for (NSInteger i=arr.count-1; i>=0; i--) {
        model = (JiaoLiuListModel *)arr[i];
        [self.dataSource addObjectsFromArray:[self additems:1 withModel:model]];
    }
}

- (void)addRandomItemsToDataSource:(NSInteger)number {
//    for (int i=0; i<number; i++) {
//        [self.dataSource insertObject:[[self additems:1] firstObject] atIndex:0];
//    }
}

// 添加自己的item
- (void)addSpecifiedItem:(NSDictionary *)dic {    
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
    [dataDic setObject:timeStr forKey:@"strTime"];
    
    NSString *str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"headpic"];
    if (str1.length != 0) {
        [dataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"] forKey:@"strName"];
    }
    if (str2.length != 0) {
        [dataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"headpic"] forKey:@"strIcon"];
    }
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
}

// 添加聊天item（一个cell内容）
static NSString *previousTime = nil;
- (NSArray *)additems:(NSInteger)number withModel:(JiaoLiuListModel *)model {
    NSMutableArray *result = [NSMutableArray array];
    for (int i=0; i<number; i++) {
        NSDictionary *dataDic = [self getDicWithModel:model];
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:dataDic];
        [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        
        if (message.showDateLabel) {
            previousTime = dataDic[@"strTime"];
        }
        [result addObject:messageFrame];
    }
    
    return result;
}

// 如下:群聊（groupChat）
//static int dateNum = 10;
- (NSDictionary *)getDicWithModel:(JiaoLiuListModel *)model {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    int randomNum = [model.mark intValue];
    if (randomNum == 1) {
        randomNum = UUMessageTypePicture;
        [dictionary setObject:model.content forKey:@"pictureUrl"];
    }else if (randomNum == 2) {
        randomNum = UUMessageTypeVoice;
        [dictionary setObject:model.content forKey:@"voiceUrl"];
    }else{
        randomNum = UUMessageTypeText;
        [dictionary setObject:model.content forKey:@"strContent"];
    }
    
//    if (model.type.length != 0) {
////        if ([model.ismy intValue] == 1) {
////            [dictionary setObject:@(UUMessageFromMe) forKey:@"from"];
////        }else {
////            [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
////        }
//        if ([model.type intValue] == 1) {
//            [dictionary setObject:@(UUMessageFromMe) forKey:@"from"];
//        }else {
//            [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
//        }
//    }else {
//        if ([model.isitself intValue] == 1) {
//            [dictionary setObject:@(UUMessageFromMe) forKey:@"from"];
//        }else {
//            [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
//        }
//    }
    
    if ([model.isitself intValue] == 1) {
        [dictionary setObject:@(UUMessageFromMe) forKey:@"from"];
    }else {
        [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
    }
    
    [dictionary setObject:@(randomNum) forKey:@"type"];
    [dictionary setObject:model.createtime forKey:@"strTime"];
    // 这里判断是否是私人会话、群会话
    [dictionary setObject:model.nickname forKey:@"strName"];
    [dictionary setObject:model.headpic forKey:@"strIcon"];
    
    return dictionary;
}


@end
