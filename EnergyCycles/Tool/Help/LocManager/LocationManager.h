//
//
//

#import <UIKit/UIKit.h>

@interface LocationManager: NSObject

//block回调,返回地理位置
@property (nonatomic, copy) void(^backLoactionBlcok)(NSString *location);

//单例
+ (LocationManager *)locationManager;

//开始定位
- (void)startLocation;


@end
