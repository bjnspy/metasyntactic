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
#import "NowPlayingModel.h"
#import "SettingCell.h"

@implementation CreditsViewController

typedef enum {
    WrittenBySection,
    GraphicsBySection,
    ReviewsBySection,
    TicketSalesBySection,
    MovieDetailsBySection,
    GeolocationServicesBySection,
    DVDDetailsBySection,
    LocalizedBySection,
    LicenseSection,
    LastSection = LicenseSection
} CreditsSection;

@synthesize model;
@synthesize localizers;

- (void) dealloc {
    self.model = nil;
    self.localizers = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.model = model_;
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
        [dictionary setObject:@"Marius Andrei"      forKey:@"ro"];
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
    return LastSection + 1;
}


- (NSInteger)       tableView:(UITableView*) table
        numberOfRowsInSection:(NSInteger) section {
    if (section == WrittenBySection) {
        return 2;
    } else if (section == GraphicsBySection) {
        return 2;
    } else if (section == ReviewsBySection) {
        return 2;
    } else if (section == TicketSalesBySection) {
        return 1;
    } else if (section == MovieDetailsBySection) {
        return 1;
    } else if (section == GeolocationServicesBySection) {
        return 3;
    } else if (section == DVDDetailsBySection) {
        return 1;
    } else if (section == LocalizedBySection) {
        return localizers.count;
    } else if (section == LicenseSection) {
        return 1;
    }

    return 0;
}


- (UIImage*) getImage:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == ReviewsBySection) {
        if (row == 0) {
            return [UIImage imageNamed:@"RottenTomatoesLogo.png"];
        } else if (row == 1) {
            return [UIImage imageNamed:@"MetacriticLogo.png"];
        }
    } else if (section == TicketSalesBySection) {
        return [UIImage imageNamed:@"FandangoLogo.png"];
    } else if (section == MovieDetailsBySection) {
        return [UIImage imageNamed:@"TryntLogo.png"];
    } else if (section == GeolocationServicesBySection) {
        if (row == 0) {
            return [UIImage imageNamed:@"YahooLogo.png"];
        }
    } else if (section == DVDDetailsBySection) {
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

    if (section == LocalizedBySection) {
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
    } else if (section == WrittenBySection) {
        if (row == 0) {
            cell.text = NSLocalizedString(@"E-mail", @"This is a verb.  it means 'send email to developer'");
        } else {
            cell.text = NSLocalizedString(@"Project website", nil);
        }
    } else if (section == GraphicsBySection) {
        if (row == 0) {
            cell.text = NSLocalizedString(@"E-mail", @"This is a verb.  it means 'send email to developer'");
        } else {
            cell.text = NSLocalizedString(@"Website", nil);
        }
    } else if (section == GeolocationServicesBySection) {
        if (row == 1) {
            cell.text = @"GeoNames";
        } else if (row == 2) {
            cell.text = @"GeoCoder.ca";
        }
    } else if (section == LicenseSection) {
        cell.text = NSLocalizedString(@"License", nil);
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    return cell;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == WrittenBySection) {
        return NSLocalizedString(@"Written by Cyrus Najmabadi", nil);
    } else if (section == GraphicsBySection) {
        return NSLocalizedString(@"Graphics by Jeffrey Nee", nil);
    } else if (section == ReviewsBySection) {
        return NSLocalizedString(@"Movie reviews provided by:", nil);
    } else if (section == TicketSalesBySection) {
        return NSLocalizedString(@"Ticket sales provided by:", nil);
    } else if (section == MovieDetailsBySection) {
        return NSLocalizedString(@"Movie details provided by:", nil);
    } else if (section == GeolocationServicesBySection) {
        return NSLocalizedString(@"Geolocation services provided by:", nil);
    } else if (section == DVDDetailsBySection) {
        return NSLocalizedString(@"DVD/Blu-ray details provided by:", nil);
    } else if (section == LocalizedBySection) {
        return NSLocalizedString(@"Localized by:", nil);
    }

    return nil;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
    if (section == LastSection) {
        return @"All Rotten Tomatoes content is used under license from Rotten Tomatoes. Rotten Tomatoes, Certified Fresh and the Tomatometer are the trademarks of Incfusion Corporation, d/b/a Rotten Tomatoes, a subsidiary of IGN Entertainment, Inc.";
    }

    return nil;
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section >= WrittenBySection && indexPath.section <= DVDDetailsBySection) {
        return UITableViewCellAccessoryDetailDisclosureButton;
    } else if (indexPath.section == LocalizedBySection) {
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
    if (indexPath.section == LocalizedBySection) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else if (indexPath.section == LicenseSection) {
        [self licenseCellTapped];
    }
}


- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    NSString* url = nil;
    if (section == WrittenBySection) {
        if (row == 0) {
            url = [self.model feedbackUrl];
        } else {
            url = @"http://metasyntactic.googlecode.com";
        }
    } else if (section == GraphicsBySection) {
        if (row == 0) {
            url = @"mailto:jeff@jeffnee.com";
        } else {
            url = @"http://www.jeffnee.com";
        }
    } else if (section == ReviewsBySection) {
        if (row == 0) {
            url = @"http://www.rottentomatoes.com";
        } else {
            url = @"http://www.metacritic.com";
        }
    } else if (section == TicketSalesBySection) {
        url = @"http://www.fandango.com";
    } else if (section == MovieDetailsBySection) {
        url = @"http://www.trynt.com";
    } else if (section == GeolocationServicesBySection) {
        if (row == 0) {
            url = @"http://www.yahoo.com";
        } else if (row == 1) {
            url = @"http://www.geonames.org";
        } else {
            url = @"http://geocoder.ca";
        }
    } else if (section == DVDDetailsBySection) {
        url = @"http://www.videoeta.com";
    } else if (section == LocalizedBySection) {
        return;
    } else if (section == LicenseSection) {
        return;
    }

    [Application openBrowser:url];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self refresh];
}

@end