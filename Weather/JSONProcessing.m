//
//  JSONProcessing.m
//  Weather
//
//  Created by Alberto on 18/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import "JSONProcessing.h"
#import "City.h"
#import "WeatherObservation.h"

@implementation JSONProcessing

+ (NSArray *)citiesFromJSON:(NSData *)objectNotation error:(NSError **)error {
    
    // NSData -> JSON Object.
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    // Create array with cities from JSON.
    NSMutableArray *cities = [[NSMutableArray alloc] init];
    
    NSArray *geonames = [parsedObject valueForKey:@"geonames"];
    NSLog(@"Count geonames %lu", (unsigned long)geonames.count);
    
    for (NSDictionary *cityDictionary in geonames) {
        
        // Get data from JSON
        NSString *cityName = [cityDictionary valueForKey:@"asciiName"];
        NSString *cityCountry = [cityDictionary valueForKey:@"countryName"];
        NSDictionary *bbox = [cityDictionary valueForKey:@"bbox"];
        double east = [[bbox valueForKey:@"east"] doubleValue];
        double south = [[bbox valueForKey:@"south"] doubleValue];
        double north = [[bbox valueForKey:@"north"] doubleValue];
        double west = [[bbox valueForKey:@"west"] doubleValue];
        
        if (cityName != nil && cityCountry != nil && bbox != nil) {
            
            City *city = [[City alloc] init];
            city.name = cityName;
            city.countryName = cityCountry;
            city.east = east;
            city.south = south;
            city.north = north;
            city.west = west;
            [cities addObject:city];
        }
    }
    
    return cities;
}

+ (NSArray *)weatherObservationsFromJSON:(NSData *)objectNotation error:(NSError **)error {
    
    // NSData -> JSON Object.
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    // Create array with weatherObservations from JSON.
    NSMutableArray *observations = [[NSMutableArray alloc] init];
    
    NSArray *weatherObservations = [parsedObject valueForKey:@"weatherObservations"];
    NSLog(@"Count Weather Observations %lu", (unsigned long)weatherObservations.count);
    
    for (NSDictionary *observationDictionary in weatherObservations) {
        
        // Get data from JSON
        NSString *stationName = [observationDictionary valueForKey:@"stationName"];
        NSString *temperature = [observationDictionary valueForKey:@"temperature"];
        NSString *clouds = [observationDictionary valueForKey:@"clouds"];
        int humidity = [[observationDictionary valueForKey:@"humidity"] intValue];
        double latitude = [[observationDictionary valueForKey:@"lat"] doubleValue];
        double longitude = [[observationDictionary valueForKey:@"lng"] doubleValue];
        
        if (stationName != nil && temperature != nil && clouds != nil && humidity != 0 && latitude != 0 && longitude != 0) {
            
            WeatherObservation *weatherObservation = [[WeatherObservation alloc] init];
            weatherObservation.stationName = stationName;
            weatherObservation.temperature = temperature;
            weatherObservation.clouds = clouds;
            weatherObservation.humidity = humidity;
            weatherObservation.longitude = longitude;
            weatherObservation.latitude = latitude;
            [observations addObject:weatherObservation];
        }
    }
    
    return observations;
}

@end




