//
//  NHCityManager.m
//  CityWeather
//
//  Created by Rich Jahn on 12/12/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import "NHCityManager.h"

static NSString *baseURL = @"https://api.forecast.io/forecast";
static NSString *key = @"7129fcaa2d9ad67fd7ecacede9d6f8de";

@implementation NHCityManager {
    NSDictionary *_current;
}

+ (instancetype)sharedManager {
    static NHCityManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCoreData];
    }
    return self;
}

- (void)setUpCoreData {
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [docDirectory stringByAppendingPathComponent:@"city.sqlite"];
    NSURL *sqliteURL = [NSURL fileURLWithPath:sqlitePath];
    
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES,
                               NSInferMappingModelAutomaticallyOption : @YES };
    NSError *error;
    NSPersistentStore *sqliteStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                               configuration:nil
                                                                         URL:sqliteURL
                                                                     options:options
                                                                       error:&error];
    NSAssert(sqliteStore, @"Error:%@", error);
    
    _mainContext.persistentStoreCoordinator = coordinator;
}

- (void) updateCurrentWeatherForCity:(NHCity *)city forDate:(NSDate *)date {
    NSDictionary *current = [self getCurrentConditionsForCity:city andDate:date];
    [self updateBriefDetailsForCity:city fromDictionary:current];
}

- (void) updateCurrentWeatherAllDetailsForCity:(NHCity *)city forDate:(NSDate *)date {
    NSDictionary *current = [self getCurrentConditionsForCity:city andDate:date];
    [self updateBriefDetailsForCity:city fromDictionary:current];
    [self updateFullDetailsForCity:city fromDictionary:current];
}

- (NSDictionary *)getCurrentConditionsForCity:(NHCity *)city andDate:(NSDate *)date {
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@,%@,%ld",
                     baseURL,
                     key,
                     city.latitude,
                     city.longitude,
                     (long)[date timeIntervalSince1970]];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:0
                          error:&error];
    NSDictionary *current = json[@"currently"];
    
    return current;
}

- (void) updateBriefDetailsForCity:(NHCity *)city fromDictionary:(NSDictionary *)current {
    city.currentTemperature = current[@"temperature"];
    city.currentSummary = current[@"summary"];
    
    if (current[@"icon"] != [NSNull null]) {
        NSString *icon = current[@"icon"];
        if ([icon isEqualToString:@"clear-day"] ||
            [icon isEqualToString:@"clear-night"] ||
            [icon isEqualToString:@"rain"] ||
            [icon isEqualToString:@"snow"] ||
            [icon isEqualToString:@"sleet"] ||
            [icon isEqualToString:@"fog"] ||
            [icon isEqualToString:@"cloudy"] ||
            [icon isEqualToString:@"partly-cloudy-day"] ||
            [icon isEqualToString:@"partly-cloudy-night"]) {
            city.weatherIconFile = icon;
        } else {
            city.weatherIconFile = nil;
        }
    } else {
        city.weatherIconFile = nil;
    }
}

- (void) updateFullDetailsForCity:(NHCity *)city fromDictionary:(NSDictionary *)current {
    city.apparentTemperature = current[@"apparentTemperature"];
    city.windSpeed = current[@"windSpeed"];
    city.humidity = current[@"humidity"];
    city.dewPoint = current[@"dewPoint"];
    city.visibility = current[@"visibility"];
}

@end
