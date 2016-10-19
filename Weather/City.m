//
//  City.m
//  Weather
//
//  Created by Alberto on 17/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import "City.h"

@implementation City

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    //Encode properties, other class variables, etc
    [encoder encodeObject: self.name forKey: @"name"];
    [encoder encodeObject: self.countryName forKey: @"countryName"];
    [encoder encodeDouble: self.east forKey: @"east"];
    [encoder encodeDouble: self.south forKey:@"south"];
    [encoder encodeDouble: self.north forKey:@"north"];
    [encoder encodeDouble: self.west forKey:@"west"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.countryName = [decoder decodeObjectForKey:@"countryName"];
        self.east = [decoder decodeDoubleForKey:@"east"];
        self.south = [decoder decodeDoubleForKey:@"south"];
        self.north = [decoder decodeDoubleForKey:@"north"];
        self.west = [decoder decodeDoubleForKey:@"west"];
    }
    return self;
}

@end
