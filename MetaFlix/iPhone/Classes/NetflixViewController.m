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
#import "AutoResizingCell.h"
#import "ColorCache.h"
#import "CreditsViewController.h"
#import "GlobalActivityIndicator.h"
#import "MutableNetflixCache.h"
#import "NetflixFeedsViewController.h"
#import "NetflixLoginViewController.h"
#import "NetflixNavigationController.h"
#import "NetflixRecommendationsViewController.h"
#import "NetflixQueueViewController.h"
#import "NetflixSearchViewController.h"
#import "MetaFlixModel.h"
#import "Queue.h"

@interface NetflixViewController()
@property (assign) NetflixNavigationController* navigationController;
@property (retain) NetflixSearchViewController* searchViewController;
@end


@implementation NetflixViewController

const NSInteger ROW_HEIGHT = 46;

typedef enum {
    SearchSection,
    DVDSection,
    InstantSection,
    RecommendationsSection,
    AtHomeSection,
    RentalHistorySection,
    AboutSendFeedbackSection,
    LogOutSection,
    OverQuotaSection,
} Sections;

@synthesize navigationController;
@synthesize searchViewController;

- (void) dealloc {
    self.navigationController = nil;
    self.searchViewController = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(NetflixNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.title = NSLocalizedString(@"MetaFlix", nil);

        self.tableView.rowHeight = ROW_HEIGHT;
    }
    return self;
}


- (MetaFlixModel*) model {
    return navigationController.model;
}


- (MetaFlixController*) controller {
    return navigationController.controller;
}


- (BOOL) hasAccount {
    return self.model.netflixUserId.length > 0;
}


- (void) majorRefreshWorker {
    self.tableView.rowHeight = ROW_HEIGHT;
    self.tableView.backgroundColor = [ColorCache netflixRed];

    [self.tableView reloadData];
}


- (void) minorRefreshWorker {
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    [self majorRefresh];
}


- (void) viewDidAppear:(BOOL) animated {
    visible = YES;
}


- (void) viewDidDisappear:(BOOL) animated {
    visible = NO;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return YES;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    return 8;
}


- (NetflixCache*) netflixCache {
    return self.model.netflixCache;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    AutoResizingCell* cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero] autorelease];
    cell.label.backgroundColor = [UIColor clearColor];
    cell.label.textColor = [UIColor whiteColor];
    cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NetflixChevron.png"]] autorelease];

    NSInteger row = indexPath.row;
    if (self.hasAccount) {
        if (row == SearchSection) {
            cell.text = NSLocalizedString(@"Search", nil);
            cell.image = [UIImage imageNamed:@"NetflixSearch.png"];
        } else if (row == DVDSection) {
            cell.text = [self.netflixCache titleForKey:[NetflixCache dvdQueueKey]];
            cell.image = [UIImage imageNamed:@"NetflixDVDQueue.png"];
        } else if (row == InstantSection) {
            cell.text = [self.netflixCache titleForKey:[NetflixCache instantQueueKey]];
            cell.image = [UIImage imageNamed:@"NetflixInstantQueue.png"];
        } else if (row == RecommendationsSection) {
            cell.text = [self.netflixCache titleForKey:[NetflixCache recommendationKey]];
            cell.image = [UIImage imageNamed:@"NetflixRecommendations.png"];
        } else if (row == AtHomeSection) {
            cell.text = [self.netflixCache titleForKey:[NetflixCache atHomeKey]];
            cell.image = [UIImage imageNamed:@"NetflixHome.png"];
        } else if (row == RentalHistorySection) {
            cell.text = NSLocalizedString(@"Rental History", nil);
            cell.image = [UIImage imageNamed:@"NetflixHistory.png"];
        } else if (row == AboutSendFeedbackSection) {
            cell.text = NSLocalizedString(@"About / Send Feedback", nil);        
        } else if (row == LogOutSection) {
            cell.text = NSLocalizedString(@"Log Out of Netflix", nil);
            cell.image = [UIImage imageNamed:@"NetflixLogOff.png"];
            cell.textColor = [ColorCache commandColor];
            cell.accessoryView = nil;
        } else if (row == OverQuotaSection) {
            if (self.model.netflixCache.lastQuotaErrorDate != nil &&
                self.model.netflixCache.lastQuotaErrorDate.timeIntervalSinceNow < (5 * ONE_MINUTE)) {
                cell.text = NSLocalizedString(@"Over Quota - Try Again Later", nil);
                cell.accessoryView = nil;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    } else {
        if (indexPath.row == 0) {
            cell.text = NSLocalizedString(@"Log In to Netflix", nil);
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
                                                             feedKeys:keys] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (void) didSelectSearchRow {
    if (searchViewController == nil) {
        self.searchViewController =
        [[[NetflixSearchViewController alloc] initWithNavigationController:navigationController] autorelease];
    }

    [navigationController pushViewController:searchViewController animated:YES];
}


- (void) didSelectRecomendationsRow {
    NetflixRecommendationsViewController* controller = [[[NetflixRecommendationsViewController alloc] initWithNavigationController:navigationController] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (void) didSelectAboutSendFeedbackRow {
    CreditsViewController* controller = [[[CreditsViewController alloc] initWithModel:self.model] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (void) didSelectLoggedInRow:(NSInteger) row {
    if (row == SearchSection) {
        [self didSelectSearchRow];
    } else if (row == DVDSection) {
        [self didSelectQueueRow:[NetflixCache dvdQueueKey]];
    } else if (row == InstantSection) {
        [self didSelectQueueRow:[NetflixCache instantQueueKey]];
    } else if (row == RecommendationsSection) {
        [self didSelectRecomendationsRow];
    } else if (row == AtHomeSection) {
        [self didSelectQueueRow:[NetflixCache atHomeKey]];
    } else if (row == RentalHistorySection) {
        [self didSelectRentalHistoryRow];
    } else if (row == AboutSendFeedbackSection) {
        [self didSelectAboutSendFeedbackRow];
    } else if (row == LogOutSection) {
        [self didSelectLogoutRow];
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    if (self.hasAccount) {
        [self didSelectLoggedInRow:indexPath.row];
    } else {
        if (indexPath.row == 0) {
            NetflixLoginViewController* controller = [[[NetflixLoginViewController alloc] initWithNavigationController:navigationController] autorelease];
            [navigationController pushViewController:controller animated:YES];
        }
    }
}

@end