//
//  BaseViewController.h
//
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

#define BaseColor [UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1]

@interface BaseViewController : UIViewController

//左边button
- (void)setupLeftNavBarWithTitle:(NSString *)title;
- (void)setupLeftNavBarWithimage:(NSString *)imageName;
- (void)leftAction;

//右边button
- (void)setupRightNavBarWithTitle:(NSString *)title;
- (void)setupRightNavBarWithimage:(NSString *)imageName;
- (void)rightAction;

//MD5加密
- (NSString *)md5StringForString:(NSString *)string;

//动态计算行高
- (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;


@end
