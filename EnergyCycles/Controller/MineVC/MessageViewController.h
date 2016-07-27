//
//  MessageViewController.h
//  EnergyCycles
//
//  Created by 王斌 on 16/7/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageViewController : BaseViewController

// 评论按钮
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
// 未读评论
@property (weak, nonatomic) IBOutlet UIView *unreadComment;
// 点赞
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
// 未读点赞
@property (weak, nonatomic) IBOutlet UIView *unreadLike;
// 私信
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
// 未读私信
@property (weak, nonatomic) IBOutlet UIView *unreadMessage;
// 下划线
@property (weak, nonatomic) IBOutlet UIView *underLine;
// 类型(1是评论,2是点赞,3是私信)
@property (nonatomic, assign) int type;
// 列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
