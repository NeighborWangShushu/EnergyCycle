//
//  leaderboardViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface leaderboardViewController : BaseViewController {
    IBOutlet UITableView *leaderBoardTableView;
}
//头
@property (weak, nonatomic) IBOutlet UIView *headBackView;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//排名
@property (weak, nonatomic) IBOutlet UILabel *paimingLabel;

@property (nonatomic, strong) NSString *showName;

@property (nonatomic, copy) NSString *userId;


@end
