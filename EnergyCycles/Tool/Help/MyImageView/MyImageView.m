//
//  MyImageView.m
//
//
//

#import "MyImageView.h"
@interface MyImageView ()
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;
@end

@implementation MyImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //打开用户交互
        self.userInteractionEnabled = YES;
    }
    return self;
}
//触摸屏幕调用
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.target respondsToSelector:self.action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [self.target performSelector:self.action withObject:self];
        
#pragma clang diagnostic pop
    }
}

- (void)addTarget:(id)target action:(SEL)action{
    self.target = target;
    self.action = action;
}


@end
