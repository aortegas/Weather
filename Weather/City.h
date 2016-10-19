//
//  City.h
//  Weather
//
//  Created by Alberto on 17/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *countryName;
@property (nonatomic) double east;
@property (nonatomic) double south;
@property (nonatomic) double north;
@property (nonatomic) double west;
@end
