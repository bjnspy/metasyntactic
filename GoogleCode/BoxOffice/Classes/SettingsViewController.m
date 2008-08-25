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

#import "SettingsViewController.h"

#import "ActivityIndicator.h"
#import "Application.h"
#import "BoxOfficeModel.h"
#import "ColorCache.h"
#import "CreditsViewController.h"
#import "DateUtilities.h"
#import "RatingsProviderViewController.h"
#import "SearchDatePickerViewController.h"
#import "SettingCell.h"
#import "SettingsNavigationController.h"
#import "TextFieldEditorViewController.h"
#import "Utilities.h"
#import "XmlElement.h"

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
    [self.activityIndicator start];
    [self.locationManager startUpdatingLocation];
}


- (void) autoUpdateLocation:(id) sender {
    // only actually auto-update if:
    //   a) the user wants it
    //   b) we're not currently searching
    if ([self.model autoUpdateLocation] && self.activityIndicator == nil) {
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
        NSString* appVersion = [BoxOfficeModel version];
        appVersion = [appVersion substringToIndex:[appVersion rangeOfString:@"." options:NSBackwardsSearch].location];

        self.title = [NSString stringWithFormat:@"%@ v%@", appName, appVersion];

        UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CurrentPosition.png"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(onCurrentLocationClicked:)] autorelease];

        self.navigationItem.leftBarButtonItem = item;

        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;

        [self performSelector:@selector(autoUpdateLocation:) withObject:nil afterDelay:2];
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    [self refresh];
}


- (void) refresh {
    [self.tableView reloadData];
}


- (void) stopActivityIndicator {
    [self.activityIndicator stop];
    self.activityIndicator = nil;
}


- (void) locationManager:(CLLocationManager*) manager
     didUpdateToLocation:(CLLocation*) newLocation
            fromLocation:(CLLocation*) oldLocation {
    if (newLocation != nil) {
        if (ABS([newLocation.timestamp timeIntervalSinceNow]) < 10) {
            [locationManager stopUpdatingLocation];
            [self performSelectorInBackground:@selector(findPostalCodeBackgroundEntryPoint:) withObject:newLocation];
        }
    }
}


- (NSString*) findUSPostalCode:(CLLocation*) location {
    CLLocationCoordinate2D coordinates = [location coordinate];
    double latitude = coordinates.latitude;
    double longitude = coordinates.longitude;
    NSString* urlString = [NSString stringWithFormat:@"http://ws.geonames.org/findNearbyPostalCodes?lat=%f&lng=%f&maxRows=1", latitude, longitude];

    XmlElement* geonamesElement = [Utilities downloadXml:urlString];
    XmlElement* codeElement = [geonamesElement element:@"code"];
    XmlElement* postalElement = [codeElement element:@"postalcode"];
    XmlElement* countryElement = [codeElement element:@"countryCode"];

    if ([@"CA" isEqual:countryElement.text]) {
        return nil;
    }

    return [postalElement text];
}


- (NSString*) findCAPostalCode:(CLLocation*) location {
    CLLocationCoordinate2D coordinates = [location coordinate];
    double latitude = coordinates.latitude;
    double longitude = coordinates.longitude;
    NSString* urlString = [NSString stringWithFormat:@"http://geocoder.ca/?latt=%f&longt=%f&geoit=xml&reverse=Reverse+GeoCode+it", latitude, longitude];

    XmlElement* geodataElement = [Utilities downloadXml:urlString];
    XmlElement* postalElement = [geodataElement element:@"postal"];
    return [postalElement text];
}


- (void) findPostalCode:(CLLocation*) location {
    NSString* postalCode = [self findUSPostalCode:location];
    if (postalCode == nil) {
        postalCode = [self findCAPostalCode:location];
    }

    [self performSelectorOnMainThread:@selector(reportFoundPostalCode:) withObject:postalCode waitUntilDone:NO];
}


- (void) findPostalCodeBackgroundEntryPoint:(CLLocation*) location {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    [gate lock];
    {
        [self findPostalCode:location];
    }
    [gate unlock];
    [autoreleasePool release];
}


- (void)locationManager:(CLLocationManager*) manager
       didFailWithError:(NSError*) error {
    [locationManager stopUpdatingLocation];
    [self stopActivityIndicator];

    // intermittent failures are not uncommon.  retry in a minute.
    [self enqueueUpdateRequest:60];
}


- (BoxOfficeModel*) model {
    return [self.navigationController model];
}


- (BoxOfficeController*) controller {
    return [self.navigationController controller];
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellAccessoryNone;
    } else if (indexPath.section == 1) {
        return UITableViewCellAccessoryDisclosureIndicator;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 3;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 6;
    } else {
        return 1;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

        cell.text = NSLocalizedString(@"Donate", nil);
        cell.textColor = [ColorCache commandColor];
        cell.textAlignment = UITextAlignmentCenter;

        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row >= 0 && indexPath.row <= 3) {
            SettingCell* cell = [[[SettingCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

            NSString* key;
            NSString* value;
            if (indexPath.row == 0) {
                key = NSLocalizedString(@"Location", nil);
                value = self.model.postalCode;
            } else if (indexPath.row == 1) {
                key = NSLocalizedString(@"Search Distance", nil);

                if (self.model.searchRadius == 1) {
                    value = (self.model.useKilometers ? NSLocalizedString(@"1 kilometer", nil) : NSLocalizedString(@"1 mile", nil));
                } else {
                    value = [NSString stringWithFormat:NSLocalizedString(@"%d %@", @"5 kilometers or 5 miles"),
                             self.model.searchRadius,
                             (self.model.useKilometers ? NSLocalizedString(@"kilometers", nil) : NSLocalizedString(@"miles", nil))];
                }
            } else if (indexPath.row == 2) {
                key = NSLocalizedString(@"Search Date", nil);

                NSDate* date = [self.model searchDate];
                if ([DateUtilities isToday:date]) {
                    value = NSLocalizedString(@"Today", nil);
                } else {
                    value = [DateUtilities formatLongDate:date];
                }
            } else if (indexPath.row == 3) {
                key = NSLocalizedString(@"Reviews", nil);
                value = self.model.currentRatingsProvider;
            }

            [cell setKey:key value:value];

            return cell;
        } else if (indexPath.row >= 4 && indexPath.row <= 5) {
            UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UISwitch* picker = [[[UISwitch alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
            cell.accessoryView = picker;

            NSString* text;
            BOOL on;
            if (indexPath.row == 4) {
                text = NSLocalizedString(@"Auto-Update Location", nil);
                on = self.model.autoUpdateLocation;
                [picker addTarget:self action:@selector(onAutoUpdateChanged:) forControlEvents:UIControlEventValueChanged];
            } else if (indexPath.row == 5) {
                text = NSLocalizedString(@"Use Small Fonts", nil);
                on = self.model.useSmallFonts;
                [picker addTarget:self action:@selector(onUseSmallFontsChanged:) forControlEvents:UIControlEventValueChanged];
            }

            picker.on = on;
            cell.text = text;

            return cell;
        }
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        cell.text = NSLocalizedString(@"About", nil);
        return cell;
    }

    return nil;
}


- (void) onAutoUpdateChanged:(id) sender {
    [self.model setAutoUpdateLocation:!self.model.autoUpdateLocation];
    [self autoUpdateLocation:nil];

}


- (void) onUseSmallFontsChanged:(id) sender {
    BOOL useSmallFonts = ![self.model useSmallFonts];
    [self.model setUseSmallFonts:useSmallFonts];
    [self.navigationController.tabBarController refresh];

}


- (void) pushSearchDatePicker {
    SearchDatePickerViewController* pickerController =
    [SearchDatePickerViewController pickerWithNavigationController:self.navigationController
                                                        controller:self.controller];

    [self.navigationController pushViewController:pickerController animated:YES];
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

    [self.navigationController pushViewController:controller animated:YES];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        [Application openBrowser:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=cyrusn%40stwing%2eupenn%2eedu&item_name=iPhone%20Apps%20Donations&no_shipping=0&no_note=1&tax=0&currency_code=USD&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8"];
    } else if (section == 1) {
        if (row == 0) {
            TextFieldEditorViewController* controller =
            [[[TextFieldEditorViewController alloc] initWithController:self.navigationController
                                                                 title:NSLocalizedString(@"Location", nil)
                                                                object:self
                                                              selector:@selector(onPostalCodeChanged:)
                                                                  text:self.model.postalCode
                                                           placeHolder:NSLocalizedString(@"Postal Code", nil)
                                                                  type:UIKeyboardTypeNumbersAndPunctuation] autorelease];

            [self.navigationController pushViewController:controller animated:YES];
        } else if (row == 1) {
            [self pushFilterDistancePicker];
        } else if (row == 2) {
            [self pushSearchDatePicker];
        } else if (row == 3) {
            RatingsProviderViewController* controller =
                [[[RatingsProviderViewController alloc] initWithNavigationController:self.navigationController] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (section == 2) {
        CreditsViewController* controller = [[[CreditsViewController alloc] init] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (void) onPostalCodeChanged:(NSString*) postalCode {
    postalCode = [postalCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [self.controller setPostalCode:postalCode];
    [self.tableView reloadData];
}


- (void) reportFoundPostalCode:(NSString*) postalCode {
    [self stopActivityIndicator];

    if ([Utilities isNilOrEmpty:postalCode]) {
        [self enqueueUpdateRequest:60];
    } else {
        [self enqueueUpdateRequest:5 * 60];
    }

    [self onPostalCodeChanged:postalCode];
}


- (void) onSearchRadiusChanged:(NSString*) radius {
    [self.controller setSearchRadius:radius.intValue];
    [self.tableView reloadData];
}


@end
