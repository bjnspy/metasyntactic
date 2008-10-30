// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "SettingsViewController.h"

#import "ActivityIndicator.h"
#import "Application.h"
#import "ColorCache.h"
#import "CreditsViewController.h"
#import "DateUtilities.h"
#import "GlobalActivityIndicator.h"
#import "Location.h"
#import "LocationUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "ScoreProviderViewController.h"
#import "SearchDatePickerViewController.h"
#import "SettingCell.h"
#import "SettingsNavigationController.h"
#import "TextFieldEditorViewController.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"
#import "Utilities.h"

@implementation SettingsViewController

@synthesize navigationController;
@synthesize activityIndicator;
@synthesize locationManager;
@synthesize gate;

- (void) dealloc {
    self.navigationController = nil;
    self.activityIndicator = nil;
    self.locationManager = nil;
    self.gate = nil;

    [super dealloc];
}


- (void) onCurrentLocationClicked:(id) sender {
    self.activityIndicator = [[[ActivityIndicator alloc] initWithNavigationItem:self.navigationItem] autorelease];
    [activityIndicator start];
    [locationManager startUpdatingLocation];
}


- (void) autoUpdateLocation:(id) sender {
    // only actually auto-update if:
    //   a) the user wants it
    //   b) we're not currently searching
    if (self.model.autoUpdateLocation && activityIndicator == nil) {
        [self onCurrentLocationClicked:nil];
    }
}


- (void) enqueueUpdateRequest:(NSInteger) delay {
    [self performSelector:@selector(autoUpdateLocation:) withObject:nil afterDelay:delay];
}


- (id) initWithNavigationController:(SettingsNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.gate = [[[NSLock alloc] init] autorelease];

        NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        NSString* appVersion = [NowPlayingModel version];
        appVersion = [appVersion substringToIndex:[appVersion rangeOfString:@"." options:NSBackwardsSearch].location];

        self.title = [NSString stringWithFormat:@"%@ v%@", appName, appVersion];

        UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CurrentPosition.png"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(onCurrentLocationClicked:)] autorelease];

        self.navigationItem.leftBarButtonItem = item;

        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;

        [self performSelector:@selector(autoUpdateLocation:) withObject:nil afterDelay:2];
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    [self refresh];
}


- (void) refresh {
    self.tableView.rowHeight = 42;
    [self.tableView reloadData];
}


- (void) stopActivityIndicator {
    [activityIndicator stop];
    self.activityIndicator = nil;
}


- (void) locationManager:(CLLocationManager*) manager
     didUpdateToLocation:(CLLocation*) newLocation
            fromLocation:(CLLocation*) oldLocation {
    if (newLocation != nil) {
        if (ABS(newLocation.timestamp.timeIntervalSinceNow) < 10) {
            [locationManager stopUpdatingLocation];

            [ThreadingUtilities performSelector:@selector(findLocationBackgroundEntryPoint:)
                                       onTarget:self
                       inBackgroundWithArgument:newLocation
                                           gate:gate
                                        visible:YES];
        }
    }
}


- (void) findLocationBackgroundEntryPoint:(CLLocation*) location {
    Location* userLocation = [LocationUtilities findLocation:location];

    [self performSelectorOnMainThread:@selector(reportFoundUserLocation:) withObject:userLocation waitUntilDone:NO];
}


