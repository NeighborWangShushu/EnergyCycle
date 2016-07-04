//
//  MyImageView.h
//
//

#import <UIKit/UIKit.h>

@interface MyImageView : UIImageView
//记录图片的索引
@property (nonatomic)NSInteger index;
//增加点击事件
- (void)addTarget:(id)target action:(SEL)action;

@end
