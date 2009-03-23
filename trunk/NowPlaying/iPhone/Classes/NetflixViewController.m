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

#import "NetflixViewController.h"

#import "AbstractNavigationController.h"
#import "AppDelegate.h"
#import "Application.h"
#import "AutoresizingCell.h"
#import "ColorCache.h"
#import "GlobalActivityIndicator.h"
#import "Model.h"
#import "MutableNetflixCache.h"
#import "NetflixFeedsViewController.h"
#import "NetflixLoginViewController.h"
#import "NetflixMostPopularViewController.h"
#import "NetflixNavigationController.h"
#import "NetflixQueueViewController.h"
#import "NetflixRecommendationsViewController.h"
#import "NetflixSearchDisplayController.h"
#import "Queue.h"
#import "SettingsViewController.h"
#import "ViewControllerUtilities.h"

@interface NetflixViewController()
@property (retain) UISearchBar* searchBar;
@property (retain) NetflixSearchDisplayController* searchDisplayController;
@end


@implementation NetflixViewController

const NSInteger ROW_HEIGHT = 46;

typedef enum {
    MostPopularSection,
    DVDSection,
    InstantSection,
    RecommendationsSection,
    AtHomeSection,
    RentalHistorySection,
    LogOutSection,
} Sections;

@synthesize searchBar;
@synthesize searchDisplayController;

- (void) dealloc {
    self.searchBar = nil;
    self.searchDisplayController = nil;

    [super dealloc];
}


- (void) setupTableStyle {
    self.tableView.rowHeight = ROW_HEIGHT;
}


- (id) initWithNavigationController:(NetflixNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain navigationController:navigationController_]) {
        self.title = NSLocalizedString(@"Netflix", nil);
    }

    return self;
}


- (void) initializeSearchDisplay {
    self.searchBar = [[[UISearchBar alloc] init] autorelease];
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
    
    self.searchDisplayController = [[[NetflixSearchDisplayController alloc] initNavigationController:navigationController searchBar:searchBar contentsController:self] autorelease];
}


- (void) loadView {
    [super loadView];
    
    [self initializeSearchDisplay];
}


- (BOOL) hasAccount {
    return self.model.netflixUserId.length > 0;
}


- (void) setupTitle {
    if (self.model.netflixCache.lastQuotaErrorDate != nil &&
        self.model.netflixCache.lastQuotaErrorDate.timeIntervalSinceNow < (5 * ONE_MINUTE)) {
        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = NSLocalizedString(@"Over Quota - Try Again Later", nil);
        self.navigationItem.titleView = label;
    } else {
        self.navigationItem.titleView = nil;
    }
}


- (void) determinePopularMovieCount {
    NSInteger result = 0;
    for (NSString* title in [NetflixCache mostPopularTitles]) {
        NSInteger count = [self.model.netflixCache movieCountForRSSTitle:title];
        result += count;
    }

    mostPopularTitleCount = result;
}


- (void) initializeInfoButton {
    UIButton* infoButton = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];

    infoButton.contentMode = UIViewContentModeCenter;
    CGRect frame = infoButton.frame;
    frame.size.width += 4;
    infoButton.frame = frame;
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}


- (void) majorRefreshWorker {
    [self initializeInfoButton];
    [self setupTableStyle];
    [self setupTitle];
    [self determinePopularMovieCount];
    [self reloadTableViewData];
}


- (void) minorRefreshWorker {
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[AppDelegate globalActivityView]] autorelease];
    [self majorRefresh];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }

    return self.model.screenRotationEnabled;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    if (self.hasAccount) {
        return 7;
    } else {
        return 2;
    }
}


