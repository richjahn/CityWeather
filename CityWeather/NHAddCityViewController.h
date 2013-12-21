//
//  NHAddCityViewController.h
//  CityWeather
//
//  Created by Rich Jahn on 12/17/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHAddCityViewController : UIViewController
< UISearchDisplayDelegate,
  UITableViewDataSource,
  UITableViewDelegate >

- (IBAction) cancelButtonPushed:(id)sender;

@end
