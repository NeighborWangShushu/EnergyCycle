//
//  MessageInputView.m
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

#import "MessageInputView.h"
#import "BubbleView.h"

@interface MessageInputView ()

- (void)setup;
- (void)setupTextView;
- (void)setupSendButton;
-(void)setupSendEmotionButton;
@end



@implementation MessageInputView

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setupSendEmotionButton {
    
}

- (void)setup
{
    self.image = [[UIImage imageNamed:@"input-bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)];
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    
    [self setupTextView];
    [self setSendEmotionButton];
    [self setupSendButton];
}

- (void)setupTextView
{
    //CGFloat width = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 246.0f : 690.0f;
    //CGFloat height = [MessageInputView textViewLineHeight] * [MessageInputView maxLines];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(50.0f, 3.0f, Screen_width-110, 50)];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(13.0f, 0.0f, 14.0f, 7.0f);
    self.textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 13.0f, 0.0f);
    self.textView.scrollEnabled = YES;
    self.textView.scrollsToTop = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.font = [BubbleView font];
    self.textView.textColor = [UIColor blackColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.returnKeyType = UIReturnKeyDefault;
    [self addSubview:self.textView];
	
    UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x - 1.0f,
                                                                                0.0f,
                                                                                self.textView.frame.size.width + 2.0f,
                                                                                self.frame.size.height)];
    inputFieldBack.image = [[UIImage imageNamed:@"input-field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 13.0f, 20.0f, 18.0f)];
    inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self addSubview:inputFieldBack];
}
//录音按键
-(void)setSendEmotionButton{
    self.sendEmotionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.sendEmotionButton.frame = CGRectMake(10.0f, 5.0f, 30.0f, 30.0f);
    self.sendEmotionButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
    //self.sendEmotionButton.backgroundColor = [UIColor redColor];
    [self.sendEmotionButton setBackgroundImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateNormal];
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
//    UIImage *sendBack = [[UIImage imageNamed:@"Send.png"] resizableImageWithCapInsets:insets];
//    UIImage *sendBackHighLighted = [[UIImage imageNamed:@"Send-click.png"] resizableImageWithCapInsets:insets];
//    UIImage *sendBack = [UIImage imageNamed:@"send"];
//    UIImage *sendBackHighLighted = [UIImage imageNamed:@"send-highlighted"];
//
//    [self.sendEmotionButton setBackgroundImage:sendBack forState:UIControlStateNormal];
//    [self.sendEmotionButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
//    [self.sendEmotionButton setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
//
//    NSString *title = @"表情";
//    [self.sendEmotionButton setTitle:title forState:UIControlStateNormal];
//    [self.sendEmotionButton setTitle:title forState:UIControlStateHighlighted];
//    [self.sendEmotionButton setTitle:title forState:UIControlStateDisabled];
//    self.sendEmotionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//
//    UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
//    [self.sendEmotionButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
//    [self.sendEmotionButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
//    self.sendEmotionButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
//    
//    [self.sendEmotionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.sendEmotionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [self.sendEmotionButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
    
    self.sendEmotionButton.enabled = YES;
    [self addSubview:self.sendEmotionButton];
}
//发送按键
- (void)setupSendButton {
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.frame = CGRectMake(self.frame.size.width - 60.0f, 8.0f, 51.0f, 25.0f);
    self.sendButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
//    UIImage *sendBack = [[UIImage imageNamed:@"send.png"] resizableImageWithCapInsets:insets];
//    UIImage *sendBackHighLighted = [[UIImage imageNamed:@"send-click.png"] resizableImageWithCapInsets:insets];
//    [self.sendButton setBackgroundImage:sendBack forState:UIControlStateNormal];
//    [self.sendButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
//    [self.sendButton setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
    
    [self.sendButton setBackgroundImage:[[UIImage imageNamed:@"Send.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //[self.sendButton setBackgroundImage:[UIImage imageNamed:@"send-click.png"] forState:UIControlStateHighlighted];
    
//    NSString *title = NSLocalizedString(@"Send", nil);
//    [self.sendButton setTitle:title forState:UIControlStateNormal];
//    [self.sendButton setTitle:title forState:UIControlStateHighlighted];
//    [self.sendButton setTitle:title forState:UIControlStateDisabled];
//    self.sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//    
//    UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
//    [self.sendButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
//    [self.sendButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
//    self.sendButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
//    
//    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [self.sendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
    
    self.sendButton.enabled = NO;
    [self addSubview:self.sendButton];
}

#pragma mark - Message input view
+ (CGFloat)textViewLineHeight
{
    return 35.0f; // for fontSize 15.0f
}

+ (CGFloat)maxLines
{
    return 4;
}

+ (CGFloat)maxHeight
{
    return ([MessageInputView maxLines] + 1.0f) * [MessageInputView textViewLineHeight];
}

@end