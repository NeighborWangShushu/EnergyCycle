//
//  BaseTableViewController.h
//
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@interface BaseTableViewController : UITableViewController

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
