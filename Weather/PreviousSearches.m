//
//  PreviousSearches.m
//  Weather
//
//  Created by Alberto on 19/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import "PreviousSearches.h"
#import "City.h"

@interface PreviousSearches ()
@property (strong, nonatomic) NSMutableArray *favoriteSearches;
@end

@implementation PreviousSearches

+(instancetype) sharedPreviousSearches {
    
    static dispatch_once_t onceToken;
    static PreviousSearches *shared;
    dispatch_once(&onceToken, ^{
        shared = [[PreviousSearches alloc] init];
    });
    return shared;
}


-(id)init {
    
    if (self = [super init] ) {

        // Create favorites array.
        self.favoriteSearches = [[NSMutableArray alloc] init];
        
        // Get favorites searches from NSUserDefaults.
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *previousSearches = [userDefaults objectForKey:@"favoriteSearches"];
        if (previousSearches.count > 0) {
            [self.favoriteSearches addObjectsFromArray:previousSearches];
        }
    }
    return self;
}

- (void)addFavoriteSearch:(City *)city {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL citySaved = false;
    
    for (NSData *cityEncoded in self.favoriteSearches) {
        
        City *cityDecoded = [NSKeyedUnarchiver unarchiveObjectWithData: cityEncoded];
        if (cityDecoded.name == city.name) {
            citySaved = true;
        }
    }
    
    if (!citySaved) {
        NSData *encodedCity = [NSKeyedArchiver archivedDataWithRootObject:city];
        [self.favoriteSearches addObject: encodedCity];
        [userDefaults setObject:self.favoriteSearches forKey:@"favoriteSearches"];
        [userDefaults synchronize];
    }
}

- (NSArray *)getFavoritesSearches {

    NSMutableArray *favoritesSearchesDecoded = [[NSMutableArray alloc] init];
    
    for (NSData *cityEncoded in self.favoriteSearches) {
        
        City *cityDecoded = [NSKeyedUnarchiver unarchiveObjectWithData: cityEncoded];
        [favoritesSearchesDecoded addObject:cityDecoded];
    }

    NSArray *favoritesSearches = [favoritesSearchesDecoded copy];
    return favoritesSearches;
}

@end



