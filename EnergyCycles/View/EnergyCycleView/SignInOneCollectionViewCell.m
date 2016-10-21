//
//  SignInOneCollectionViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "SignInOneCollectionViewCell.h"

@implementation SignInOneCollectionViewCell

#pragma mark - 填充数据
- (void)signInCollectionViewWithDataWithIndex:(NSInteger)index withMonthDay:(NSInteger)days withArr:(NSArray *)getArr withToday:(NSString *)today withNow:(NSString *)nowDay {
    //获取所有已签到数据
    NSMutableArray *timeDayArr = [[NSMutableArray alloc] init];
    for (SignInModel *model in getArr) {
        NSArray *timeArr = [model.DateTime componentsSeparatedByString:@" "];
        NSArray *subArr = [timeArr.firstObject componentsSeparatedByString:@"-"];
        
        [timeDayArr addObject:subArr.lastObject];
    }
    
    self.backImageView.image = [UIImage imageNamed:@"road_1.png"];
    
    //设置显示年、月
    [self.oneButton setTitle:today forState:UIControlStateNormal];
    [self.twoButton setTitle:today forState:UIControlStateNormal];
    [self.threeButton setTitle:today forState:UIControlStateNormal];
    [self.fourButton setTitle:today forState:UIControlStateNormal];
    [self.fiveButton setTitle:today forState:UIControlStateNormal];
    [self.sixButton setTitle:today forState:UIControlStateNormal];
    [self.sevenButton setTitle:today forState:UIControlStateNormal];
    [self.eightButton setTitle:today forState:UIControlStateNormal];
    [self.nineButton setTitle:today forState:UIControlStateNormal];
    [self.tenButton setTitle:today forState:UIControlStateNormal];
    [self.elevenButton setTitle:today forState:UIControlStateNormal];
    
    //添加响应事件
    [self.oneButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.twoButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.threeButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.fourButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.fiveButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sixButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sevenButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.eightButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nineButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tenButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.elevenButton addTarget:self action:@selector(signButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //去除响应事件
    self.oneButton.userInteractionEnabled = NO;
    self.twoButton.userInteractionEnabled = NO;
    self.threeButton.userInteractionEnabled = NO;
    self.fourButton.userInteractionEnabled = NO;
    self.fiveButton.userInteractionEnabled = NO;
    self.sixButton.userInteractionEnabled = NO;
    self.sevenButton.userInteractionEnabled = NO;
    self.eightButton.userInteractionEnabled = NO;
    self.nineButton.userInteractionEnabled = NO;
    self.tenButton.userInteractionEnabled = NO;
    self.elevenButton.userInteractionEnabled = NO;
    
    //隐藏掉所有签到状态
    self.oneImageView.hidden = YES;
    self.twoImageView.hidden = YES;
    self.threeImageView.hidden = YES;
    self.fourImageView.hidden = YES;
    self.fiveImageView.hidden = YES;
    self.sixImageView.hidden = YES;
    self.sevenImageView.hidden = YES;
    self.eightImageView.hidden = YES;
    self.nineImageView.hidden = YES;
    self.tenImageView.hidden = YES;
    self.elevenImageView.hidden = YES;
    
    //代码修改约束
    self.backViewLeftAutoLayout.constant = 0.f;
    self.backViewRightAutoLayout.constant = 0.f;
    
    self.oneImageAutoLayoutLeft.constant = 0.f;
    self.twoImageAutoLayoutLeft.constant = 50.f;
    
    self.oneButtonAutoLayoutLeft.constant = -22.f;
    
    //设置部分button不隐藏
    self.nineButton.hidden = NO;
    self.tenButton.hidden = NO;
    self.elevenButton.hidden = NO;
    
    //根据index创建界面
    if (index == 0) {//显示1-11号
        [self.oneButton setBackgroundImage:[[UIImage imageNamed:@"01_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        [self.twoButton setBackgroundImage:[UIImage imageNamed:@"02_1.png"] forState:UIControlStateNormal];
        [self.threeButton setBackgroundImage:[UIImage imageNamed:@"03_1.png"] forState:UIControlStateNormal];
        [self.fourButton setBackgroundImage:[UIImage imageNamed:@"04_1.png"] forState:UIControlStateNormal];
        [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"05_1.png"] forState:UIControlStateNormal];
        [self.sixButton setBackgroundImage:[UIImage imageNamed:@"06_1.png"] forState:UIControlStateNormal];
        [self.sevenButton setBackgroundImage:[UIImage imageNamed:@"07_1.png"] forState:UIControlStateNormal];
        [self.eightButton setBackgroundImage:[UIImage imageNamed:@"08_1.png"] forState:UIControlStateNormal];
        [self.nineButton setBackgroundImage:[UIImage imageNamed:@"09_1.png"] forState:UIControlStateNormal];
        [self.tenButton setBackgroundImage:[UIImage imageNamed:@"10_1.png"] forState:UIControlStateNormal];
        [self.elevenButton setBackgroundImage:[UIImage imageNamed:@"11_1.png"] forState:UIControlStateNormal];
        
        for (NSInteger i=0; i<timeDayArr.count; i++) {
            if ([timeDayArr[i] integerValue] == 1) {
                [self.oneButton setBackgroundImage:[UIImage imageNamed:@"01_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 2) {
                self.oneImageView.hidden = NO;
                [self.twoButton setBackgroundImage:[UIImage imageNamed:@"02_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 3) {
                self.twoImageView.hidden = NO;
                [self.threeButton setBackgroundImage:[UIImage imageNamed:@"03_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 4) {
                self.threeImageView.hidden = NO;
                [self.fourButton setBackgroundImage:[UIImage imageNamed:@"04_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 5) {
                self.fourImageView.hidden = NO;
                [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"05_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 6) {
                self.fiveImageView.hidden = NO;
                [self.sixButton setBackgroundImage:[UIImage imageNamed:@"06_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 7) {
                self.sixImageView.hidden = NO;
                [self.sevenButton setBackgroundImage:[UIImage imageNamed:@"07_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 8) {
                self.sevenImageView.hidden = NO;
                [self.eightButton setBackgroundImage:[UIImage imageNamed:@"08_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 9) {
                self.eightImageView.hidden = NO;
                [self.nineButton setBackgroundImage:[UIImage imageNamed:@"09_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 10) {
                self.nineImageView.hidden = NO;
                [self.tenButton setBackgroundImage:[UIImage imageNamed:@"10_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 11) {
                self.tenImageView.hidden = NO;
                [self.elevenButton setBackgroundImage:[UIImage imageNamed:@"11_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 12) {
                self.elevenImageView.hidden = NO;
            }
        }
        
        //代码改变约束
        self.backViewLeftAutoLayout.constant = 30.f;
        
        self.oneImageAutoLayoutLeft.constant = 30.f;
        self.twoImageAutoLayoutLeft.constant = 80.f;
        
        self.oneButtonAutoLayoutLeft.constant = -22 + 30.f;
        
        if ([nowDay integerValue] == 1) {
            self.oneButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 2) {
            self.twoButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 3) {
            self.threeButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 4) {
            self.fourButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 5) {
            self.fiveButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 6) {
            self.sixButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 7) {
            self.sevenButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 8) {
            self.eightButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 9) {
            self.nineButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 10) {
            self.tenButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 11) {
            self.elevenButton.userInteractionEnabled = YES;
        }
    }else if (index == 1) {//显示13-22号
        self.oneButton.userInteractionEnabled = NO;
        [self.oneButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [self.twoButton setBackgroundImage:[UIImage imageNamed:@"13_1.png"] forState:UIControlStateNormal];
        [self.threeButton setBackgroundImage:[UIImage imageNamed:@"14_1.png"] forState:UIControlStateNormal];
        [self.fourButton setBackgroundImage:[UIImage imageNamed:@"15_1.png"] forState:UIControlStateNormal];
        [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"16_1.png"] forState:UIControlStateNormal];
        [self.sixButton setBackgroundImage:[UIImage imageNamed:@"17_1.png"] forState:UIControlStateNormal];
        [self.sevenButton setBackgroundImage:[UIImage imageNamed:@"18_1.png"] forState:UIControlStateNormal];
        [self.eightButton setBackgroundImage:[UIImage imageNamed:@"19_1.png"] forState:UIControlStateNormal];
        [self.nineButton setBackgroundImage:[UIImage imageNamed:@"20_1.png"] forState:UIControlStateNormal];
        [self.tenButton setBackgroundImage:[UIImage imageNamed:@"21_1.png"] forState:UIControlStateNormal];
        [self.elevenButton setBackgroundImage:[UIImage imageNamed:@"22_1.png"] forState:UIControlStateNormal];
        
        if ([nowDay integerValue] == 13) {
            self.twoButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 14) {
            self.threeButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 15) {
            self.fourButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 16) {
            self.fiveButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 17) {
            self.sixButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 18) {
            self.sevenButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 19) {
            self.eightButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 20) {
            self.nineButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 21) {
            self.tenButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 22) {
            self.elevenButton.userInteractionEnabled = YES;
        }
        
        for (NSInteger i=0; i<timeDayArr.count; i++) {
            if ([timeDayArr[i] integerValue] == 12) {
                
            }else if ([timeDayArr[i] integerValue] == 13) {
                self.oneImageView.hidden = NO;
                [self.twoButton setBackgroundImage:[UIImage imageNamed:@"13_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 14) {
                self.twoImageView.hidden = NO;
                [self.threeButton setBackgroundImage:[UIImage imageNamed:@"14_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 15) {
                self.threeImageView.hidden = NO;
                [self.fourButton setBackgroundImage:[UIImage imageNamed:@"15_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 16) {
                self.fourImageView.hidden = NO;
                [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"16_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 17) {
                self.fiveImageView.hidden = NO;
                [self.sixButton setBackgroundImage:[UIImage imageNamed:@"17_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 18) {
                self.sixImageView.hidden = NO;
                [self.sevenButton setBackgroundImage:[UIImage imageNamed:@"18_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 19) {
                self.sevenImageView.hidden = NO;
                [self.eightButton setBackgroundImage:[UIImage imageNamed:@"19_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 20) {
                self.eightImageView.hidden = NO;
                [self.nineButton setBackgroundImage:[UIImage imageNamed:@"20_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 21) {
                self.nineImageView.hidden = NO;
                [self.tenButton setBackgroundImage:[UIImage imageNamed:@"21_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 22) {
                self.tenImageView.hidden = NO;
                [self.elevenButton setBackgroundImage:[UIImage imageNamed:@"22_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 23) {
                self.elevenImageView.hidden = NO;
            }
        }
    }else {//显示24-最后
        self.oneButton.userInteractionEnabled = NO;
        [self.oneButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        [self.twoButton setBackgroundImage:[UIImage imageNamed:@"24_1.png"] forState:UIControlStateNormal];
        [self.threeButton setBackgroundImage:[UIImage imageNamed:@"25_1.png"] forState:UIControlStateNormal];
        [self.fourButton setBackgroundImage:[UIImage imageNamed:@"26_1.png"] forState:UIControlStateNormal];
        [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"27_1.png"] forState:UIControlStateNormal];
        [self.sixButton setBackgroundImage:[UIImage imageNamed:@"28_1.png"] forState:UIControlStateNormal];
        [self.sevenButton setBackgroundImage:[UIImage imageNamed:@"29_1.png"] forState:UIControlStateNormal];
        [self.eightButton setBackgroundImage:[UIImage imageNamed:@"30_1.png"] forState:UIControlStateNormal];
        [self.nineButton setBackgroundImage:[UIImage imageNamed:@"31_1.png"] forState:UIControlStateNormal];
        
        self.backViewRightAutoLayout.constant = 30.f;
        
        if ([nowDay integerValue] == 24) {
            self.twoButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 25) {
            self.threeButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 26) {
            self.fourButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 27) {
            self.fiveButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 28) {
            self.sixButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 29) {
            self.sevenButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 30) {
            self.eightButton.userInteractionEnabled = YES;
        }else if ([nowDay integerValue] == 31) {
            self.nineButton.userInteractionEnabled = YES;
        }
        
        //第三个 设置最后三个不显示
        self.backImageView.image = [UIImage imageNamed:@"road_2.png"];
        self.nineImageView.hidden = YES;
        self.tenImageView.hidden = YES;
        self.tenButton.hidden = YES;
        self.elevenImageView.hidden = YES;
        self.elevenButton.hidden = YES;
        
        if (days == 28) {
            self.sevenButton.hidden = YES;
            self.eightButton.hidden = YES;
            self.nineButton.hidden = YES;
        }else if (days == 29) {
            self.eightButton.hidden = YES;
            self.nineButton.hidden = YES;
        }else if (days == 30) {
            self.nineButton.hidden = YES;
        }
        
        for (NSInteger i=0; i<timeDayArr.count; i++) {
            if ([timeDayArr[i] integerValue] == 24) {
                self.oneImageView.hidden = NO;
                [self.twoButton setBackgroundImage:[UIImage imageNamed:@"24_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 25) {
                self.twoImageView.hidden = NO;
                [self.threeButton setBackgroundImage:[UIImage imageNamed:@"25_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 26) {
                self.threeImageView.hidden = NO;
                [self.fourButton setBackgroundImage:[UIImage imageNamed:@"26_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 27) {
                self.fourImageView.hidden = NO;
                [self.fiveButton setBackgroundImage:[UIImage imageNamed:@"27_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 28) {
                self.fiveImageView.hidden = NO;
                [self.sixButton setBackgroundImage:[UIImage imageNamed:@"28_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 29) {
                self.sixImageView.hidden = NO;
                [self.sevenButton setBackgroundImage:[UIImage imageNamed:@"29_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 30) {
                self.sevenImageView.hidden = NO;
                [self.eightButton setBackgroundImage:[UIImage imageNamed:@"30_2.png"] forState:UIControlStateNormal];
            }else if ([timeDayArr[i] integerValue] == 31) {
                self.eightImageView.hidden = NO;
                [self.nineButton setBackgroundImage:[UIImage imageNamed:@"31_2.png"] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - btn点击响应事件
- (void)signButtonClick:(UIButton *)button {
    if (_signInButtonClcik) {
        _signInButtonClcik();
    }
}


@end
