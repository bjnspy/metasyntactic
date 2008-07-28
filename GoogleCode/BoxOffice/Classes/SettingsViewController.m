//
//  SettingsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "SettingsViewController.h"
#import "ApplicationTabBarController.h"
#import "BoxOfficeAppDelegate.h"
#import "XmlParser.h"
#import "TextFieldEditorViewController.h"
#import "PickerEditorViewController.h"
#import "Utilities.h"
#import "CreditsViewController.h"
#import "Application.h"
#import "AttributeCell.h"
#import "SettingCell.h"
#import "RatingsProviderViewController.h"
#import "DateUtilities.h"
#import "SearchDatePickerViewController.h"
#import "ColorCache.h"

@implementation SettingsViewController

@synthesize navigationController;
@synthesize activityIndicator;
@synthesize locationManager;

- (void) dealloc {
    self.navigationController = nil;
    self.activityIndicator = nil;
    self.locationManager = nil;

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

        //self.title = NSLocalizedString(@"Settings", nil);
        self.title = [NSString stringWithFormat:@"Now Playing v%@", [BoxOfficeModel version]];

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

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];

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

- (void) findPostalCodeBackgroundEntryPoint:(CLLocation*) location {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];

    [self findPostalCode:location];

    [autoreleasePool release];
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
        if (indexPath.row >= 0 && indexPath.row <= 3) {
            return UITableViewCellAccessoryDisclosureIndicator;
        } else {
            return UITableViewCellAccessoryNone;
        }
    } else if (indexPath.section == 1) {
        return UITableViewCellAccessoryNone;
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
        return 5;
    } else if (section == 1) {
        return 1;
    } else {
        return 1;
    }
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row >= 0 && indexPath.row <= 3) {
            SettingCell* cell = [[[SettingCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

            NSString* key;
            NSString* value;
            if (indexPath.row == 0) {
                key = NSLocalizedString(@"Postal code", nil);
                value = [self.model postalCode];
            } else if (indexPath.row == 1) {
                key = NSLocalizedString(@"Hide theaters beyond", nil);

                if ([self.model searchRadius] == 1) {
                    value = NSLocalizedString(@"1 mile", nil);
                } else {
                    value = [NSString stringWithFormat:NSLocalizedString(@"%d miles", nil), [self.model searchRadius]];
                }
            } else if (indexPath.row == 2) {
                key = NSLocalizedString(@"Search date", nil);

                NSDate* date = [self.model searchDate];
                if ([DateUtilities isToday:date]) {
                    value = NSLocalizedString(@"Today", nil);
                } else {
                    value = [DateUtilities formatLongDate:date];
                }
            } else if (indexPath.row == 3) {
                key = NSLocalizedString(@"Ratings", nil);
                value = [self.model currentRatingsProvider];
            }

            [cell setKey:key value:value];

            return cell;
        } else {
            UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
            cell.text = NSLocalizedString(@"Auto-update location", nil);
            UISwitch* picker = [[[UISwitch alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
            picker.on = [self.model autoUpdateLocation];
            [picker addTarget:self action:@selector(onAutoUpdateChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = picker;
            return cell;
        }
    } else if (indexPath.section == 1) {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

        cell.text = NSLocalizedString(@"Donate", nil);
        cell.textColor = [ColorCache commandColor];
        cell.textAlignment = UITextAlignmentCenter;

        return cell;
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        cell.text = NSLocalizedString(@"About", nil);
        return cell;
    }
}

- (void) onAutoUpdateChanged:(id) sender {
    BOOL autoUpdate = ![self.model autoUpdateLocation];
    [self.model setAutoUpdateLocation:autoUpdate];
    [self autoUpdateLocation:nil];

}

- (void) pushSearchDatePicker {
    SearchDatePickerViewController* pickerController =
    [SearchDatePickerViewController pickerWithNavigationController:self.navigationController
                                                        controller:self.controller];

    [self.navigationController pushViewController:pickerController animated:YES];
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        if (row == 0) {
            TextFieldEditorViewController* controller =
            [[[TextFieldEditorViewController alloc] initWithController:self.navigationController
                                                             withTitle:NSLocalizedString(@"Postal code", nil)
                                                            withObject:self
                                                          withSelector:@selector(onPostalCodeChanged:)
                                                              withText:[self.model postalCode]
                                                              withType:UIKeyboardTypeNumbersAndPunctuation] autorelease];

            [self.navigationController pushViewController:controller animated:YES];
        } else if (row == 1) {
            NSArray* values = [NSArray arrayWithObjects:
                               @"1", @"2", @"3", @"4", @"5",
                               @"10", @"15", @"20", @"25", @"30",
                               @"35", @"40", @"45", @"50", nil];
            NSString* defaultValue = [NSString stringWithFormat:@"%d", [self.model searchRadius]];

            PickerEditorViewController* controller =
            [[[PickerEditorViewController alloc] initWithController:self.navigationController
                                                          withTitle:NSLocalizedString(@"Distance", nil)
                                                         withObject:self
                                                       withSelector:@selector(onSearchRadiusChanged:)
                                                         withValues:values
                                                       defaultValue:defaultValue] autorelease];

            [self.navigationController pushViewController:controller animated:YES];
        } else if (row == 2) {
            [self pushSearchDatePicker];
        } else if (row == 3) {
            RatingsProviderViewController* controller =
                [[[RatingsProviderViewController alloc] initWithNavigationController:self.navigationController] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (section == 1) {
        [Application openBrowser:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=cyrusn%40stwing%2eupenn%2eedu&item_name=iPhone%20Apps%20Donations&no_shipping=0&no_note=1&tax=0&currency_code=USD&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8"];
    } else if (section == 2) {
        CreditsViewController* controller = [[[CreditsViewController alloc] init] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void) onPostalCodeChanged:(NSString*) postalCode {
    NSMutableString* trimmed = [NSMutableString string];
    for (NSInteger i = 0; i < [postalCode length]; i++) {
        unichar c = [postalCode characterAtIndex:i];
        if (isalnum(c)) {
            [trimmed appendString:[NSString stringWithCharacters:&c length:1]];
        }
    }

    [self.controller setPostalCode:trimmed];
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
    [self.controller setSearchRadius:[radius intValue]];
    [self.tableView reloadData];
}

@end
