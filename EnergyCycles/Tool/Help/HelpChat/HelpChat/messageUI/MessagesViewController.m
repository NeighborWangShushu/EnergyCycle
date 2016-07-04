//
//  MessagesViewController.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "MessagesViewController.h"
#import "MessageInputView.h"
#import "NSString+MessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "AppDelegate.h"
#import "lame.h"
//#import "JiaoLiuListModel.h"

#define INPUT_HEIGHT 40.0f
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface MessagesViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    CGRect rect;
    
    AVAudioRecorder *recorder;//录音器
    AVAudioSession *session;
    NSDictionary *recorderSettingsDict;
    NSString *playName;
    
    NSTimer *timer;
    UIImageView *peakImageView;
    UIImagePickerController *picker;
}

- (void)setup;

@end

@implementation MessagesViewController
#pragma mark - Initialization
- (void)setup {
    rect=[UIScreen mainScreen].bounds;
    CGSize size = self.view.frame.size;
	
    CGRect tableFrame = CGRectMake(0.0f, 64.0f, size.width, size.height - INPUT_HEIGHT);
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self.view addSubview:self.tableView];
	
    UIColor *color = [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f];
    [self setBackgroundColor:color];
    
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputView = [[MessageInputView alloc] initWithFrame:inputFrame];
    self.inputView.textView.delegate = self;
    [self.inputView.sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView.sendEmotionButton addTarget:self action:@selector(sendEmotionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inputView];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    swipe.numberOfTouchesRequired = 1;
    [self.inputView addGestureRecognizer:swipe];
    
    if(scrollView==nil){
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, rect.size.height-216, 320, 216)];
        [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
        for (int i=0; i<9; i++) {
            FacialView *fview=[[FacialView alloc]initWithFrame:CGRectMake(12+320*i, 15, 300, 170)];
            [fview loadFacialView:i size:CGSizeMake(33, 43)];
            fview.delegate=self;
            [scrollView addSubview:fview];
        }
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(320*9, 216);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    [scrollView setHidden:YES];
    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(85, 530, 150, 30)];
    [pageControl setCurrentPage:0];
    pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
    pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
    pageControl.numberOfPages = 9;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.hidden=NO;
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    [pageControl setHidden:YES];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollview {
    int page=scrollview.contentOffset.x/320;
    pageControl.currentPage=page;
}

-(void)changePage:(id)sender {
    int page=(int)pageControl.currentPage;
    [scrollView setContentOffset:CGPointMake(320*page, 0)];
}

- (void)selectedFacialView:(NSString *)str {}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newface:) name:@"selectedFacial" object:nil];
    
    [self setup];
    
    peakImageView = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_width-130)/2, 170, 130, 130)];
    [self.view addSubview:peakImageView];
    [self.view insertSubview:peakImageView atIndex:[self.view subviews].count+1];
    peakImageView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self scrollToBottomAnimated:NO];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text {
    
} // override in subclass

#pragma mark - 发送消息
- (void)sendPressed:(UIButton *)sender {
    [self sendPressed:sender
             withText:[self.inputView.textView.text trimWhitespace]];
    CGFloat textViewContentHeight = self.inputView.textView.contentSize.height;
    CGFloat changeInHeight = textViewContentHeight - 36;
    CGRect inputViewFrame = self.inputView.frame;
    self.inputView.frame = CGRectMake(0.0f,
                                      inputViewFrame.origin.y + changeInHeight,
                                      inputViewFrame.size.width,
                                      inputViewFrame.size.height - changeInHeight+20);
    self.previousTextViewContentHeight=36;
}