- (NetflixCache*) netflixCache {
    return self.model.netflixCache;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"reuseIdentifier";
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;

    NSInteger row = indexPath.row;
    if (self.hasAccount) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        switch (row) {
            case MostPopularSection:
                if (mostPopularTitleCount == 0) {
                    cell.text = NSLocalizedString(@"Most Popular", nil);
                } else {
                    cell.text = [NSString stringWithFormat:NSLocalizedString(@"%@ (%@)", nil), NSLocalizedString(@"Most Popular", nil), [NSNumber numberWithInteger:mostPopularTitleCount]];
                }
                break;
            case DVDSection:
                cell.text = [self.netflixCache titleForKey:[NetflixCache dvdQueueKey]];
                break;
            case InstantSection:
                cell.text = [self.netflixCache titleForKey:[NetflixCache instantQueueKey]];
                break;
            case RecommendationsSection:
                cell.text = [self.netflixCache titleForKey:[NetflixCache recommendationKey]];
                break;
            case AtHomeSection:
                cell.text = [self.netflixCache titleForKey:[NetflixCache atHomeKey]];
                break;
            case RentalHistorySection:
                cell.text = NSLocalizedString(@"Rental History", nil);
                break;
            case LogOutSection:
                cell.text = NSLocalizedString(@"Log Out of Netflix", nil);
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
        }
    } else {
        if (indexPath.row == 0) {
            cell.text = NSLocalizedString(@"Sign Up for New Account", nil);
        } else if (indexPath.row == 1) {
            cell.text = NSLocalizedString(@"Log In to Existing Account", nil);
        }
    }

    return cell;
}


- (void) didSelectLogoutRow {
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                     message:NSLocalizedString(@"Really log out of Netflix?", nil)
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"No", nil)
                                           otherButtonTitles:NSLocalizedString(@"Yes", nil), nil] autorelease];

    alert.delegate = self;
    [alert show];
}


- (void)         alertView:(UIAlertView*) alertView
      clickedButtonAtIndex:(NSInteger) index {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    if (index != alertView.cancelButtonIndex) {
        [self.controller setNetflixKey:nil secret:nil userId:nil];
        [Application resetNetflixDirectories];

        [self majorRefresh];
    }
}


- (void) didSelectQueueRow:(NSString*) key {
    NetflixQueueViewController* controller =
    [[[NetflixQueueViewController alloc] initWithNavigationController:navigationController
                                                              feedKey:key] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (void) didSelectRentalHistoryRow {
    NSArray* keys =
    [NSArray arrayWithObjects:
     [NetflixCache rentalHistoryKey],
     [NetflixCache rentalHistoryWatchedKey],
     [NetflixCache rentalHistoryReturnedKey], nil];

    NetflixFeedsViewController* controller =
    [[[NetflixFeedsViewController alloc] initWithNavigationController:navigationController
                                                             feedKeys:keys
                                                                title:NSLocalizedString(@"Rental History", nil)] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (void) didSelectRecomendationsRow {
    NetflixRecommendationsViewController* controller = [[[NetflixRecommendationsViewController alloc] initWithNavigationController:navigationController] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (void) didSelectMostPopularSection {
    NetflixMostPopularViewController* controller = [[[NetflixMostPopularViewController alloc] initWithNavigationController:navigationController] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (void) didSelectLoggedInRow:(NSInteger) row {
    switch (row) {
        case MostPopularSection:        return [self didSelectMostPopularSection];
        case DVDSection:                return [self didSelectQueueRow:[NetflixCache dvdQueueKey]];
        case InstantSection:            return [self didSelectQueueRow:[NetflixCache instantQueueKey]];
        case RecommendationsSection:    return [self didSelectRecomendationsRow];
        case AtHomeSection:             return [self didSelectQueueRow:[NetflixCache atHomeKey]];
        case RentalHistorySection:      return [self didSelectRentalHistoryRow];
        case LogOutSection:             return [self didSelectLogoutRow];
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (self.hasAccount) {
        [self didSelectLoggedInRow:indexPath.row];
    } else {
        if (indexPath.row == 0) {
            NSString* address = @"http://click.linksynergy.com/fs-bin/click?id=eOCwggduPKg&offerid=161458.10000264&type=3&subid=0";
            [Application openBrowser:address];
        } else if (indexPath.row == 1) {
            NetflixLoginViewController* controller = [[[NetflixLoginViewController alloc] initWithNavigationController:navigationController] autorelease];
            [navigationController pushViewController:controller animated:YES];
        }
    }
}


- (void) showInfo {
    [navigationController pushInfoControllerAnimated:YES];
}

@end