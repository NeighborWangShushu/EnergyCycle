//
//
//
//

//管理可选择额城市信息

#import <Foundation/Foundation.h>

@interface CityDataManager : NSObject

///
+ (NSArray *)getProvinceData;
+ (NSArray *)getCityDataWithProvince:(NSDictionary *)province;
+ (NSArray *)getCountiesWithCity:(NSDictionary *)city;

+ (NSDictionary *)provinceInfo:(NSString *)provinceName;
+ (NSDictionary *)cityInfo:(NSString *)cityName;
+ (NSDictionary *)countyInfo:(NSString *)countyName;


@end
