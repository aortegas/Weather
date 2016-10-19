//
//  AOSObservationAnnotationMap.m
//  Weather
//
//  Created by Alberto on 19/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import "AOSObservationAnnotationMap.h"

@interface AOSObservationAnnotationMap ()
@property (strong, nonatomic) NSString *name;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@end

@implementation AOSObservationAnnotationMap

@synthesize coordinate;

- (id)initWithTitle:(NSString*)title coordinate:(CLLocationCoordinate2D)coord {
   
    self = [super init];
    if (self) {
        self.name = title;
        coordinate = coord;
    }
    return self;
}

- (NSString *)title {
    return self.name;
}

- (CLLocationCoordinate2D)coordinate {
    return coordinate;
}

@end







