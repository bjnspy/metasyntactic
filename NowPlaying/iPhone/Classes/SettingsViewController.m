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

#import "Application.h"
#import "ColorCache.h"
#import "CreditsViewController.h"
#import "DateUtilities.h"
#import "DVDFilterViewController.h"
#import "GlobalActivityIndicator.h"
#import "Location.h"
#import "LocationManager.h"
#import "LocationUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingController.h"
#import "NowPlayingModel.h"
#import "ScoreProviderViewController.h"
#import "SearchDatePickerViewController.h"
#import "SettingCell.h"
#import "SettingsNavigationController.h"
#import "TextFieldEditorViewController.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"
#import "Utilities.h"

@interface SettingsViewController()
@property (assign) SettingsNavigationController* navigationController;
@end


@implementation SettingsViewController

@synthesize navigationController;

- (void) dealloc {
    self.navigationController = nil;

    [super dealloc];
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (id) initWithNavigationController:(SettingsNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;

        NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        NSString* appVersion = [NowPlayingModel version];
        appVersion = [appVersion substringToIndex:[appVersion rangeOfString:@"." options:NSBackwardsSearch].location];

        self.title = [NSString stringWithFormat:@"%@ v%@", appName, appVersion];

        [self.controller.locationManager addLocationSpinner:self.navigationItem];
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    [self refresh];
}


- (void) refresh {
    self.tableView.rowHeight = 38;
    [self.tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 2;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 2;
    } else {
        return 7;
    }
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (row == 0) {
        cell.text = NSLocalizedString(@"Send Feedback", nil);
    } else {
        cell.text = NSLocalizedString(@"About", @"Clicking on this takes you to an 'about this application' page");
    }
    return cell;
}


- (UITableViewCell*) cellForSettingsRow:(NSInteger) row {
    if (row >= 0 && row <= 4) {
        SettingCell* cell = [[[SettingCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

        NSString* key = @"";
        NSString* value = @"";
        if (row == 0) {
            key = NSLocalizedString(@"Location", nil);
            Location* location = [self.model.userLocationCache locationForUserAddress:self.model.userAddress];
            if (location.postalCode == nil) {
                value = self.model.userAddress;
            } else {
                value = location.postalCode;
            }
        } else if (row == 1) {
            key = NSLocalizedString(@"Search Distance", nil);

            if (self.model.searchRadius == 1) {
                value = ([Application useKilometers] ? NSLocalizedString(@"1 kilometer", nil) : NSLocalizedString(@"1 mile", nil));
            } else {
                value = [NSString stringWithFormat:NSLocalizedString(@"%d %@", @"5 kilometers or 5 miles"),
                         self.model.searchRadius,
                         ([Application useKilometers] ? NSLocalizedString(@"kilometers", nil) : NSLocalizedString(@"miles", nil))];
            }
        } else if (row == 2) {
            key = NSLocalizedString(@"Search Date", @"This is noun, not a verb. It is the date we are getting movie listings for.");

            NSDate* date = self.model.searchDate;
            if ([DateUtilities isToday:date]) {
                value = NSLocalizedString(@"Today", nil);
            } else {
                value = [DateUtilities formatLongDate:date];
            }
        } else if (row == 3) {
            key = NSLocalizedString(@"Reviews", nil);
            value = self.model.currentScoreProvider;
        } else if (row == 4) {
            key = NSLocalizedString(@"DVD/Bluray", nil);
            if (self.model.dvdMoviesShowBoth) {
                value = NSLocalizedString(@"Both", nil);
            } else if (self.model.dvdMoviesShowOnlyDVDs) {
                value = NSLocalizedString(@"DVD", nil);
            } else if (self.model.dvdMoviesShowOnlyBluray) {
                value = NSLocalizedString(@"Bluray", nil);
            }
        }

        [cell setKey:key value:value];

        return cell;
    } else if (row >= 5 && row <= 6) {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UISwitch* picker = [[[UISwitch alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        cell.accessoryView = picker;

        NSString* text = @"";
        BOOL on = NO;
        if (row == 5) {
            text = NSLocalizedString(@"Auto-Update Location", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'automatically update the user's location with GPS information'");
            on = self.model.autoUpdateLocation;
            [picker addTarget:self action:@selector(onAutoUpdateChanged:) forControlEvents:UIControlEventValueChanged];
        } else if (row == 6) {
            text = NSLocalizedString(@"Use Small Fonts", @"This string has to be small enough to be visible with a picker switch next to it");
            on = self.model.useSmallFonts;
            [picker addTarget:self action:@selector(onUseSmallFontsChanged:) forControlEvents:UIControlEventValueChanged];
        }

        picker.on = on;
        cell.text = text;

        return cell;
    }

    return nil;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
          cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self cellForHeaderRow:indexPath.row];
    } else {
        return [self cellForSettingsRow:indexPath.row];
    }
}


- (void) onAutoUpdateChanged:(id) sender {
    [self.controller setAutoUpdateLocation:!self.model.autoUpdateLocation];
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


- (void) didSelectHeaderRow:(NSInteger) row {
    if (row == 0) {
        [Application openBrowser:self.model.feedbackUrl];
    } else if (row == 1) {
        CreditsViewController* controller = [[[CreditsViewController alloc] initWithModel:self.model] autorelease];
        [navigationController pushViewController:controller animated:YES];
    }
}


- (void) didSelectSettingsRow:(NSInteger) row {
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

                message = [NSString stringWithFormat:@"%@, %@ %@\n%@\nLatitude: %f\nLongitude: %f",
                           location.city,
                           location.state,
                           location.postalCode,
                           country,
                           location.latitude,
                           location.longitude];
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
    } else if (row == 4) {
        DVDFilterViewController* controller =
        [[[DVDFilterViewController alloc] initWithNavigationController:navigationController] autorelease];
        [navigationController pushViewController:controller animated:YES];
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        [self didSelectHeaderRow:indexPath.row];
    } else if (indexPath.section == 1) {
        [self didSelectSettingsRow:indexPath.row];
    }
}


- (void) onUserAddressChanged:(NSString*) userAddress {
    userAddress = [userAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [self.controller setUserAddress:userAddress];
    [self.tableView reloadData];
}


- (void) onSearchRadiusChanged:(NSString*) radius {
    [self.controller setSearchRadius:radius.intValue];
    [self.tableView reloadData];
}


- (UIView*)        tableView:(UITableView*) tableView
      viewForFooterInSection:(NSInteger) section {
    return [[[UIView alloc] init] autorelease];
}


- (CGFloat)          tableView:(UITableView*) tableView
      heightForFooterInSection:(NSInteger) section {
    return -5;
}

@end