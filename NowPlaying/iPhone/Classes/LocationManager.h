//
//  LocationManager.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface LocationManager : NSObject<CLLocationManagerDelegate> {
@private
    NowPlayingController* controller;
    NSLock* gate;
    CLLocationManager* locationManager;
        
    UINavigationItem* navigationItem;
    UIBarButtonItem* buttonItem;
    
    BOOL running;
}

+ (LocationManager*) managerWithController:(NowPlayingController*) controller;

- (void) autoUpdateLocation;

- (void) addLocationSpinner:(UINavigationItem*) navigationItem;

@end