- (void)locationManager:(CLLocationManager*) manager
       didFailWithError:(NSError*) error {
    [locationManager stopUpdatingLocation];
    [self stopActivityIndicator];

    // intermittent failures are not uncommon. retry in a minute.
    [self enqueueUpdateRequest:ONE_MINUTE];
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        } else {
            return UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (indexPath.section == 1) {
        return UITableViewCellAccessoryNone;
    }
    
    return UITableViewCellAccessoryNone;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 2;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 2;
    } else {
        return 6;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { 
            UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
            cell.text = NSLocalizedString(@"Send feedback", nil);
            return cell;
        } else {
            UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
            cell.text = NSLocalizedString(@"About", @"Clicking on this takes you to an 'about this application' page");
            return cell;
        }
    } else {
        if (indexPath.row >= 0 && indexPath.row <= 3) {
            SettingCell* cell = [[[SettingCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

            NSString* key;
            NSString* value;
            if (indexPath.row == 0) {
                key = NSLocalizedString(@"Location", nil);
                Location* location = [self.model.userLocationCache locationForUserAddress:self.model.userAddress];
                if (location.postalCode == nil) {
                    value = self.model.userAddress;
                } else {
                    value = location.postalCode;
                }
            } else if (indexPath.row == 1) {
                key = NSLocalizedString(@"Search Distance", nil);

                if (self.model.searchRadius == 1) {
                    value = ([Application useKilometers] ? NSLocalizedString(@"1 kilometer", nil) : NSLocalizedString(@"1 mile", nil));
                } else {
                    value = [NSString stringWithFormat:NSLocalizedString(@"%d %@", @"5 kilometers or 5 miles"),
                             self.model.searchRadius,
                             ([Application useKilometers] ? NSLocalizedString(@"kilometers", nil) : NSLocalizedString(@"miles", nil))];
                }
            } else if (indexPath.row == 2) {
                key = NSLocalizedString(@"Search Date", @"This is noun, not a verb. It is the date we are getting movie listings for.");

                NSDate* date = self.model.searchDate;
                if ([DateUtilities isToday:date]) {
                    value = NSLocalizedString(@"Today", nil);
                } else {
                    value = [DateUtilities formatLongDate:date];
                }
            } else if (indexPath.row == 3) {
                key = NSLocalizedString(@"Reviews", nil);
                value = self.model.currentScoreProvider;
            }

            [cell setKey:key value:value];

            return cell;
        } else if (indexPath.row >= 4 && indexPath.row <= 5) {
            UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UISwitch* picker = [[[UISwitch alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
            cell.accessoryView = picker;

            NSString* text = @"";
            BOOL on = NO;
            if (indexPath.row == 4) {
                text = NSLocalizedString(@"Auto-Update Location", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'automatically update the user's location with GPS information'");
                on = self.model.autoUpdateLocation;
                [picker addTarget:self action:@selector(onAutoUpdateChanged:) forControlEvents:UIControlEventValueChanged];
            } else if (indexPath.row == 5) {
                text = NSLocalizedString(@"Use Small Fonts", @"This string has to be small enough to be visible with a picker switch next to it");
                on = self.model.useSmallFonts;
                [picker addTarget:self action:@selector(onUseSmallFontsChanged:) forControlEvents:UIControlEventValueChanged];
            }

            picker.on = on;
            cell.text = text;

            return cell;
        }
    }

    return nil;
}


- (void) onAutoUpdateChanged:(id) sender {
    [self.model setAutoUpdateLocation:!self.model.autoUpdateLocation];
    [self autoUpdateLocation:nil];
}


- (void) onUseSmallFontsChanged:(id) sender {
    BOOL useSmallFonts = !self.model.useSmallFonts;
    [self.model setUseSmallFonts:useSmallFonts];
}


- (void) pushSearchDatePicker {
    SearchDatePickerViewController* pickerController = [SearchDatePickerViewController pickerWithNavigationController:navigationController];

    [navigationController pushViewController:pickerController animated:YES];
}


- (void) pushFilterDistancePicker {
    NSArray* values = [NSArray arrayWithObjects:
                       @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                       @"10", @"15", @"20", @"25", @"30",
                       @"35", @"40", @"45", @"50", nil];
    NSString* defaultValue = [NSString stringWithFormat:@"%d", self.model.searchRadius];

    PickerEditorViewController* controller =
    [[[PickerEditorViewController alloc] initWithController:self.navigationController
                                                      title:NSLocalizedString(@"Search Distance", nil)
                                                       text:NSLocalizedString(@"Theater providers often limit the maximum search distance they will provide data for. As a result, some theaters may not show up for you even if your search distance is set high.", nil)
                                                     object:self
                                                   selector:@selector(onSearchRadiusChanged:)
                                                     values:values
                                               defaultValue:defaultValue] autorelease];

    [navigationController pushViewController:controller animated:YES];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        if (indexPath.row == 1) {
            CreditsViewController* controller = [[[CreditsViewController alloc] init] autorelease];
            [navigationController pushViewController:controller animated:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
            NSString* message;

            if (self.model.userAddress.length == 0) {
                message = @"";
            } else {
                Location* location = [self.model.userLocationCache locationForUserAddress:self.model.userAddress];
                if (location.postalCode == nil) {
                    message = NSLocalizedString(@"Could not find location.", nil);
                } else {
                    NSString* country = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode
                                                                              value:location.country];
                    if (country == nil) {
                        country = location.country;
                    }

#if TARGET_IPHONE_SIMULATOR
                    message = [NSString stringWithFormat:@"%@, %@ %@\n%@\n%f %f",
                               location.city,
                               location.state,
                               location.postalCode,
                               country,
                               location.latitude,
                               location.longitude];
#else
                    message = [NSString stringWithFormat:@"%@, %@ %@\n%@",
                               location.city,
                               location.state,
                               location.postalCode,
                               country];
#endif
                }
            }

            TextFieldEditorViewController* controller =
            [[[TextFieldEditorViewController alloc] initWithController:navigationController
                                                                 title:NSLocalizedString(@"Location", nil)
                                                                object:self
                                                              selector:@selector(onUserAddressChanged:)
                                                                  text:self.model.userAddress
                                                               message:message
                                                           placeHolder:NSLocalizedString(@"City/State or Postal Code", nil)
                                                                  type:UIKeyboardTypeDefault] autorelease];

            [navigationController pushViewController:controller animated:YES];
        } else if (row == 1) {
            [self pushFilterDistancePicker];
        } else if (row == 2) {
            [self pushSearchDatePicker];
        } else if (row == 3) {
            ScoreProviderViewController* controller =
            [[[ScoreProviderViewController alloc] initWithNavigationController:navigationController] autorelease];
            [navigationController pushViewController:controller animated:YES];
        }
    }
}


- (void) onUserAddressChanged:(NSString*) userAddress {
    userAddress = [userAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [self.controller setUserAddress:userAddress];
    [self.tableView reloadData];
}


- (void) reportFoundUserLocation:(Location*) userLocation {
    [self stopActivityIndicator];

    if (userLocation == nil) {
        [self enqueueUpdateRequest:ONE_MINUTE];
    } else {
        [self enqueueUpdateRequest:5 * ONE_MINUTE];
    }

    NSString* displayString = userLocation.fullDisplayString;
    [self.model.userLocationCache setLocation:userLocation forUserAddress:displayString];
    [self onUserAddressChanged:displayString];
}


- (void) onSearchRadiusChanged:(NSString*) radius {
    [self.controller setSearchRadius:radius.intValue];
    [self.tableView reloadData];
}


@end