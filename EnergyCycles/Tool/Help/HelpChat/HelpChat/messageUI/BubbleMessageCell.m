

#import "BubbleMessageCell.h"

@interface BubbleMessageCell()

- (void)setup;

@end



@implementation BubbleMessageCell
@synthesize timeLabel;
@synthesize hasTimeLabel;

#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
    self.bubbleView = [[BubbleView alloc] initWithFrame:CGRectMake(0.0f,
                                                                   0.0f,
                                                                   self.contentView.frame.size.width,
                                                                   self.contentView.frame.size.height)];
    
    self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.bubbleView];
    [self.contentView sendSubviewToBack:self.bubbleView];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    timeLabel.text = @"星期六 8:16";
    timeLabel.hidden = YES;
    [self.contentView addSubview:self.timeLabel];
}

- (id)initWithBubbleStyle:(BubbleMessageStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
        [self.bubbleView setStyle:style];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(self.hasTimeLabel){
        self.timeLabel.hidden = NO;
        self.bubbleView.frame = CGRectMake(0.0f,
                                           20.0f,
                                           self.contentView.frame.size.width,
                                           self.contentView.frame.size.height - 20);
    }else{
        self.timeLabel.hidden = YES;
        self.bubbleView.frame = CGRectMake(0.0f,
                                           0.0f,
                                           self.contentView.frame.size.width,
                                           self.contentView.frame.size.height);
    }
}

#pragma mark - Setters
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self.bubbleView setBackgroundColor:backgroundColor];
}

@end