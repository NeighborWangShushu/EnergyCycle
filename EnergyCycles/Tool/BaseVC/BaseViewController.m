//
//  BaseViewController.m
//
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - 左边button-文字
- (void)setupLeftNavBarWithTitle:(NSString *)title {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(leftAction)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
#pragma mark - 左边button-图片
- (void)setupLeftNavBarWithimage:(NSString *)imageName {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    /**
     *  设置frame只能控制按钮的大小
     */
    btn.frame= CGRectMake(0, 0, 30, 30);
    
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                                                             style:UIBarButtonItemStyleBordered
//                                                                            target:self
//                                                                            action:@selector(leftAction)];
    
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
}
#pragma mark - 左边button-响应事件
- (void)leftAction {
    
}

#pragma mark - 右边button-文字
- (void)setupRightNavBarWithTitle:(NSString *)title {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(rightAction)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
#pragma mark - 右边button-图片
- (void)setupRightNavBarWithimage:(NSString *)imageName {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightAction)];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
}
#pragma mark - 右边button-响应事件
- (void)rightAction {
    
}

#pragma mark - MD5加密
- (NSString *)md5StringForString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    
    return [ret lowercaseString];
}

#pragma mark - 动态计算行高
//根据字符串的实际内容的多少,在固定的宽度和字体的大小,动态的计算出实际的高度
- (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size {
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    //返回计算出的行高
    return rect.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
