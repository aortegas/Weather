//
//  AOSPreviousSearchTableViewController.h
//  Weather
//
//  Created by Alberto on 19/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class City;

@protocol DidSelectFavoriteSearchDelegate
- (void)didSelectCity:(City *)city;
@end

@interface AOSPreviousSearchTableViewController : UIViewController
@property (weak, nonatomic) id<DidSelectFavoriteSearchDelegate> delegate;
@end
