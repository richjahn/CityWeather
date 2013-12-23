//
//  NHForecastViewController.h
//  CityWeather
//
//  Created by Rich Jahn on 12/22/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHCity.h"

@interface NHForecastViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NHCity *city;

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UILabel *apparentTemperature;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *dewPoint;
@property (weak, nonatomic) IBOutlet UILabel *visibility;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
