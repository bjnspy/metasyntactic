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

#import "CreditsViewController.h"

#import "Application.h"
#import "LocaleUtilities.h"
#import "SettingCell.h"

@implementation CreditsViewController

const int WRITTEN_BY_SECTION = 0;
const int GRAPHICS_BY_SECTION = 1;
const int MOVIE_REVIEWS_BY_SECTION = 2;
const int TICKET_SALES_BY_SECTION = 3;
const int MOVIE_DETAILS_BY_SECTION = 4;
const int GEOLOCATION_SERVICES_BY_SECTION = 5;
const int DVD_DETAILS_BY_SECTION = 6;


@synthesize localizers;

- (void) dealloc {
    self.localizers = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = NSLocalizedString(@"About", nil);

        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@"Allan Lund Jensen"  forKey:@"da"];
        [dictionary setObject:@"Patrick Boch"       forKey:@"de"];
        [dictionary setObject:@"Jorge Herskovic"    forKey:@"es"];
        [dictionary setObject:@"J-P. Helisten"      forKey:@"fi"];
        [dictionary setObject:@"Jonathan Grenier"   forKey:@"fr"];
        [dictionary setObject:@"Santiago Navonne"   forKey:@"it"];
        [dictionary setObject:@"Leo Yamamoto"       forKey:@"ja"];
        [dictionary setObject:@"André van Haren"    forKey:@"nl"];
        [dictionary setObject:@"Eivind Samseth"     forKey:@"no"];
        [dictionary setObject:@"Marek Wieczorek"    forKey:@"pl"];
        [dictionary setObject:@"Pedro Pinhão"       forKey:@"pt"];
        [dictionary setObject:@"Oğuz Taş"           forKey:@"tr"];
        self.localizers = dictionary;
    }

    return self;
}


- (void) refresh {
    [self.tableView reloadData];
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 9;
}


- (NSInteger)       tableView:(UITableView*) table
        numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 2;
    } else if (section == 3) {
        return 1;
    } else if (section == 4) {
        return 1;
    } else if (section == 5) {
        return 3;
    } else if (section == 6) {
        return 1;
    } else if (section == 7) {
        return localizers.count;
    } else if (section == 8) {
        return 1;
    }

    return 1;
}


- (UIImage*) getImage:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 2) {
        if (row == 0) {
            return [UIImage imageNamed:@"RottenTomatoesLogo.png"];
        } else if (row == 1) {
            return [UIImage imageNamed:@"MetacriticLogo.png"];
        }
    } else if (section == 3) {
        return [UIImage imageNamed:@"FandangoLogo.png"];
    } else if (section == 4) {
        return [UIImage imageNamed:@"TryntLogo.png"];
    } else if (section == 5) {
        if (row == 0) {
            return [UIImage imageNamed:@"YahooLogo.png"];
        }
    } else if (section == 7) {
        return [UIImage imageNamed:@"VideoETALogo.png"];
    }

    return nil;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    UIImage* image = [self getImage:indexPath];
    CGFloat height = tableView.rowHeight;
    if (image != nil) {
        CGFloat imageHeight = image.size.height + 10;
        if (imageHeight > height) {
            height = imageHeight;
        }
    }

    return height;
}


NSComparisonResult compareLanguageCodes(id code1, id code2, void* context) {
    NSString* language1 = [LocaleUtilities displayLanguage:code1];
    NSString* language2 = [LocaleUtilities displayLanguage:code2];

    return [language1 compare:language2];
}


