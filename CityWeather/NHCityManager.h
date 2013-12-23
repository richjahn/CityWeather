//
//  NHCityManager.h
//  CityWeather
//
//  Created by Rich Jahn on 12/12/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
#import "NHCity.h"

@interface NHCityManager : NSObject

+ (instancetype) sharedManager;

- (void) updateCurrentWeatherForCity:(NHCity *)city forDate:(NSDate *)date;
- (void) updateCurrentWeatherAllDetailsForCity:(NHCity *)city forDate:(NSDate *)date;

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

@end
