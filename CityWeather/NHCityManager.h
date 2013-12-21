//
//  NHCityManager.h
//  CityWeather
//
//  Created by Rich Jahn on 12/12/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface NHCityManager : NSObject

+ (instancetype) sharedManager;

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

@end
