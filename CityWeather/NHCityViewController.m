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

@interface NHCityViewController ()
<UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@end

@implementation NHCityViewController
{
    NSFetchedResultsController *_fetchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[self.collectionView registerClass:[NHCityCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NHCity"];
    request.predicate = [NSPredicate predicateWithValue:YES];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    //NSArray *results = [[NHCityManager sharedManager].mainContext executeFetchRequest:request error:nil];
    
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                           managedObjectContext:[NHCityManager sharedManager].mainContext
                                                             sectionNameKeyPath:nil
                                                                      cacheName:@"allCities"];
    _fetchController.delegate = self;
    [_fetchController performFetch:nil];
}

//- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
//    return 1;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return 4;
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
    }
    
    return cell;
}

@end
