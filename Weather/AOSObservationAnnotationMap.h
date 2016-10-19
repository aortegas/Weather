//
//  AOSObservationAnnotationMap.h
//  Weather
//
//  Created by Alberto on 19/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AOSObservationAnnotationMap : NSObject <MKAnnotation>
- (id)initWithTitle:(NSString*)title coordinate:(CLLocationCoordinate2D)coord;
@end






