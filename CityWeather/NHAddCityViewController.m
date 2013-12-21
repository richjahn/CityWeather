//
//  NHAddCityViewController.m
//  CityWeather
//
//  Created by Rich Jahn on 12/17/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "NHAddCityViewController.h"
#import "NHCity.h"
#import "NHCityManager.h"

NSString * const kSearchTextKey = @"Search Text"; /*< NSDictionary key for entered search text. Used by NSTimer userInfo.*/

@interface NHAddCityViewController () {
    NSMutableArray * _geocodingResults;
    CLGeocoder * _geocoder;
    NSTimer * _searchTimer;
}

@end

@implementation NHAddCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    _geocodingResults = [NSMutableArray array];
    _geocoder = [[CLGeocoder alloc] init];
    
    
	// Do any additional setup after loading the view.
}

- (IBAction) cancelButtonPushed:(id)sender {
    [self.view endEditing:YES];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    // Use a timer to only start geocoding when the user stops typing
    if ([_searchTimer isValid])
        [_searchTimer invalidate];
    
    const NSTimeInterval kSearchDelay = .25;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:searchString forKey:kSearchTextKey];
    
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:kSearchDelay
                                                    target:self
                                                  selector:@selector(geocodeFromTimer:)
                                                  userInfo:userInfo
                                                   repeats:NO];
    
    return NO;
}

- (void) geocodeFromTimer:(NSTimer *)timer {
    
    NSString * searchString = [timer.userInfo objectForKey:kSearchTextKey];
    
    // Cancel any active geocoding. Note: Cancelling calls the completion handler on the geocoder
    if (_geocoder.isGeocoding) {
        [_geocoder cancelGeocode];
    }
    
    [_geocoder geocodeAddressString:searchString
                  completionHandler:^(NSArray *placemarks, NSError *error) {
                      if (!error) {
                          [self processForwardGeocodingResults:placemarks];
                      }
                  }];
}

- (void) processForwardGeocodingResults:(NSArray *)placemarks {
    [_geocodingResults removeAllObjects];
    [_geocodingResults addObjectsFromArray:placemarks];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _geocodingResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CLPlacemark *placemark = _geocodingResults[indexPath.row];
    
    cell.textLabel.text = [placemark locality];
                           
    return cell;
}

//- (IBAction)addCity:(id)sender {
//    NSManagedObjectContext *context = [NHCityManager sharedManager].mainContext;
//    NHCity *city = (id)[NSEntityDescription insertNewObjectForEntityForName:@"NHCity" inManagedObjectContext:context];
//    city.name = _cityName.text;
//    [context save:nil];
//}
@end
