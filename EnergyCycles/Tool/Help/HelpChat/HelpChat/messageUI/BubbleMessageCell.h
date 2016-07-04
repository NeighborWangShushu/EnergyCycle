
#import <UIKit/UIKit.h>
#import "BubbleView.h"

@interface BubbleMessageCell : UITableViewCell

@property (strong, nonatomic) BubbleView *bubbleView;
@property (assign, nonatomic) BOOL       hasTimeLabel;
@property (strong, nonatomic) UILabel    *timeLabel;

- (id)initWithBubbleStyle:(BubbleMessageStyle)style
          reuseIdentifier:(NSString *)reuseIdentifier;
@end