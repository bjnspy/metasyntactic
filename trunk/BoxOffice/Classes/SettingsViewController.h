//
//  SettingsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "BoxOfficeModel.h"
#import "ActivityIndicator.h"

@class SettingsNavigationController;

@interface SettingsViewController : UITableViewController<CLLocationManagerDelegate> {
    SettingsNavigationController* navigationController;
    UIBarButtonItem* currentLocationItem;
    ActivityIndicator* activityIndicator;
    CLLocationManager* locationManager;
}

@property (assign) SettingsNavigationController* navigationController;
@property (retain) UIBarButtonItem* currentLocationItem;
@property (retain) ActivityIndicator* activityIndicator;
@property (retain) CLLocationManager* locationManager;

- (id) initWithNavigationController:(SettingsNavigationController*) navigationController;
- (void) dealloc;

- (void) refresh;
- (BoxOfficeModel*) model;

- (void) locationManager:(CLLocationManager*) manager
     didUpdateToLocation:(CLLocation*) newLocation
            fromLocation:(CLLocation*) oldLocation;

- (void)locationManager:(CLLocationManager*) manager
       didFailWithError:(NSError*) error;

- (void) findZipcode:(CLLocation*) location;

@end
