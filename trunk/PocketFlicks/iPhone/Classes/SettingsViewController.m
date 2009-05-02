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
#import "Controller.h"
#import "CreditsViewController.h"
#import "DVDFilterViewController.h"
#import "DateUtilities.h"
#import "Location.h"
#import "LocationManager.h"
#import "Model.h"
#import "ScoreProviderViewController.h"
#import "SearchDatePickerViewController.h"
#import "SearchDistancePickerViewController.h"
#import "SettingCell.h"
#import "SwitchCell.h"
#import "TextFieldEditorViewController.h"
#import "UserLocationCache.h"

@interface SettingsViewController()
@end


@implementation SettingsViewController


typedef enum {
    SendFeedbackSection,
    StandardSettingsSection,
    UpcomingSection,
    DVDBluraySection,
    NetflixSection,
    LastSection = NetflixSection
} SettingsSection;


- (void) dealloc {

    [super dealloc];
}


- (id) init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = [Application nameAndVersion];
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (Controller*) controller {
    return [Controller controller];
}


- (void) reload {
    [self reloadTableViewData];
}


- (void) majorRefreshWorker {
    [self reload];
}


- (void) minorRefreshWorker {
    [self reload];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [self.controller.locationManager addLocationSpinner:self.navigationItem];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone)] autorelease];
}


- (void) onDone {
    [self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
}


- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return LastSection + 1;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == SendFeedbackSection) {
        return 1;
    } else if (section == StandardSettingsSection) {
        return 10;
    } else if (section == UpcomingSection) {
        return 1;
    } else if (section == DVDBluraySection) {
        if (self.model.dvdBlurayCacheEnabled) {
            return 2;
        } else {
            return 1;
        }
    } else if (section == NetflixSection) {
        return 1;
    }

    return 0;
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
#ifdef IPHONE_OS_VERSION_3
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
#else
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
#endif

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSString* text = [NSString stringWithFormat:@"%@ / %@", LocalizedString(@"About", @"Title for the 'About' page (where we list who was involved in making the program and who supplied the data)"), LocalizedString(@"Send Feedback", @"Title for a button that a user can click on to send a feedback email to the developers")];
    cell.text = text;

    return cell;
}


