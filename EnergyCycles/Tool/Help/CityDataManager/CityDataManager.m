//
//
//
//

#import "CityDataManager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

#define DataBasePath [[NSBundle mainBundle] pathForResource:@"city" ofType:@"db"]

@implementation CityDataManager

///
+ (NSArray *)getProvinceData {
    __block NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    FMDatabaseQueue *dataBase = [FMDatabaseQueue databaseQueueWithPath:DataBasePath];
    [dataBase inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *res = [db executeQuery:@"SELECT * FROM ecs_region where region_type=1"];
            while ([res next]) {
                ///
                [tempArray addObject:[res resultDictionary]];
            }
            [db close];
        }
    }];
    return tempArray;
}

+ (NSArray *)getCityDataWithProvince:(NSDictionary *)province {
    __block NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    FMDatabaseQueue *dataBase = [FMDatabaseQueue databaseQueueWithPath:DataBasePath];
    [dataBase inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM ecs_region where parent_id='%@'",[province objectForKey:@"region_id"]]];
            
            while ([res next]) {
                ///
                [tempArray addObject:[res resultDictionary]];
            }
            [db close];
        }
    }];
    return tempArray;
}


+ (NSArray *)getCountiesWithCity:(NSDictionary *)city {
    __block NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    FMDatabaseQueue *dataBase = [FMDatabaseQueue databaseQueueWithPath:DataBasePath];
    [dataBase inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM ecs_region where parent_id='%@'",[city objectForKey:@"region_id"]]];
            while ([res next]) {
                ///
                [tempArray addObject:[res resultDictionary]];
            }
            [db close];
        }
    }];
    return tempArray;
}

+ (NSDictionary *)provinceInfo:(NSString *)provinceName {
    __block NSDictionary *tempDic;
    provinceName = [provinceName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    FMDatabaseQueue *dataBase = [FMDatabaseQueue databaseQueueWithPath:DataBasePath];
    [dataBase inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM ecs_region where region_id='%@'",provinceName]];
            while ([res next]) {
                ///
                tempDic = [NSDictionary dictionaryWithDictionary:[res resultDictionary]];
            }
            [db close];
        }
    }];
    return tempDic;
}

+ (NSDictionary *)cityInfo:(NSString *)cityName {
    __block NSDictionary *tempDic;
    cityName = [cityName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    FMDatabaseQueue *dataBase = [FMDatabaseQueue databaseQueueWithPath:DataBasePath];
    [dataBase inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM ecs_region where region_id='%@'",cityName]];
            while ([res next]) {
                ///
                tempDic = [NSDictionary dictionaryWithDictionary:[res resultDictionary]];
            }
            [db close];
        }
    }];
    return tempDic;
}

+ (NSDictionary *)countyInfo:(NSString *)countyName {
    __block NSDictionary *tempDic;
    countyName = [countyName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    FMDatabaseQueue *dataBase = [FMDatabaseQueue databaseQueueWithPath:DataBasePath];
    [dataBase inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM ecs_region where region_id='%@'",countyName]];
            while ([res next]) {
                ///
                tempDic = [NSDictionary dictionaryWithDictionary:[res resultDictionary]];
            }
            [db close];
        }
    }];
    return tempDic;
}

@end
