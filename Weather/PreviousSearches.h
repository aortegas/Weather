//
//  PreviousSearches.h
//  Weather
//
//  Created by Alberto on 19/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import <Foundation/Foundation.h>
@class City;

@interface PreviousSearches : NSObject
+ (instancetype) sharedPreviousSearches;
- (void)addFavoriteSearch:(City *)city;
- (NSArray *)getFavoritesSearches;
@end
