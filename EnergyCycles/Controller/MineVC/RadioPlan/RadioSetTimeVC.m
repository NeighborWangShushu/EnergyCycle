//
//  RadioSetTimeVC.m
//  EnergyCycles
//
//  Created by vj on 2017/1/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RadioSetTimeVC.h"
#import "SVSegmentedControl.h"
#import "RadioChooseItemVC.h"
#import "Masonry.h"

@interface RadioSetTimeVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)SVSegmentedControl *segmentedControl;
@property (nonatomic,strong)UIPickerView * datePickerView;

@property (nonatomic,strong)NSArray * hours;
@property (nonatomic,strong)NSMutableArray * minites;

@property (nonatomic,strong)RadioClockModel * model;


@property (nonatomic)NSInteger hour;
@property (nonatomic)NSInteger minute;

//重复
@property (nonatomic,strong)UILabel*time;

@end

@implementation RadioSetTimeVC


#pragma mark - GET

- (RadioClockModel*)model {
    if (!_model) {
        NSArray*arr = [RadioClockModel findAll];
        if (arr.count) {
            _model = [arr firstObject];
        }else{
            _model = [[RadioClockModel alloc] init];
        }
    }
    return _model;
}

- (UIPickerView*)datePickerView {
    
    if (!_datePickerView) {
        _datePickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _datePickerView.delegate = self;
        _datePickerView.dataSource = self;
    }
    return _datePickerView;
    
}

- (NSArray*)hours {
    if (!_hours) {
        _hours = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    }
    return _hours;
}

- (NSMutableArray*)minites {
    if (!_minites) {
        _minites = [NSMutableArray array];
        for (int i = 0; i <= 59; i++) {
            if (i < 10) {
                [_minites addObject:[NSString stringWithFormat:@"0%i",i]];
            }else {
                [_minites addObject:[NSString stringWithFormat:@"%i",i]];
            }
        }
    }
    return _minites;
}


#pragma mark - Init

- (instancetype)initWithModel:(RadioClockModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

- (void)setup {
    
    self.title = @"设置时间";
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    [self setupRightNavBarWithTitle:@"保存"];
    
    if (self.model) {
        if (self.model.hour == 0) {
            _hour = 8;
            self.model.hour = 8;
        }else {
            _hour = self.model.hour;
            _minute = self.model.minutes;
        }
    }
    __weak typeof(self) weakSelf = self;
    self.segmentedControl = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"   AM   ", @"   PM   ", nil]];
    [self.segmentedControl setSelectedSegmentIndex:self.model.slot animated:YES];
    self.segmentedControl.changeHandler = ^(NSUInteger newIndex) {
        // respond to index change
        weakSelf.model.slot = newIndex;
    };
    self.segmentedControl.backgroundImage = [UIImage imageNamed:@"mine_playradio_checked_bg@2x"];
    self.segmentedControl.thumb.backgroundImage = [UIImage imageNamed:@"mine_playradio_switch_button@2x.png"];
    self.segmentedControl.thumb.highlightedBackgroundImage = [UIImage imageNamed:@"mine_playradio_switch_button@2x.png"];
    self.segmentedControl.textColor = [UIColor colorWithRed:239.0/255.0 green:79.0/255.0 blue:81.0/255.0 alpha:1.0];
    self.segmentedControl.textShadowColor = [UIColor clearColor];
    self.segmentedControl.thumb.tintColor = [UIColor clearColor];
    self.segmentedControl.thumb.textShadowColor = [UIColor clearColor];
    self.segmentedControl.thumbEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@30);
        make.width.equalTo(@135);
        make.height.equalTo(@35);
    }];
    
    [self.view addSubview:self.datePickerView];
    [self.datePickerView selectRow:_hour - 1 inComponent:0 animated:NO];
    [self.datePickerView selectRow:_minute inComponent:1 animated:NO];

    [self.datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.top.equalTo(self.segmentedControl.mas_bottom).with.offset(20);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-100);
    }];
    
    UIView * bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:button];
    [button addTarget:self action:@selector(repeatAction:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);

    }];
    
    UILabel*name = [UILabel new];
    name.text = @"重复";
    name.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
    UIImageView*arrow = [UIImageView new];
    [arrow setImage:[UIImage imageNamed:@"Myjiantou"]];
    [bottomView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
    self.time = [UILabel new];
    self.time.text = self.model.notificationWeekydays;
    self.time.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:self.time];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-40);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeChanged:) name:@"RADIOPLAYSETTINGTIMECHANGED" object:nil];

    
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            _hour = row;
            break;
        case 1:
            _minute = row;
            break;
        default:
            break;
    }
}


#pragma mark - UIPickerViewDataSource

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 90;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextColor:[UIColor colorWithRed:239.0/255.0 green:79.0/255.0 blue:81.0/255.0 alpha:1.0]];
        [pickerLabel setFont:[UIFont systemFontOfSize:90]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.hours.count;
            break;
        case 1:
            return self.minites.count;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [self.hours objectAtIndex:row];
            break;
        case 1:
            return [self.minites objectAtIndex:row];
            break;
        default:
            break;
    }
    return @"";
}
#pragma mark - Action

- (void)timeChanged:(NSNotification*)notifi {
    
    self.model = [RadioClockModel findByPK:self.model.pk];
    self.time.text = self.model.notificationWeekydays;
    
}

- (void)repeatAction:(UIButton*)sender {
    RadioChooseItemVC * vc = [[RadioChooseItemVC alloc] initWithItemType:RadioChooseItemTypeDuration];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)leftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightAction {
    //save
    self.model.hour = _hour;
    self.model.minutes = _minute;
    [self.model saveOrUpdate];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RADIOPLAYSETTINGMODELCHANGED" object:nil];
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
