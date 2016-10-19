//
//  WeatherDataManagerDelegate.h
//  Weather
//
//  Created by Alberto on 18/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherDataManagerDelegate
@optional
- (void)didReceiveCities:(NSArray *)cities;
- (void)fetchCitiesFailedWithError:(NSError *)error;
- (void)didReceiveWeatherObservations:(NSArray *)weatherObservations;
- (void)fetchWeatherObservationsFailedWithError:(NSError *)error;
@end

