//
//  SearchResultTableViewCell.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/15.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell

//
@property (weak, nonatomic) IBOutlet UIView *bakcView;
//
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *chankanLabel;


@end