- (UITableViewCell*) createSwitchCellWithText:(NSString*) text
                                           on:(BOOL) on
                                     selector:(SEL) selector {
    static NSString* reuseIdentifier = @"switchCellReuseIdentifier";

    SwitchCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[SwitchCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    [cell.switchControl removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
    [cell.switchControl addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
    cell.switchControl.on = on;
#ifdef IPHONE_OS_VERSION_3
    cell.textLabel.text = text;
#else
    cell.text = text;
#endif

    return cell;
}


- (UITableViewCell*) createSettingCellWithKey:(NSString*) key
                                        value:(NSString*) value
                                  placeholder:(NSString*) placeholder {
    static NSString* reuseIdentifier = @"reuseIdentifier";
    SettingCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[SettingCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    cell.placeholder = placeholder;
    cell.textLabel.text = key;
    [cell setCellValue:value];

    return cell;
}


- (UITableViewCell*) createSettingCellWithKey:(NSString*) key
                                        value:(NSString*) value {
    return [self createSettingCellWithKey:key value:value placeholder:@""];
}


- (UITableViewCell*) cellForSettingsRow:(NSInteger) row {
    if (row >= 0 && row <= 3) {
        NSString* key = @"";
        NSString* value = @"";
        NSString* placeholder = @"";
        if (row == 0) {
            key = LocalizedString(@"Location", nil);
            Location* location = [self.model.userLocationCache locationForUserAddress:self.model.userAddress];
            if (location.postalCode.length == 0) {
                value = self.model.userAddress;
            } else {
                value = location.postalCode;
            }
            placeholder = LocalizedString(@"Tap to enter location", nil);
        } else if (row == 1) {
            key = LocalizedString(@"Search Distance", nil);

            if (self.model.searchRadius == 1) {
                value = ([Application useKilometers] ? LocalizedString(@"1 kilometer", nil) : LocalizedString(@"1 mile", nil));
            } else {
                value = [NSString stringWithFormat:LocalizedString(@"%d %@", @"5 kilometers or 5 miles"),
                         self.model.searchRadius,
                         ([Application useKilometers] ? LocalizedString(@"kilometers", nil) : LocalizedString(@"miles", nil))];
            }
        } else if (row == 2) {
            key = LocalizedString(@"Search Date", @"This is noun, not a verb. It is the date we are getting movie listings for.");

            NSDate* date = self.model.searchDate;
            if ([DateUtilities isToday:date]) {
                value = LocalizedString(@"Today", nil);
            } else {
                value = [DateUtilities formatLongDate:date];
            }
        } else if (row == 3) {
            key = LocalizedString(@"Reviews", nil);
            value = self.model.currentScoreProvider;
        }

        return [self createSettingCellWithKey:key value:value placeholder:placeholder];
    } else if (row >= 4 && row <= 9) {
        NSString* text;
        BOOL on;
        SEL selector;
        if (row == 4) {
            text = LocalizedString(@"Auto-Update Location", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'automatically update the user's location with GPS information'");
            on = self.model.autoUpdateLocation;
            selector = @selector(onAutoUpdateChanged:);
        } else if (row == 5) {
            text = LocalizedString(@"Prioritize Bookmarks", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'sort bookmarked movies at the top of all lists'");
            on = self.model.prioritizeBookmarks;
            selector = @selector(onPrioritizeBookmarksChanged:);
        } else if (row == 6) {
            text = LocalizedString(@"Screen Rotation", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'don't turn the screen automatically when i rotate my phone'");
            on = self.model.screenRotationEnabled;
            selector = @selector(onScreenRotationEnabledChanged:);
        } else if (row == 7) {
            text = LocalizedString(@"Use Small Fonts", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'don't shrink the fonts when you have lots of stuff to display'");
            on = self.model.useSmallFonts;
            selector = @selector(onUseSmallFontsChanged:);
        } else if (row == 8) {
            text = LocalizedString(@"Show Notifications", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'show update notifications in the UI to let me know what's happening'");
            on = self.model.notificationsEnabled;
            selector = @selector(onShowNotificationsChanged:);
        } else if (row == 9) {
            text = LocalizedString(@"Loading Indicators", @"This string has to be small enough to be visible with a picker switch next to it.  It means 'show update spinners in the UI when loading content'");
            on = self.model.loadingIndicatorsEnabled;
            selector = @selector(onLoadingIndicatorsChanged:);
        }

        return [self createSwitchCellWithText:text on:on selector:selector];
    }

    return nil;
}


- (UITableViewCell*) cellForUpcomingRow:(NSInteger) row {
    return [self createSwitchCellWithText:LocalizedString(@"Enabled", nil)
                                       on:self.model.upcomingCacheEnabled
                                 selector:@selector(onUpcomingEnabledChanged:)];
}


- (UITableViewCell*) cellForDvdBlurayRow:(NSInteger) row {
    if (row == 0) {
        return [self createSwitchCellWithText:LocalizedString(@"Enabled", nil)
                                           on:self.model.dvdBlurayCacheEnabled
                                     selector:@selector(onDvdBlurayEnabledChanged:)];
    } else {
        NSString* key = LocalizedString(@"Options", @"Button to change the visibility options for DVD or Bluray.");
        NSString* value = @"";

        if (self.model.dvdMoviesShowBoth) {
            value = LocalizedString(@"Show Both", @"When the user wants to see 'Both' DVD and Bluray items");
        } else if (self.model.dvdMoviesShowOnlyDVDs) {
            value = LocalizedString(@"DVD Only", @"When the user wants to see only DVD items and not Bluray");
        } else if (self.model.dvdMoviesShowOnlyBluray) {
            value = LocalizedString(@"Blu-ray Only", @"When the user wants to see only Bluray items and not DVD");
        } else {
            value = LocalizedString(@"Show Neither", @"When the user does not want to see Bluray or DVD items");
        }

        return [self createSettingCellWithKey:key value:value];
    }
}


- (UITableViewCell*) cellForNetflixRow:(NSInteger) row {
    return [self createSwitchCellWithText:LocalizedString(@"Enabled", nil)
                                       on:self.model.netflixCacheEnabled
                                 selector:@selector(onNetflixEnabledChanged:)];
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == SendFeedbackSection) {
        return [self cellForHeaderRow:indexPath.row];
    } else if (indexPath.section == StandardSettingsSection) {
        return [self cellForSettingsRow:indexPath.row];
    } else if (indexPath.section == UpcomingSection) {
        return [self cellForUpcomingRow:indexPath.row];
    } else if (indexPath.section == DVDBluraySection) {
        return [self cellForDvdBlurayRow:indexPath.row];
    } else {
        return [self cellForNetflixRow:indexPath.row];
    }
}


- (void) onNetflixEnabledChanged:(UISwitch*) sender {
    [self.controller setNetflixEnabled:sender.on];
}


- (void) onUpcomingEnabledChanged:(UISwitch*) sender {
    [self.controller setUpcomingEnabled:sender.on];
}


- (void) onDvdBlurayEnabledChanged:(UISwitch*) sender {
    [self.controller setDvdBlurayEnabled:sender.on];
    [self reloadTableViewData];
}


- (void) onAutoUpdateChanged:(UISwitch*) sender {
    [self.controller setAutoUpdateLocation:sender.on];
}


- (void) onUseSmallFontsChanged:(UISwitch*) sender {
    [self.model setUseSmallFonts:sender.on];
}


- (void) onPrioritizeBookmarksChanged:(UISwitch*) sender {
    [self.model setPrioritizeBookmarks:sender.on];
}


- (void) onScreenRotationEnabledChanged:(UISwitch*) sender {
    [self.model setScreenRotationEnabled:sender.on];
}


- (void) onShowNotificationsChanged:(UISwitch*) sender {
    [self.model setNotificationsEnabled:sender.on];
}


- (void) onLoadingIndicatorsChanged:(UISwitch*) sender {
    [self.model setLoadingIndicatorsEnabled:sender.on];
}


- (void) pushSearchDatePicker {
    SearchDatePickerViewController* pickerController =
    [SearchDatePickerViewController pickerWithObject:self
                                            selector:@selector(onSearchDateChanged:)];

    [self.navigationController pushViewController:pickerController animated:YES];
}


- (void) onSearchDateChanged:(NSDate*) date {
    [self.controller setSearchDate:date];
    [self reloadTableViewData];
}


- (void) pushFilterDistancePicker {
    SearchDistancePickerViewController* controller =
    [[[SearchDistancePickerViewController alloc] init] autorelease];

    [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectCreditsRow:(NSInteger) row {
    CreditsViewController* controller = [[[CreditsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectSettingsRow:(NSInteger) row {
    if (row == 0) {
        NSString* message;

        if (self.model.userAddress.length == 0) {
            message = @"";
        } else {
            Location* location = [self.model.userLocationCache locationForUserAddress:self.model.userAddress];
            if (location.postalCode == nil) {
                message = LocalizedString(@"Could not find location.", nil);
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
        [[[TextFieldEditorViewController alloc] initWithTitle:LocalizedString(@"Location", nil)
                                                       object:self
                                                     selector:@selector(onUserAddressChanged:)
                                                         text:self.model.userAddress
                                                      message:message
                                                  placeHolder:LocalizedString(@"City/State or Postal Code", nil)
                                                         type:UIKeyboardTypeDefault] autorelease];

        [self.navigationController pushViewController:controller animated:YES];
    } else if (row == 1) {
        [self pushFilterDistancePicker];
    } else if (row == 2) {
        [self pushSearchDatePicker];
    } else if (row == 3) {
        ScoreProviderViewController* controller =
        [[[ScoreProviderViewController alloc] init] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (void) didSelectUpcomingRow:(NSInteger) row {

}


- (void) didSelectDvdBlurayRow:(NSInteger) row {
    if (row == 1) {
        DVDFilterViewController* controller = [[[DVDFilterViewController alloc] init] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (void) didSelectNetflixRow:(NSInteger) row {

}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == SendFeedbackSection) {
        [self didSelectCreditsRow:indexPath.row];
    } else if (indexPath.section == StandardSettingsSection) {
        [self didSelectSettingsRow:indexPath.row];
    } else if (indexPath.section == UpcomingSection) {
        [self didSelectUpcomingRow:indexPath.row];
    } else if (indexPath.section == DVDBluraySection) {
        [self didSelectDvdBlurayRow:indexPath.row];
    } else {
        [self didSelectNetflixRow:indexPath.row];
    }
}


- (void) onUserAddressChanged:(NSString*) userAddress {
    userAddress = [userAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [self.controller setUserAddress:userAddress];
    [self reloadTableViewData];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == UpcomingSection) {
        return LocalizedString(@"Upcoming", nil);
    } else if (section == DVDBluraySection) {
        return LocalizedString(@"DVD/Blu-ray", nil);
    } else if (section == NetflixSection) {
        return LocalizedString(@"Netflix", nil);
    }

    return nil;
}

@end