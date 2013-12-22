//
//  NHCityCell.h
//  CityWeather
//
//  Created by Rich Jahn on 12/17/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHCityCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *CityName;

@property (weak, nonatomic) IBOutlet UILabel *currentTemperature;

@property (retain, nonatomic) IBOutlet UIImageView *weatherIcon;

@property (weak, nonatomic) IBOutlet UILabel *currentCondition;

@end
