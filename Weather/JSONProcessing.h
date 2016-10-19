//
//  JSONProcessing.h
//  Weather
//
//  Created by Alberto on 18/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONProcessing : NSObject
+ (NSArray *)citiesFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (NSArray *)weatherObservationsFromJSON:(NSData *)objectNotation error:(NSError **)error;
@end

