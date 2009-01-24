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
#import "Model.h"
#import "SettingCell.h"

@interface CreditsViewController()
@property (retain) Model* model;
@property (retain) NSArray* languages;
@property (retain) NSDictionary* localizers;
@end


@implementation CreditsViewController

typedef enum {
    WrittenBySection,
    MyOtherApplicationsSection,
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
@synthesize languages;
@synthesize localizers;

- (void) dealloc {
    self.model = nil;
    self.languages = nil;
    self.localizers = nil;

    [super dealloc];
}


NSComparisonResult compareLanguageCodes(id code1, id code2, void* context) {
    NSString* language1 = [LocaleUtilities displayLanguage:code1];
    NSString* language2 = [LocaleUtilities displayLanguage:code2];

    return [language1 compare:language2];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.model = model_;
        self.title = NSLocalizedString(@"About", nil);

        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@"Michal Štoppl"      forKey:@"cs"];
        [dictionary setObject:@"Allan Lund Jensen"  forKey:@"da"];
        [dictionary setObject:@"Patrick Boch"       forKey:@"de"];
        [dictionary setObject:@"Jorge Herskovic"    forKey:@"es"];
        [dictionary setObject:@"J-P. Helisten"      forKey:@"fi"];
        [dictionary setObject:@"Jonathan Grenier"   forKey:@"fr"];
        [dictionary setObject:@"Dani Valevski"      forKey:@"he"];
        [dictionary setObject:@"Megha Joshi"        forKey:@"hi"];
        [dictionary setObject:@"Horvath István"     forKey:@"hu"];
        [dictionary setObject:@"Santiago Navonne"   forKey:@"it"];
        [dictionary setObject:@"Leo Yamamoto"       forKey:@"ja"];
        [dictionary setObject:@"André van Haren"    forKey:@"nl"];
        [dictionary setObject:@"Eivind Samseth"     forKey:@"no"];
        [dictionary setObject:@"Marek Wieczorek"    forKey:@"pl"];
        [dictionary setObject:@"Pedro Pinhão"       forKey:@"pt"];
        [dictionary setObject:@"Marius Andrei"      forKey:@"ro"];
        [dictionary setObject:@"Aleksey Surkov"     forKey:@"ru"];
        [dictionary setObject:@"Ján Senko"          forKey:@"sk"];
        [dictionary setObject:@"Oğuz Taş"           forKey:@"tr"];
        self.localizers = dictionary;

        self.languages = [localizers.allKeys sortedArrayUsingFunction:compareLanguageCodes context:NULL];
    }

    return self;
}


- (void) majorRefresh {
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
        return 3;
    } else if (section == MyOtherApplicationsSection) {
        return 3;
    } else if (section == GraphicsBySection) {
        return 1;
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
    } else if (indexPath.section == LocalizedBySection) {
        return tableView.rowHeight - 14;
    }

    return height;
}


- (UITableViewCell*) localizationCellForRow:(NSInteger) row {
    static NSString* reuseIdentifier = @"reuseIdentifier";
    SettingCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[SettingCell alloc] initWithFrame:CGRectZero
                                   reuseIdentifier:reuseIdentifier] autorelease];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString* code = [languages objectAtIndex:row];
    NSString* person = [localizers objectForKey:code];
    NSString* language = [LocaleUtilities displayLanguage:code];

    [cell setKey:language value:person hideSeparator:(row != 0)];
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
            cell.text = NSLocalizedString(@"Send Feedback", nil);
        } else if (row == 1) {
            cell.text = NSLocalizedString(@"Project website", nil);
        } else {
            cell.text = NSLocalizedString(@"Write Review", nil);
        }
    } else if (section == MyOtherApplicationsSection) {
        if (row == 0) {
            cell.text = @"ComiXology ($3.99)";
        } else if (row == 1) {
            cell.text = @"PocketFlix ($1.99)";
        } else {
            cell.text = @"Your Rights (free)";
        }
    } else if (section == GraphicsBySection) {
        cell.text = NSLocalizedString(@"Website", nil);
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
    } else if (section == MyOtherApplicationsSection) {
        return NSLocalizedString(@"My other applications", nil);
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
    if (section == WrittenBySection) {
        return
        [NSString stringWithFormat:NSLocalizedString(@"If you like %@, please consider writing a small review for the iTunes store. It will help new users discover this app, increase my ability to bring you great new features, and will also make me feel warm and fuzzy inside. Thanks!", nil), [Application name]];
    }  else if (section == LastSection) {
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
        } else if (row == 1) {
            url = @"http://metasyntactic.googlecode.com";
        } else {
            url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=284939567&mt=8";
        }
    } else if (section == MyOtherApplicationsSection) {
        if (row == 0) {
            url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=297414943&mt=8";
        } else if (row == 1) {
            url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=301386724&mt=8";
        } else {
            url = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=301494200&mt=8";
        }
    } else if (section == GraphicsBySection) {
        url = @"http://www.jeffnee.com";
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
    [self majorRefresh];
}

@end