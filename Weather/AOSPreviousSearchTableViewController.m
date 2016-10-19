//
//  AOSPreviousSearchTableViewController.m
//  Weather
//
//  Created by Alberto on 19/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import "AOSPreviousSearchTableViewController.h"
#import "Location.h"
#import "Constants.h"
#import "PreviousSearches.h"
#import "City.h"

@interface AOSPreviousSearchTableViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *favoriteSearches;
@end

@implementation AOSPreviousSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Views.
    [self setupViews];
    
    // Load Data.
    [self loadFavoritesSearches];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoriteSearches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Prepare Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFavoritesSearches"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellFavoritesSearches"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Prepare Content Cell
    City *city = self.favoriteSearches[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", city.name, city.countryName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    City *city = self.favoriteSearches[indexPath.row];
    [self.delegate didSelectCity: city];
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - Methods
- (void)setupViews {
    
    // Customize Navigation Bar
    self.navigationBarView.tintColor = [UIColor whiteColor];
    self.navigationBarView.barTintColor = mainColor;
    self.navigationBarView.translucent = false;
    self.navigationBarView.titleTextAttributes =  @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:nil action: @selector(cancel)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle: previousSearchesText];
    item.leftBarButtonItem = leftButton;
    item.hidesBackButton = YES;
    [self.navigationBarView pushNavigationItem:item animated:NO];
}

- (void)cancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)loadFavoritesSearches {
    
    PreviousSearches *previousSearches = PreviousSearches.sharedPreviousSearches;
    self.favoriteSearches = [previousSearches getFavoritesSearches];
}

@end

