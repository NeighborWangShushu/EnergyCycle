//
//  RadioListTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RadioListTableViewCell.h"
#import "AFSoundManager.h"
#import "ECAudioPlayAnimation.h"
#import "RadioNotificationController.h"

@interface RadioListTableViewCell ()


@property (nonatomic) dispatch_source_t timer;
@property (nonatomic, strong) ECAudioPlayAnimation *animation;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSURL *cellUrl;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) RadioClockModel * radioModel;
@property (nonatomic, strong) RadioModel * model;


@property (nonatomic)BOOL isCounting;

@property (nonatomic) CGFloat duration;

@end

@implementation RadioListTableViewCell

- (void)getDataWithModel:(RadioModel *)model clockModel:(RadioClockModel*)radioModel{
    
    _model = model;
    _radioModel = radioModel;
    self.cellUrl = [NSURL URLWithString:model.RadioUrl];
    self.ID = model.ID;
    if ([AFSoundManager sharedManager].player.status == AVPlayerStatusReadyToPlay) {
        
        if ([self.cellUrl isEqual:self.radioUrl]) {
            
            [self setAnimation];
        }
    } else {
        self.isPlay = NO;
    }
    
    // 电台图片
    [self.radioImage sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl]];
    self.radioImage.layer.cornerRadius = 5;
    self.radioImage.layer.masksToBounds = YES;
    
    // 电台名字
    self.radioName.text = model.Name;
    
    // 电台简介
    if (model.Intro == nil || [model.Intro isEqualToString:@""]) {
        self.radioIntro.text = @"暂无简介";
    } else {
        self.radioIntro.text = model.Intro;
    }
    
    [self setupClock:radioModel withRadioModel:model];
    
    [self lineView];
}


- (void)setupClock:(RadioClockModel*)radioModel withRadioModel:(RadioModel*)model {
    
    self.radioModel = radioModel;
    
        //如果已经发送过通知(时间已到)
            if (self.radioModel && [radioModel.channelName isEqualToString:model.Name] && self.radioModel.isOpen && self.radioModel.residueTime > 0) {
                [[RadioNotificationController shareInstance] findNotificationWithModel:radioModel success:^(BOOL isExist) {
                    if (isExist) {

                    _clock.hidden = NO;
                    _radioTime.hidden = NO;
                    [self startCount];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RadioCollectionCellPlay" object:nil userInfo:@{@"url" : [NSString stringWithFormat:@"%@", self.cellUrl], @"index" : self.ID}];
                    [self setAnimation];
                }
            }];
        }
    
}


- (void)lineView {
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(self.frame.origin.x + 12, self.frame.size.height - 1, self.frame.size.width + 50, 1);
    line.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    [self.contentView addSubview:line];
}


- (void)setAnimation {
    
    self.isPlay = YES;
    self.animation = [[ECAudioPlayAnimation alloc] initWithFrame:CGRectMake(0, 30, 50, 20)];
    self.animation.numberOfRect = 6;
    self.animation.rectColor = [UIColor whiteColor];
    self.animation.space = 1;
    self.animation.rectSize = CGSizeMake(50, 20);
    self.animation.rectWidth = 8;
    self.RadioPlayAnimation.clipsToBounds = YES;
    [self.RadioPlayAnimation addSubview:self.animation];
    [self.animation startAnimation];
    
}

- (void)stopAnimation {
    [self.radioModel saveOrUpdate];
    self.isPlay = NO;
    [self.animation stopAnimation];
}

- (void)stopRadioPlayer:(NSNotification *)notification {
    NSURL *stopUrl = [[notification userInfo] objectForKey:@"radioUrl"];
    if ([stopUrl isEqual:self.cellUrl]) {
        [self stopAnimation]; // 停止
    }
}

- (void)play {
    if (!self.isPlay) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RadioCollectionCellPlay" object:nil userInfo:@{@"url" : [NSString stringWithFormat:@"%@", self.cellUrl], @"index" : self.ID}];
        [self setAnimation];
        [self setupClock:_radioModel withRadioModel:_model];
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RadioCollectionCellStop" object:nil userInfo:@{@"url" : [NSString stringWithFormat:@"%@", self.cellUrl], @"index" : self.ID}];
        [self stopAnimation];
        [self stopCount];

    }
}

- (void)startCount {
    __block int time = self.radioModel.residueTime;
    if (!_timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            
            if (time <= 0) {
                dispatch_source_cancel(_timer);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    _radioTime.text = @"已完成";
                    [self stopAnimation];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RadioCollectionCellStop" object:nil userInfo:@{@"url" : [NSString stringWithFormat:@"%@", self.cellUrl], @"index" : self.ID}];
                    
                });
            } else {
                int minutes = time/60;
                int seconds = time%60;
                NSString * timeText = [NSString stringWithFormat:@"%.2d:%.2d",minutes,seconds];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    _radioTime.text = timeText;
                });
                
                time--;
                self.radioModel.residueTime = time;
                
            }
            
        });

    }
        dispatch_resume(_timer);
    
}

- (void)stopCount {
    if (_timer) {
        dispatch_suspend(_timer);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRadioPlayer:) name:@"stopRadioPlayer" object:nil];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
