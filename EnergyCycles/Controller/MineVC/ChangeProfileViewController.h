//
//  ChangeProfileViewController.h
//  EnergyCycles
//
//  Created by Adinnet on 15/12/21.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangeProfileViewController : BaseViewController

//
@property (nonatomic, strong) NSString *touchSection;
//
@property (nonatomic, strong) NSString *touchIndex;

//
@property (nonatomic, strong) NSString *showStr;

//
@property (nonatomic, strong) NSString *changeProType;

@property (nonatomic, strong) NSString *value;

//
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//
@property (weak, nonatomic) IBOutlet UITextField *inputTextFiled;
//
@property (weak, nonatomic) IBOutlet UIButton *comButton;



@end
