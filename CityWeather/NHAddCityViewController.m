//
//  NHAddCityViewController.m
//  CityWeather
//
//  Created by Rich Jahn on 12/17/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "NHAddCityViewController.h"
#import "NHCityViewController.h"
#import "NHCity.h"
#import "NHCityManager.h"

NSString * const kSearchTextKey = @"Search Text"; /*< NSDictionary key for entered search text. Used by NSTimer userInfo.*/

@interface NHAddCityViewController () {
    NSMutableArray * _geocodingResults;
    NSMutableArray * _cityDescriptions;
    CLGeocoder * _geocoder;
    NSTimer * _searchTimer;
}

@end

@implementation NHAddCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    _geocodingResults = [NSMutableArray array];
    _cityDescriptions = [NSMutableArray array];
    _geocoder = [[CLGeocoder alloc] init];
    
    
	// Do any additional setup after loading the view.
}

- (IBAction) cancelButtonPushed:(id)sender {
    [self goBackToCityView];
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
    [_cityDescriptions removeAllObjects];
    for (CLPlacemark *placemark in placemarks) {
        NSString *cityDescription = [self cityDescriptionFromPlacemark:placemark];
        if (cityDescription != nil) {
            [_geocodingResults addObject:placemark];
            [_cityDescriptions addObject:cityDescription];
        }
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _geocodingResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *cityDescription = _cityDescriptions[indexPath.row];
    
    cell.textLabel.text = cityDescription;

    return cell;
}

- (NSString *)cityDescriptionFromPlacemark:(CLPlacemark *)placemark {
    NSMutableString *description = [[NSMutableString alloc] init];
    NSString *city = placemark.addressDictionary[@"City"];
    if (city != nil) {
        [description appendString:city];
        NSString *countryCode = placemark.addressDictionary[@"CountryCode"];
        if ([countryCode isEqualToString:@"US"]) {
            NSString *state = placemark.addressDictionary[@"State"];
            if (state != nil) {
                [description appendFormat:@", %@", state];
            }
        } else {
            NSString *country = placemark.addressDictionary[@"Country"];
            if (country != nil) {
                [description appendFormat:@", %@", country];
            }
        }
        return [NSString stringWithString:description];
    } else {
        return nil;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLPlacemark *placemark = _geocodingResults[indexPath.row];
    NSString *cityDescription = _cityDescriptions[indexPath.row];    
    [self addCityWithDescription:cityDescription atLocation:placemark.location];
    [self goBackToCityView];
}

- (void)goBackToCityView {
    [self.view endEditing:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCityWithDescription:(NSString *)description atLocation:(CLLocation *)location {
    if (description != nil) {
        NSManagedObjectContext *context = [NHCityManager sharedManager].mainContext;
        NHCity *city = (id)[NSEntityDescription insertNewObjectForEntityForName:@"NHCity" inManagedObjectContext:context];
        city.name = description;
        [context save:nil];
    }
}
@end
