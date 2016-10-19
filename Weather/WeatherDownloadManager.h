//
//  WeatherDownloadManager.h
//  Weather
//
//  Created by Alberto on 17/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WeatherDownloadManagerDelegate;
@class City;

@interface WeatherDownloadManager : NSObject
@property (weak, nonatomic) id<WeatherDownloadManagerDelegate> delegate;
- (void)searchCitiesWithName:(NSString *)name;
- (void)searchWeatherObservationsIn:(City *)city;
@end








