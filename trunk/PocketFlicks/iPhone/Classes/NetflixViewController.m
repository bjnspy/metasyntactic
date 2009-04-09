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

#import "Application.h"
#import "Controller.h"
#import "Model.h"
#import "MutableNetflixCache.h"
#import "NetflixFeedsViewController.h"
#import "NetflixLoginViewController.h"
#import "NetflixMostPopularViewController.h"
#import "NetflixNavigationController.h"
#import "NetflixQueueViewController.h"
#import "NetflixRecommendationsViewController.h"
#import "NetflixSearchDisplayController.h"
#import "NetflixSearchViewController.h"
#import "ViewControllerUtilities.h"

#ifndef IPHONE_OS_VERSION_3
#endif

@interface NetflixViewController()
#ifdef IPHONE_OS_VERSION_3
@property (retain) UISearchBar* searchBar;
@property (retain) NetflixSearchDisplayController* searchDisplayController;
#else
@property (retain) NetflixSearchViewController* searchViewController;
#endif
@end


@implementation NetflixViewController

const NSInteger ROW_HEIGHT = 46;

typedef enum {
#ifndef IPHONE_OS_VERSION_3
    SearchSection,
#endif
    MostPopularSection,
    DVDSection,
    InstantSection,
    RecommendationsSection,
    AtHomeSection,
    RentalHistorySection,
    AboutSendFeedbackSection,
    LogOutSection,
} Sections;

#ifdef IPHONE_OS_VERSION_3
@synthesize searchBar;
@synthesize searchDisplayController;
#else
@synthesize searchViewController;
#endif

- (void) dealloc {
#ifdef IPHONE_OS_VERSION_3
    self.searchBar = nil;
    self.searchDisplayController = nil;
#else
    self.searchViewController = nil;
#endif
    [super dealloc];
}


- (void) setupTableStyle {
    self.tableView.rowHeight = ROW_HEIGHT;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [ColorCache netflixRed];
}


- (id) init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
       self.title = [Application name];

        [self setupTableStyle];
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (Controller*) controller {
    return [Controller controller];
}


- (void) initializeSearchDisplay {
#ifdef IPHONE_OS_VERSION_3
    self.searchBar = [[[UISearchBar alloc] init] autorelease];
    [searchBar sizeToFit];

    self.searchDisplayController = [[[NetflixSearchDisplayController alloc] initWithSearchBar:searchBar
                                                                           contentsController:self] autorelease];
#endif
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
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            NSInteger count = [self.model.netflixCache movieCountForRSSTitle:title];
            result += count;
        }
        [pool release];
    }

    mostPopularTitleCount = result;
}


- (void) majorRefreshWorker {
#ifdef IPHONE_OS_VERSION_3
    if (self.hasAccount) {
        self.tableView.tableHeaderView = searchBar;
    } else {
        self.tableView.tableHeaderView = nil;
    }
#endif
    [self setupTableStyle];
    [self setupTitle];
    [self determinePopularMovieCount];
    [self reloadTableViewData];

#ifdef IPHONE_OS_VERSION_3
    [searchDisplayController majorRefresh];
#endif
}


- (void) minorRefreshWorker {
#ifdef IPHONE_OS_VERSION_3
    [searchDisplayController minorRefresh];
#endif
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
    return 9;
}


