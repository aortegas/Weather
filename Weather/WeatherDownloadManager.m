//
//  WeatherDownloadManager.m
//  Weather
//
//  Created by Alberto on 17/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import "WeatherDownloadManager.h"
#import "WeatherDownloadManagerDelegate.h"
#import "Location.h"
#import "Constants.h"
#import "City.h"

@implementation WeatherDownloadManager

- (void)searchCitiesWithName:(NSString *)name {

    // Create URL and GET Method to API
    NSString *urlAsString = [NSString stringWithFormat:@"http://api.geonames.org/searchJSON?q=%@&maxRows=20&startRow=0&lang=%@&isNameRequired=true&style=FULL&username=%@", name, defaultLanguage, user];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlAsString]];
    [request setHTTPMethod:@"GET"];
    
    // GET Method
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self.delegate fetchCitiesFailedWithError:error];
                NSLog(@"Error GET Cities: %@", error.localizedDescription);
            }
            else {
                [self.delegate receivedCitiesJSON:data];
                NSLog(@"GET Cities OK");
            }
        });
        
    }] resume];
}

- (void)searchWeatherObservationsIn:(City *)city {

    // Create URL and GET Method to API

    NSString *urlAsString = [NSString stringWithFormat:@"http://api.geonames.org/weatherJSON?north=%f&south=%f&east=%f&west=%f&username=%@",
                             city.north, city.south, city.east, city.west, user];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlAsString]];
    [request setHTTPMethod:@"GET"];
    
    // GET Method
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                
                [self.delegate fetchWeatherObservationsFailedWithError:error];
                NSLog(@"Error GET Weather Observations: %@", error.localizedDescription);
            }
            else {
                
                [self.delegate receivedWeatherObservationsJSON:data];
                NSLog(@"GET Weather Observations OK");
            }
        });
        
    }] resume];
}

@end
