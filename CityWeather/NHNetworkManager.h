//
//  NHNetworkManager.h
//  CityWeather
//
//  Created by Rich Jahn on 12/22/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHCity.h"

@interface NHNetworkManager : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

+ (instancetype) sharedManager;

@end
