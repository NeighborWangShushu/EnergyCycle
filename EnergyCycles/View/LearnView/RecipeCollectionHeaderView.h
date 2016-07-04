//
//  RecipeCollectionHeaderView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCollectionHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *title;
- (IBAction)editAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *edit;
@end
