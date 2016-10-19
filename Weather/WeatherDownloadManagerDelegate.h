//
//  WeatherDownloadManagerDelegate.h
//  Weather
//
//  Created by Alberto on 17/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherDownloadManagerDelegate
- (void)receivedCitiesJSON:(NSData *)objectNotation;
- (void)fetchCitiesFailedWithError:(NSError *)error;
- (void)receivedWeatherObservationsJSON:(NSData *)objectNotation;
- (void)fetchWeatherObservationsFailedWithError:(NSError *)error;
@end
