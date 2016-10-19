//
//  WeatherDataManager.h
//  Weather
//
//  Created by Alberto on 18/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherDataManagerDelegate.h"
#import "WeatherDownloadManagerDelegate.h"
@class WeatherDownloadManager;
@class City;

@interface WeatherDataManager : NSObject<WeatherDownloadManagerDelegate>

@property (strong, nonatomic) WeatherDownloadManager  *weatherDownloadManager;
@property (weak, nonatomic) id<WeatherDataManagerDelegate> delegate;

- (void)fetchCitiesWithName:(NSString *)name;
- (void)fetchWeatherObservationIn:(City *)city;

@end