- (UITableViewCell*) localizationCellForRow:(NSInteger) row {
    SettingCell* cell = [[[SettingCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString* code = [[localizers.allKeys sortedArrayUsingFunction:compareLanguageCodes context:NULL] objectAtIndex:row];
    NSString* person = [localizers objectForKey:code];
    NSString* language = [LocaleUtilities displayLanguage:code];

    [cell setKey:language value:person];
    return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 7) {
        return [self localizationCellForRow:row];
    }

    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIImage* image = [self getImage:indexPath];

    if (image != nil) {
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];

        NSInteger x = (self.tableView.contentSize.width - image.size.width) / 2 - 20;
        NSInteger y = ([self tableView:tableView heightForRowAtIndexPath:indexPath] - image.size.height) / 2;

        imageView.frame = CGRectMake(x, y, image.size.width, image.size.height);

        [cell.contentView addSubview:imageView];
    } else if (section == 0) {
        if (row == 0) {
            cell.text = NSLocalizedString(@"E-mail", @"This is a very.  it means 'send email to developer'");
        } else {
            cell.text = NSLocalizedString(@"Project website", nil);
        }
    } else if (section == 1) {
        if (row == 0) {
            cell.text = NSLocalizedString(@"E-mail", @"This is a very.  it means 'send email to developer'");
        } else {
            cell.text = NSLocalizedString(@"Website", nil);
        }
    } else if (section == 5) {
        if (row == 1) {
            cell.text = @"GeoNames";
        } else if (row == 2) {
            cell.text = @"GeoCoder.ca";
        }
    } else if (section == 8) {
        cell.text = NSLocalizedString(@"License", nil);
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    return cell;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"Written by Cyrus Najmabadi", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"Graphics by Jeffrey Nee", nil);
    } else if (section == 2) {
        return NSLocalizedString(@"Movie reviews provided by:", nil);
    } else if (section == 3) {
        return NSLocalizedString(@"Ticket sales provided by:", nil);
    } else if (section == 4) {
        return NSLocalizedString(@"Movie details provided by:", nil);
    } else if (section == 5) {
        return NSLocalizedString(@"Geolocation services provided by:", nil);
    } else if (section == 6) {
        return NSLocalizedString(@"DVD/Blu-ray details provided by:", nil);
    } else if (section == 7) {
        return NSLocalizedString(@"Localized by:", nil);
    }

    return nil;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
    if (section == 8) {
        return @"All Rotten Tomatoes content is used under license from Rotten Tomatoes. Rotten Tomatoes, Certified Fresh and the Tomatometer are the trademarks of Incfusion Corporation, d/b/a Rotten Tomatoes, a subsidiary of IGN Entertainment, Inc.";
    }

    return nil;
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section >= 0 && indexPath.section <= 6) {
        return UITableViewCellAccessoryDetailDisclosureButton;
    } else if (indexPath.section == 7) {
        return UITableViewCellAccessoryNone;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}


- (void) licenseCellTapped {
    UIViewController* controller = [[[UIViewController alloc] init] autorelease];
    controller.title = NSLocalizedString(@"License", nil);

    UITextView* textView = [[[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    textView.editable = NO;
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    NSString* licensePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"License.txt"];
    textView.text = [NSString stringWithContentsOfFile:licensePath];
    textView.font = [UIFont boldSystemFontOfSize:12];
    textView.textColor = [UIColor grayColor];

    [controller.view addSubview:textView];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 7) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else if (indexPath.section == 8) {
        [self licenseCellTapped];
    }
}


- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    NSString* url = nil;
    if (section == 0) {
        if (row == 0) {
            url = @"mailto:cyrus.najmabadi@gmail.com?subject=Now%20Playing";
        } else {
            url = @"http://metasyntactic.googlecode.com";
        }
    } else if (section == 1) {
        if (row == 0) {
            url = @"mailto:jeff@jeffnee.com";
        } else {
            url = @"http://www.jeffnee.com";
        }
    } else if (section == 2) {
        if (row == 0) {
            url = @"http://www.rottentomatoes.com";
        } else {
            url = @"http://www.metacritic.com";
        }
    } else if (section == 3) {
        url = @"http://www.fandango.com";
    } else if (section == 4) {
        url = @"http://www.trynt.com";
    } else if (section == 5) {
        if (row == 0) {
            url = @"http://www.yahoo.com";
        } else if (row == 1) {
            url = @"http://www.geonames.org";
        } else {
            url = @"http://geocoder.ca";
        }
    } else if (section == 6) {
        url = @"http://www.videoeta.com";
    } else if (section == 7) {
        return;
    } else if (section == 8) {
        return;
    }

    [Application openBrowser:url];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self refresh];
}


@end