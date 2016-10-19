//
//  AOSSearchCityVC.m
//  Weather
//
//  Created by Alberto on 17/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import "AOSSearchCityVC.h"
#import "Constants.h"
#import "Location.h"
#import "WeatherDataManager.h"
#import "WeatherDownloadManager.h"
#import "City.h"
#import "AOSDetailCityVC.h"
#import "AOSPreviousSearchTableViewController.h"

@interface AOSSearchCityVC () <WeatherDataManagerDelegate, UISearchBarDelegate, DidSelectFavoriteSearchDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) WeatherDataManager *weatherDataManager;
@property (strong, nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) AOSPreviousSearchTableViewController *previousSearchTableViewController;
@end

@implementation AOSSearchCityVC

#pragma mark - View Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Views.
    [self setupViews];
    
    // Initialize.
    self.cities = [[NSMutableArray alloc] init];
    self.searchBarView.delegate = self;
    self.weatherDataManager = [[WeatherDataManager alloc] init];
    self.weatherDataManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Prepare Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellCities"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellCities"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Prepare Content Cell
    City *city = self.cities[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", city.name, city.countryName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self presentDetailWithCity: self.cities[indexPath.row]];
}


#pragma mark - WeatherDataManagerDelegate
- (void)didReceiveCities:(NSArray *)cities {
    
    [self.activityView stopAnimating];
    [self.cities addObjectsFromArray:cities];
    [self.tableView reloadData];
}

- (void)fetchCitiesFailedWithError:(NSError *)error {
    
    [self.activityView stopAnimating];
    
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription]
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];

    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (self.cities.count != 0) {
        [self removeAndReload];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    self.searchBarView.showsCancelButton = true;
    return true;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {

    self.searchBarView.showsCancelButton = false;
    return true;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.searchBarView.showsCancelButton = false;
    [self.searchBarView resignFirstResponder];
    self.searchBarView.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBarView endEditing:true];
    [self removeAndReload];
    [self.activityView startAnimating];
    [self.weatherDataManager fetchCitiesWithName:self.searchBarView.text];
}

- (void)removeAndReload {

    [self.cities removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark - DidSelectFavoriteSearchDelegate
- (void)didSelectCity:(City *)city {
    
    [self presentDetailWithCity: city];
}


#pragma mark - Methods
- (void)setupViews {
    
    // Customize Navigation Bar
    self.navigationController.navigationBarHidden = false;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.navigationController.navigationBar.translucent = false;
    self.navigationController.navigationBar.titleTextAttributes =  @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                                           target:self action:@selector(previousSearches)];
    
    // Title.
    self.title = weatherText;
    
    // Customize Status Bar
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        [statusBar setBackgroundColor: mainColor];
    }
    
    // Customize Search Bar
    [self.searchBarView setBarTintColor: mainColor];
    self.searchBarView.placeholder = mainSearchPlaceHolder;
    self.searchBarView.tintColor = [UIColor whiteColor];
    self.searchBarView.layer.borderWidth = 1;
    self.searchBarView.layer.borderColor = [mainColor CGColor];
}

- (void)previousSearches {
    
    self.previousSearchTableViewController = [[AOSPreviousSearchTableViewController alloc] init];
    self.previousSearchTableViewController.delegate = self;
    [self presentViewController: self.previousSearchTableViewController animated:YES completion:nil];
}

- (void)presentDetailWithCity:(City *)city {
    
    AOSDetailCityVC *detailCity = [[AOSDetailCityVC alloc] initWithCity: city];
    [self.navigationController pushViewController:detailCity animated:YES];
}

@end


