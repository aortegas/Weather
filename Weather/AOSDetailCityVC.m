//
//  AOSDetailCityVC.m
//  Weather
//
//  Created by Alberto on 18/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import "AOSDetailCityVC.h"
#import "City.h"
#import "WeatherObservation.h"
#import "Constants.h"
#import "Location.h"
#import "WeatherDataManager.h"
#import "AOSObservationAnnotationMap.h"
#import "PreviousSearches.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AOSDetailCityVC () <WeatherDataManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet MKMapView *pointsMap;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *coulds;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) City *city;
@property (strong, nonatomic) WeatherDataManager *weatherDataManager;
@property (strong, nonatomic) NSMutableArray *weatherObservations;
@property (nonatomic) float finalProgress;
@end

@implementation AOSDetailCityVC

#pragma mark - Init
- (id)initWithCity:(City *)city {

    self = [super init];
    if(self) {
        self.city = city;
    }
    return self;
}

#pragma mark - View Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Views.
    [self setupViews];
    
    // Initialize.
    self.weatherObservations = [[NSMutableArray alloc] init];
    self.weatherDataManager = [[WeatherDataManager alloc] init];
    self.weatherDataManager.delegate = self;
    self.pointsMap.delegate = self;
    
    // Get Weather Observations.
    [self.activityView startAnimating];
    [self.weatherDataManager fetchWeatherObservationIn: self.city];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - WeatherDataManagerDelegate
- (void)didReceiveWeatherObservations:(NSArray *)weatherObservations {

    [self.activityView stopAnimating];
    [self.weatherObservations addObjectsFromArray:weatherObservations];
    
    // Show Weather Data.
    [self showWeatherData];
}

- (void)fetchWeatherObservationsFailedWithError:(NSError *)error {

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


#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[AOSObservationAnnotationMap class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView =
            (MKPinAnnotationView*)[self.pointsMap dequeueReusableAnnotationViewWithIdentifier:@"AOSObservationAnnotationMap"];
        
        if (!pinView) {
            
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AOSObservationAnnotationMap"];
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
        }
        else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}


#pragma mark - Methods
- (void)setupViews {
    
    // Title.
    self.title = [NSString stringWithFormat:@"%@ (%@)", self.city.name, self.city.countryName];
    
    // MapView.
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = self.city.north;
    topLeftCoord.longitude = self.city.east;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = self.city.south;
    bottomRightCoord.longitude = self.city.west;

    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [self.pointsMap regionThatFits:region];
    [self.pointsMap setRegion:region animated:YES];
}

- (void)showWeatherObservationsOnMap {

    for(WeatherObservation* weatherObservation in self.weatherObservations) {
     
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(weatherObservation.latitude, weatherObservation.longitude);
        AOSObservationAnnotationMap *annotation = [[AOSObservationAnnotationMap alloc] initWithTitle: weatherObservation.stationName
                                                                                          coordinate: coordinate];
        [self.pointsMap addAnnotation:annotation];
    }
}

- (void)showWeatherData {
    
    if (self.weatherObservations.count > 0) {
        WeatherObservation *weatherObservation = self.weatherObservations[0];
        self.temperature.text = [NSString stringWithFormat:@"%@°", weatherObservation.temperature];
        self.coulds.text = [weatherObservation.clouds capitalizedString];
        self.humidityLabel.text = [NSString stringWithFormat:@"%d%% %@", weatherObservation.humidity, humidityText];
        
        // Show Weather Observations in View Map.
        [self showWeatherObservationsOnMap];
        
        // Show Temperature.
        [self showTemperature:[weatherObservation.temperature floatValue]];
    }
    else {
        self.temperature.text = @"";
        self.humidityLabel.text = @"";
        self.progressView.hidden = true;
        self.coulds.text = noWeatherPoints;
    }
    
    // Save search in favorites searches.
    PreviousSearches *previousSearches = PreviousSearches.sharedPreviousSearches;
    [previousSearches addFavoriteSearch:self.city];
}

- (void)showTemperature:(float)temperature {
    
    self.progressView.progress = 0.0f;
    
    if (temperature < -50) {
        return;
    }
    
    if (temperature > 50) {
        self.progressView.progress = 1.0f;
        self.progressView.tintColor = [UIColor redColor];
        return;
    }
    
    // Calculate progress and begin animation.
    self.finalProgress = (0.5 + (temperature / 100));
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.1];
}

- (void)increaseProgress {
    
    self.progressView.progress += 0.05f;
    
    // Set color of temperature.
    if (self.progressView.progress < 0.5f) {
        self.progressView.tintColor = [UIColor blueColor];
    }
    if (self.progressView.progress >= 0.5f && self.progressView.progress < 0.65f) {
        self.progressView.tintColor = [UIColor greenColor];
    }
    if (self.progressView.progress >= 0.65f && self.progressView.progress < 0.75f) {
        self.progressView.tintColor = [UIColor yellowColor];
    }
    if (self.progressView.progress >= 0.75f && self.progressView.progress < 0.85f) {
        self.progressView.tintColor = [UIColor orangeColor];
    }
    if (self.progressView.progress >= 0.85f) {
        self.progressView.tintColor = [UIColor redColor];
    }
    
    if (self.progressView.progress < self.finalProgress) {
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.1];
    }
}

@end
