//
//  NHForecastViewController.m
//  CityWeather
//
//  Created by Rich Jahn on 12/22/13.
//  Copyright (c) 2013 Rich Jahn. All rights reserved.
//

#import "NHForecastViewController.h"
#import "NHCityManager.h"

@interface NHForecastViewController ()

@end

@implementation NHForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // get rid of initial blank space above first cell in table view
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self performSelectorInBackground:@selector(updateCurrentWeatherForCity) withObject:self];
}

- (void) updateCurrentWeatherForCity {
    NSDate *currentTime = [NSDate date];
    NHCityManager *cityManager = [NHCityManager sharedManager];
    [cityManager updateCurrentWeatherAllDetailsForCity:self.city forDate:currentTime];
    NSManagedObjectContext *context = cityManager.mainContext;
    [context save:nil];
    [self updateViewWithCurrentWeather];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void) updateViewWithCurrentWeather {
    self.cityName.text = self.city.name;
    self.summary.text = self.city.currentSummary;
    self.apparentTemperature.text = [NSString stringWithFormat:@"Feels like %.0f\u00B0F", [self.city.apparentTemperature floatValue]];
    self.windSpeed.text = [NSString stringWithFormat:@"Wind: %.0f mph", [self.city.windSpeed floatValue]];
    self.humidity.text = [NSString stringWithFormat:@"Humidity: %.0f%%", [self.city.humidity floatValue] * 100.0];
    self.dewPoint.text = [NSString stringWithFormat:@"Dew Pt: %.0f", [self.city.dewPoint floatValue]];
    self.visibility.text = [NSString stringWithFormat:@"Visibility: %.0f mi", [self.city.visibility floatValue]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ForecastDayCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