- (NetflixCache*) netflixCache {
    return self.model.netflixCache;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger row = indexPath.row;
    AutoResizingCell* cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero] autorelease];

    cell.label.backgroundColor = [UIColor clearColor];
    cell.textColor = [UIColor whiteColor];
    cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NetflixChevron.png"]] autorelease];

    if (self.hasAccount) {
        switch (row) {
#ifndef IPHONE_OS_VERSION_3
            case SearchSection:
                cell.text = NSLocalizedString(@"Search", nil);
                cell.image = [UIImage imageNamed:@"NetflixSearch.png"];
                break;
#endif
            case MostPopularSection:
                if (mostPopularTitleCount == 0) {
                    cell.text = NSLocalizedString(@"Most Popular", nil);
                } else {
                    cell.text = [NSString stringWithFormat:NSLocalizedString(@"%@ (%@)", nil), NSLocalizedString(@"Most Popular", nil), [NSNumber numberWithInteger:mostPopularTitleCount]];
                }
                cell.image = [UIImage imageNamed:@"NetflixMostPopular.png"];
                break;
            case DVDSection:
cell.text = [self.netflixCache titleForKey:[NetflixCache dvdQueueKey]];
                cell.image = [UIImage imageNamed:@"NetflixDVDQueue.png"];
                break;
            case InstantSection:
cell.text = [self.netflixCache titleForKey:[NetflixCache instantQueueKey]];
                cell.image = [UIImage imageNamed:@"NetflixInstantQueue.png"];
                break;
            case RecommendationsSection:
cell.text = [self.netflixCache titleForKey:[NetflixCache recommendationKey]];
                cell.image = [UIImage imageNamed:@"NetflixRecommendations.png"];
                break;
            case AtHomeSection:
cell.text = [self.netflixCache titleForKey:[NetflixCache atHomeKey]];
                cell.image = [UIImage imageNamed:@"NetflixHome.png"];
                break;
            case RentalHistorySection:
                cell.text = NSLocalizedString(@"Rental History", nil);
                cell.image = [UIImage imageNamed:@"NetflixHistory.png"];
                break;
            case AboutSendFeedbackSection:
   cell.text = [NSString stringWithFormat:@"%@ / %@", NSLocalizedString(@"Send Feedback", nil), NSLocalizedString(@"Write Review", nil)];
                cell.image = [UIImage imageNamed:@"NetflixCredits.png"];
                break;
            case LogOutSection:
                cell.text = NSLocalizedString(@"Log Out of Netflix", nil);
                cell.image = [UIImage imageNamed:@"NetflixLogOff.png"];
                cell.accessoryView = nil;
                break;
        }
    } else {
        if (indexPath.row == 2) {
            cell.text = NSLocalizedString(@"Sign Up for New Account", nil);
            cell.image = [UIImage imageNamed:@"NetflixSettings.png"];
            cell.accessoryView = nil;
        } else if (indexPath.row == 1) {
            cell.text = NSLocalizedString(@"Send Feedback", nil);
            cell.image = [UIImage imageNamed:@"NetflixCredits.png"];
        } else if (indexPath.row == 0) {
            cell.text = NSLocalizedString(@"Log In to Existing Account", nil);
            cell.image = [UIImage imageNamed:@"NetflixLogOff.png"];
        }
    }

    if (cell.text.length == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = nil;
    }


    NSString* backgroundName = [NSString stringWithFormat:@"NetflixCellBackground-%d.png", row];
    NSString* selectedBackgroundName = [NSString stringWithFormat:@"NetflixCellSelectedBackground-%d.png", row];
    UIImageView* backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundName]] autorelease];
    UIImageView* selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:selectedBackgroundName]] autorelease];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cell.backgroundView = backgroundView;
    cell.selectedBackgroundView = selectedBackgroundView;

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
    [[[NetflixQueueViewController alloc] initWithFeedKey:key] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectRentalHistoryRow {
    NSArray* keys =
    [NSArray arrayWithObjects:
     [NetflixCache rentalHistoryKey],
     [NetflixCache rentalHistoryWatchedKey],
     [NetflixCache rentalHistoryReturnedKey],
     nil];

    NetflixFeedsViewController* controller =
    [[[NetflixFeedsViewController alloc] initWithFeedKeys:keys
                                                    title:NSLocalizedString(@"Rental History", nil)] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectRecomendationsRow {
    NetflixRecommendationsViewController* controller = [[[NetflixRecommendationsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectAboutSendFeedbackRow {
    CreditsViewController* controller = [[[CreditsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectSettingsRow {
    NetflixSettingsViewController* controller = [[[NetflixSettingsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectMostPopularSection {
    NetflixMostPopularViewController* controller = [[[NetflixMostPopularViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


#ifndef IPHONE_OS_VERSION_3
- (void) didSelectSearchSection {
    if (searchViewController == nil) {
        self.searchViewController = [[[NetflixSearchViewController alloc] init] autorelease];
    }

    [self.navigationController pushViewController:searchViewController animated:YES];
}
#endif


- (void) didSelectLoggedInRow:(NSInteger) row {
    switch (row) {
#ifndef IPHONE_OS_VERSION_3
        case SearchSection:             return [self didSelectSearchSection];
#endif
        case MostPopularSection:        return [self didSelectMostPopularSection];
        case DVDSection:                return [self didSelectQueueRow:[NetflixCache dvdQueueKey]];
        case InstantSection:            return [self didSelectQueueRow:[NetflixCache instantQueueKey]];
        case RecommendationsSection:    return [self didSelectRecomendationsRow];
        case AtHomeSection:             return [self didSelectQueueRow:[NetflixCache atHomeKey]];
        case RentalHistorySection:      return [self didSelectRentalHistoryRow];
        case AboutSendFeedbackSection:  return [self didSelectAboutSendFeedbackRow];
        case LogOutSection:             return [self didSelectLogoutRow];
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (self.hasAccount) {
        [self didSelectLoggedInRow:indexPath.row];
    } else {
        if (indexPath.row == 2) {
            NSString* address = @"http://click.linksynergy.com/fs-bin/click?id=eOCwggduPKg&offerid=161458.10000264&type=3&subid=0";
            [Application openBrowser:address];
        } else if (indexPath.row == 1) {
            CreditsViewController* controller = [[[CreditsViewController alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        } else if (indexPath.row == 0) {
            NetflixLoginViewController* controller = [[[NetflixLoginViewController alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}


- (void) showInfo {
    [self.abstractNavigationController pushInfoControllerAnimated:YES];
}

@end