/************************************/
#pragma mark - 录音界面
-(void)sendEmotionButton:(UIButton *)button {
//    [scrollView setHidden:NO];
//    [pageControl setHidden:NO];
//    [self.inputView.textView resignFirstResponder];
//    self.inputView.frame=CGRectMake(0, rect.size.height-216-40, 320, 40);
//    scrollView.frame=CGRectMake(0, rect.size.height-216, 320, 216);
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    if (!_isVoice) {
        voiceImageView = [[MyImageView alloc] initWithFrame:CGRectMake(49, 6, self.inputView.bounds.size.width-113, 30)];
        voiceImageView.userInteractionEnabled = YES;
        [voiceImageView setImage:[UIImage imageNamed:@"NoPressImage.png"]];
        [self.inputView addSubview:voiceImageView];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGetVoice:)];
        longPress.delegate = self;
        longPress.numberOfTouchesRequired = 1;
        longPress.allowableMovement = 100.f;
        longPress.minimumPressDuration = 2.f;
        [voiceImageView addGestureRecognizer:longPress];
        [voiceImageView addTarget:self action:@selector(getVoice)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, voiceImageView.bounds.size.width, 30)];
        label.text = @"按住  说话";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        [voiceImageView addSubview:label];
        
        [self.inputView.sendEmotionButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.inputView.sendEmotionButton setBackgroundImage:[[UIImage imageNamed:@"Text.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        [self.inputView.sendButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(Screen_width-60, 6, 50, 30);
        [btn setImage:[[UIImage imageNamed:@"add_jia.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(getImageView) forControlEvents:UIControlEventTouchUpInside];
        
        [self.inputView addSubview:btn];
        
        _isVoice = YES;
    }else {
        [self.inputView.sendEmotionButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.inputView.sendEmotionButton setBackgroundImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateNormal];
        [voiceImageView removeFromSuperview];
        [btn removeFromSuperview];
        
        [self.inputView.sendButton setBackgroundImage:[[UIImage imageNamed:@"Send.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        _isVoice = NO;
    }
}

#pragma mark - 录音按键
- (void)getVoice {
    peakImageView.hidden = NO;
    [self startSource];
    [voiceImageView setImage:[UIImage imageNamed:@"PressImage.png"]];
}
- (void)longPressGetVoice:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {}
    
    if (longPress.state == UIGestureRecognizerStateEnded) {
        [self stopSource];
        [voiceImageView setImage:[UIImage imageNamed:@"NoPressImage.png"]];
        peakImageView.hidden = YES;
    }
}
#pragma mark - 开始录音
- (void)startSource {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if (session == nil) {
            NSLog(@"Error creating session:%@",[sessionError description]);
        }else {
            [session setActive:YES error:nil];
        }
    }
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    playName = [NSString stringWithFormat:@"%@/TuChu.caf",docDir];
    //录音设置
    recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                           [NSNumber numberWithFloat:11025.0],AVSampleRateKey,
                           [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                           [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                           [NSNumber numberWithInt:AVAudioQualityMin],
                           AVEncoderAudioQualityKey,
                           nil];
    
    //按下录音
    if ([self canRecord]) {
        NSError *error = nil;
        //必须真机上测试,模拟器上可能会崩溃
        recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:playName] settings:recorderSettingsDict error:&error];
        
        if (recorder) {
            recorder.meteringEnabled = YES;
            [recorder prepareToRecord];
            [recorder record];
            
            //启动定时器
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
        }
    }
}
-(void)levelTimer:(NSTimer*)timer_ {
    [recorder updateMeters];
    
    [self updateMetersByAvgPower:[recorder averagePowerForChannel:0]];
    if (recorder.currentTime>=30) {
        [recorder stop];
    }
}
- (void)updateMetersByAvgPower:(float)_avgPower{
    //-160表示完全安静，0表示最大输入值
    NSArray *peakImageArray = @[@"pressImage_1.png",@"pressImage_2.png",@"pressImage_3.png",@"pressImage_4.png",@"pressImage_5.png",@"pressImage_6.png"];
    NSInteger imageIndex = 0;
    if (_avgPower < -108) {
        imageIndex = 0;
    }else if (_avgPower >= -108 && _avgPower < -40) {
        imageIndex = 1;
    }else if (_avgPower >= -40 && _avgPower < -30) {
        imageIndex = 2;
    }else if (_avgPower >= -30 && _avgPower < -20) {
        imageIndex = 3;
    }else if (_avgPower >= -20 && _avgPower < -10) {
        imageIndex = 4;
    }else {
        imageIndex = 5;
    }
    
    peakImageView.image =[UIImage imageNamed:[peakImageArray objectAtIndex:imageIndex]] ;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - 结束录音
- (void)stopSource {
    [recorder stop];
    recorder = nil;
    
    session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    if(session == nil){
        NSLog(@"Error creating session: %@", [sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    
    [self changeCafToMp3];
}
- (void)stopTimer {
    if (timer && timer.isValid){
        [timer invalidate];
        timer = nil;
    }
}
#pragma mark - 判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord {
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    return bCanRecord;
}
#pragma mark - 转换格式
- (void)changeCafToMp3 {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cafFilePath = playName;
    NSString *mp3FilePath = [NSString stringWithFormat:@"%@mp3",[cafFilePath substringToIndex:[cafFilePath length]-3]];
    
    if([fileManager removeItemAtPath:mp3FilePath error:nil]) {
        
    }
    
    @try {
        int read, write;
        const char *version = get_lame_version();
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
    }
    @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    }
    [fileManager removeItemAtPath:playName error:&error];
    
    NSData *voiceData = [NSData dataWithContentsOfFile:mp3FilePath];
    [self updateUserHeadImageViewWithData:voiceData withType:2];
}
#pragma mark - 播放音频
//- (void)play {
//    //NSURL *VoiceUrl = [NSURL URLWithString:playerUrl];
//    NSData *audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:playName]];
//    audioData = [NSData dataWithContentsOfFile:playName];
//    player = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
//    
//    //player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:mp3FilePath] error:nil];
//    
//    player.volume = 0.8;
//    player.delegate = self;
//    [player play];
//}

#pragma mark - 获取图片
- (void)getImageView {
    //[self play];
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self showActionSheet];
}
-(void)showActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"从相册选择"
                                  otherButtonTitles:@"相机",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!picker) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing=YES;
    }
    
    if (buttonIndex==0) {//从相册选择
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }else if (buttonIndex==1){//相机
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image= [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *selectImageData=UIImageJPEGRepresentation(image, 0.01);
    [self updateUserHeadImageViewWithData:selectImageData withType:1];
    
    [_picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 上传数据
- (void)updateUserHeadImageViewWithData:(NSData *)data withType:(int)type {
//    if (type == 1) {//上传图片
//        [TTM postPostFileWithImageData:data success:^(NSDictionary *dic) {
//            if ([dic[@"Code"] integerValue] == 200) {
//                
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//    }else {//上传语音
//        [TTM postPostFileAudioWithVoiceData:data success:^(NSDictionary *dic) {
//            if ([dic[@"Code"] integerValue] == 200) {
//                //dic[@"Data"]
//                //self sendPressed:<#(UIButton *)#> withText:<#(NSString *)#>
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//    }
}


/******************************/

- (void)handleSwipe:(UIGestureRecognizer *)guestureRecognizer {
    [self.inputView.textView resignFirstResponder];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BubbleMessageStyle style = [self messageStyleForRowAtIndexPath:indexPath];
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell%d", style];
    BubbleMessageCell *cell = (BubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    
    if(!cell) {
        cell = [[BubbleMessageCell alloc] initWithBubbleStyle:style
                                              reuseIdentifier:CellID];
    }
    cell.hasTimeLabel = YES;
    //NSDate *date=[NSDate date];
    //cell.timeLabel.text = [app updateDisplayTime:date];
    cell.bubbleView.text = [self textForRowAtIndexPath:indexPath];
    cell.backgroundColor = tableView.backgroundColor;

    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
        height = [BubbleView cellHeightForText:[self textForRowAtIndexPath:indexPath]] + 30;
    return height;
}

#pragma mark - Messages view controller
- (BubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0; // Override in subclass
}

-(NSDictionary *)messageDetailForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil; // Override in subclass
}

- (void)finishSend {
    [self.inputView.textView setText:nil];
    [self textViewDidChange:self.inputView.textView];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollview {
    if (![scrollview isEqual:scrollView]) {
        [self.inputView.textView resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.inputView.frame=CGRectMake(0,rect.size.height-40, 320, 40);
            scrollView.frame=CGRectMake(0, rect.size.height-40, 320, 40);
            [pageControl setHidden:YES];
            
        } completion:^(BOOL finished){
            [scrollView setHidden:YES];
        }];

    }
}

-(void)newface:(NSNotification *)notification {
    self.inputView.textView.text=notification.object;
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat maxHeight = [MessageInputView maxHeight];
    CGFloat textViewContentHeight = textView.contentSize.height;
    CGFloat  changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;

    changeInHeight = (textViewContentHeight + changeInHeight >= maxHeight) ? 0.0f : changeInHeight;

    if(changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, self.tableView.contentInset.bottom + changeInHeight, 0.0f);
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                            
                             [self scrollToBottomAnimated:NO];
                            
                             CGRect inputViewFrame = self.inputView.frame;
                             self.inputView.frame = CGRectMake(0.0f,
                                                               inputViewFrame.origin.y - changeInHeight,
                                                               inputViewFrame.size.width,
                                                               inputViewFrame.size.height + changeInHeight);
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    self.inputView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification {
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification {
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputView.frame;
                         self.inputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                           keyboardY - inputViewFrame.size.height,
                                                           inputViewFrame.size.width,
                                                           inputViewFrame.size.height);
                                                
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - self.inputView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectedFacial" object:nil];
}


@end