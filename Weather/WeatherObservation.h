//
//  WeatherObservation.h
//  Weather
//
//  Created by Alberto on 18/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherObservation : NSObject
@property (strong, nonatomic) NSString *stationName;
@property (strong, nonatomic) NSString *temperature;
@property (strong, nonatomic) NSString *clouds;
@property (nonatomic) int humidity;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end
