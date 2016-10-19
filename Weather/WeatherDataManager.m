//
//  WeatherDataManager.m
//  Weather
//
//  Created by Alberto on 18/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import "WeatherDataManager.h"
#import "JSONProcessing.h"
#import "WeatherDownloadManager.h"

@implementation WeatherDataManager

// MARK: - Initialization
-(id)init {
    if (self = [super init] ) {
        self.weatherDownloadManager = [[WeatherDownloadManager alloc] init];
        self.weatherDownloadManager.delegate = self;
    }
    return self;
}

- (void)fetchCitiesWithName:(NSString *)name {
    [self.weatherDownloadManager searchCitiesWithName:name];
}

- (void)fetchWeatherObservationIn:(City *)city {
    [self.weatherDownloadManager searchWeatherObservationsIn: city];
}


#pragma mark - WeatherDownloadManagerDelegate
- (void)receivedCitiesJSON:(NSData *)objectNotation {
    
    NSError *error = nil;
    NSArray *cities = [JSONProcessing citiesFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchCitiesFailedWithError:error];
    } else {
        [self.delegate didReceiveCities:cities];
    }
}

- (void)fetchCitiesFailedWithError:(NSError *)error {
    [self.delegate fetchCitiesFailedWithError:error];
}

- (void)receivedWeatherObservationsJSON:(NSData *)objectNotation {

    NSError *error = nil;
    NSArray *weatherObservations = [JSONProcessing weatherObservationsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchWeatherObservationsFailedWithError:error];
    } else {
        [self.delegate didReceiveWeatherObservations:weatherObservations];
    }
}

- (void)fetchWeatherObservationsFailedWithError:(NSError *)error {
    [self.delegate fetchWeatherObservationsFailedWithError:error];
}

@end



