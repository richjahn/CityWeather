//
//  NHCity.h
//  CityWeather
//
//  Created by Rich Jahn on 12/12/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NHCity : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@property (nonatomic, retain) NSNumber *currentTemperature;
@property (nonatomic, retain) NSString *weatherIconFile;
@property (nonatomic, retain) NSString *currentSummary;

@end
