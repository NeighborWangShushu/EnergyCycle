//
//
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;


@end

@implementation LocationManager

- (instancetype)init {
    if (self = [super init]) {
        [self startLocation];
    }
    
    return self;
}

+ (LocationManager *)locationManager {
    static LocationManager *manager = nil;
    @synchronized(self) {
        if (manager == nil) {
            manager = [[LocationManager alloc] init];
        }
    }
    return manager;
}

#pragma mark - 开始定位
- (void)startLocation {
    [self.locationManager startUpdatingLocation];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    NSLog(@"纬度:%f,经度:%f",manager.location.coordinate.latitude,manager.location.coordinate.longitude);
    
    float x = manager.location.coordinate.latitude;
    float y = manager.location.coordinate.longitude;
    
    if (x == 0 && y == 0) {
        [_locationManager startUpdatingLocation];
    }
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *mark in placemarks) {
            NSLog(@"name:%@,country:%@,locality:%@,administrativeArea:%@",mark.name,mark.country,mark.locality,mark.administrativeArea);
            if (_backLoactionBlcok) {
                _backLoactionBlcok(mark.administrativeArea);
            }
        }
    }];
}


@end
