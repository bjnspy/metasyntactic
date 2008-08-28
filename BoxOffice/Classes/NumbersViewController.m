// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "NumbersViewController.h"

#import "BoxOfficeModel.h"
#import "NumbersNavigationController.h"
#import "SettingCell.h"

@implementation NumbersViewController

@synthesize navigationController;
@synthesize segmentedControl;

- (void) dealloc {
    self.navigationController = nil;
    self.segmentedControl = nil;
    
    [super dealloc];
}


- (id) initWithNavigationController:(NumbersNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.title = NSLocalizedString(@"Numbers", nil);
        
        self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                                  [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Daily", nil),
                                   NSLocalizedString(@"Weekend", nil), nil]] autorelease];
        
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.selectedSegmentIndex = [self.model allTheatersSelectedSegmentIndex];
        /*
         [segmentedControl addTarget:self
         action:@selector(onSortOrderChanged:)
         forControlEvents:UIControlEventValueChanged];
         */
        CGRect rect = segmentedControl.frame;
        rect.size.width = 240;
        segmentedControl.frame = rect;
        
        self.navigationItem.titleView = segmentedControl;
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


- (BoxOfficeModel*) model {
    return self.navigationController.model;
}


- (BoxOfficeController*) controller {
    return self.navigationController.controller;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 3;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    return 6;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"NumbersViewCellIdentifier";
    SettingCell* cell = nil;//(id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[SettingCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        if (indexPath.row >= 2) {
            UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, -1, 300, 2)] autorelease];
            label.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:label];
        }
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setKey:@"Title" value:@"Dark Knight, The"];
        } else if (indexPath.row == 1) {
            [cell setKey:@"Days in Theater" value:@"24"];
        } else if (indexPath.row == 2) {
            [cell setKey:@"Weekend Gross" value:@"$26,117,030"];
        } else if (indexPath.row == 3) {
            [cell setKey:@"Change" value:@"-38.78%"];
        } else if (indexPath.row == 4) {
            [cell setKey:@"Theaters" value:@"4,025"];
        } else if (indexPath.row == 5) {
            [cell setKey:@"Total Gross" value:@"$441,628,497"];
        }
    } else {
        if (indexPath.row == 0) {
            [cell setKey:@"Title" value:@"Mummy"];
        } else if (indexPath.row == 1) {
            [cell setKey:@"Days in Theater" value:@"10"];
        } else if (indexPath.row == 2) {
            [cell setKey:@"Weekend Gross" value:@"$16,490,970"];
        } else if (indexPath.row == 3) {
            [cell setKey:@"Change" value:@"-59.24%"];
        } else if (indexPath.row == 4) {
            [cell setKey:@"Theaters" value:@"3,778"];
        } else if (indexPath.row == 5) {
            [cell setKey:@"Total Gross" value:@"$71,048,920"];
        }
    }
    
    return cell;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.row == 0) {
        return tableView.rowHeight;
    }
    
    return tableView.rowHeight - 16;
}

/*
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
 value = NSLocalizedString(@"1 mile", nil);
 } else {
 value = [NSString stringWithFormat:NSLocalizedString(@"%d miles", nil), self.model.searchRadius];
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
 value = [self.model currentRatingsProvider];
 }
 
 [cell setKey:key value:value];
 
 return cell;
 } else if (indexPath.row == 4) {
 UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
 cell.text = NSLocalizedString(@"Auto-Update Location", nil);
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
 UISwitch* picker = [[[UISwitch alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
 picker.on = [self.model autoUpdateLocation];
 [picker addTarget:self action:@selector(onAutoUpdateChanged:) forControlEvents:UIControlEventValueChanged];
 
 cell.accessoryView = picker;
 return cell;
 } else {
 UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
 cell.text = NSLocalizedString(@"Use Small Fonts", nil);
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
 UISwitch* picker = [[[UISwitch alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
 picker.on = [self.model useSmallFonts];
 [picker addTarget:self action:@selector(onUseSmallFontsChanged:) forControlEvents:UIControlEventValueChanged];
 
 cell.accessoryView = picker;
 return cell;
 }
 } else {
 UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
 cell.text = NSLocalizedString(@"About", nil);
 return cell;
 }
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
 NSArray* values = [NSArray arrayWithObjects:
 @"1", @"2", @"3", @"4", @"5",
 @"10", @"15", @"20", @"25", @"30",
 @"35", @"40", @"45", @"50", nil];
 NSString* defaultValue = [NSString stringWithFormat:@"%d", self.model.searchRadius];
 
 PickerEditorViewController* controller =
 [[[PickerEditorViewController alloc] initWithController:self.navigationController
 title:NSLocalizedString(@"Distance", nil)
 text:@""
 object:self
 selector:@selector(onSearchRadiusChanged:)
 values:values
 defaultValue:defaultValue] autorelease];
 
 [self.navigationController pushViewController:controller animated:YES];
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
 */


@end
