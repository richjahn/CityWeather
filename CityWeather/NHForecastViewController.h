//
//  NHForecastViewController.h
//  CityWeather
//
//  Created by Rich Jahn on 12/22/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHForecastViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
