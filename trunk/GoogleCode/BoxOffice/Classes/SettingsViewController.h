// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

@interface SettingsViewController : UITableViewController<CLLocationManagerDelegate> {
    SettingsNavigationController* navigationController;
    CLLocationManager* locationManager;

    // a non-null value means we are actively searching.
    ActivityIndicator* activityIndicator;
}

@property (assign) SettingsNavigationController* navigationController;
@property (retain) ActivityIndicator* activityIndicator;
@property (retain) CLLocationManager* locationManager;

- (id) initWithNavigationController:(SettingsNavigationController*) navigationController;

- (void) refresh;
- (BoxOfficeModel*) model;
- (BoxOfficeController*) controller;

- (void) locationManager:(CLLocationManager*) manager
     didUpdateToLocation:(CLLocation*) newLocation
            fromLocation:(CLLocation*) oldLocation;

- (void)locationManager:(CLLocationManager*) manager
       didFailWithError:(NSError*) error;

- (void) findPostalCode:(CLLocation*) location;

@end
