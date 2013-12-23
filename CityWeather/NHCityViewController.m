//
//  NHViewController.m
//  CityWeather
//
//  Created by Rich Jahn on 12/12/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import "NHCityViewController.h"
#import "NHCityCell.h"
#import "NHCityManager.h"
#import "NHCity.h"
#import "NHForecastViewController.h"

@interface NHCityViewController ()
<UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@end

@implementation NHCityViewController {
    NSFetchedResultsController *_fetchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[self.collectionView registerClass:[NHCityCell class] forCellWithReuseIdentifier:@"Cell"];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NHCity"];
    request.predicate = [NSPredicate predicateWithValue:YES];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    //NSArray *results = [[NHCityManager sharedManager].mainContext executeFetchRequest:request error:nil];
    
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                           managedObjectContext:[NHCityManager sharedManager].mainContext
                                                             sectionNameKeyPath:nil
                                                                      cacheName:@"allCities"];
    //s_fetchController.delegate = self;
    [_fetchController performFetch:nil];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self updateCurrentWeatherAllCities];
//    });
    
//    dispatch_queue_t weatherDataQueue = dispatch_queue_create("weatherDataQueue", NULL);
//    dispatch_async(weatherDataQueue, ^{
//        [self updateCurrentWeatherAllCities];
//    });
    
    [self performSelectorInBackground:@selector(updateCurrentWeatherAllCities) withObject:self];
    
    [self.collectionView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar setNeedsDisplay];
}

- (void) updateCurrentWeatherAllCities {
    NSArray *fetchedObjects = [_fetchController fetchedObjects];
    NSDate *currentTime = [NSDate date];
    NHCityManager *cityManager = [NHCityManager sharedManager];
    NSManagedObjectContext *context = cityManager.mainContext;
    
    for (NHCity *city in fetchedObjects) {
        [cityManager updateCurrentWeatherForCity:city forDate:currentTime];
        [context save:nil];
    }
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_fetchController.sections[section] numberOfObjects] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isAddCityCell = indexPath.row >= [_fetchController.sections[indexPath.section] numberOfObjects];
    NSString *identifier = isAddCityCell == YES ? @"AddCityCell" : @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (isAddCityCell == NO) {
        NHCityCell *cityCell = (NHCityCell *)cell;
        NHCity *city = [_fetchController objectAtIndexPath:indexPath];
        
        cityCell.CityName.text = city.name;

        if (city.weatherIconFile != nil) {
            UIImage *weatherIconImage = [UIImage imageNamed:city.weatherIconFile];
            cityCell.weatherIcon.image = weatherIconImage;
        }

        if (city.currentTemperature != nil) {
            cityCell.currentTemperature.text = [NSString stringWithFormat:@"%.0f\u00B0", [city.currentTemperature floatValue]];
        } else {
            cityCell.currentTemperature.text = nil;
        }
        
        cityCell.currentCondition.text = city.currentSummary;
    }
    
    return cell;
}


#pragma mark - Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowForecast"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NHForecastViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        NHCity *city = [_fetchController objectAtIndexPath:indexPath];
        destViewController.city = city;
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

@end
