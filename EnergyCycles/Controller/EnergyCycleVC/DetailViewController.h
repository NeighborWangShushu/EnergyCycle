//
//  DetailViewController.h
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/11/25.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

#import "EnergyCycleShowCellModel.h"
#import "TheAdvMainModel.h"

@interface DetailViewController : BaseViewController {
    IBOutlet UITableView *detailTabelView;
    
    UIView *deatilWabBackView;
    UIWebView *detailWebView;
}

//区分 
@property (nonatomic, strong) NSString *tabBarStr;

//id
@property (nonatomic, strong) NSString *showDetailId;
//title
@property (nonatomic, strong) NSString *showTitle;

//
@property (nonatomic, strong) TheAdvMainModel *advModel;

//点击的cell下标
@property (nonatomic, assign) NSInteger touchIndex;

@property (nonatomic, strong) NSString *isMine;

//
@property (nonatomic, strong) NSString *videoUrl;


@end
