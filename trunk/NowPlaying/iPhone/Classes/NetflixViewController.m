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

#import "AutoResizingCell.h"
#import "ColorCache.h"
#import "GlobalActivityIndicator.h"
#import "NetflixCache.h"
#import "NetflixFeedsViewController.h"
#import "NetflixLoginViewController.h"
#import "NetflixNavigationController.h"
#import "NetflixQueueViewController.h"
#import "NetflixSearchViewController.h"
#import "NowPlayingModel.h"
#import "Queue.h"

@interface NetflixViewController()
@property (assign) NetflixNavigationController* navigationController;
@property (retain) NetflixSearchViewController* searchViewController;
@end


@implementation NetflixViewController

typedef enum {
    SearchSection,
    BrowseSection,
    DVDSection,
    InstantSection,
    RecommendationsSection,
    AtHomeSection,
    RentalHistorySection,
    LogOutSection,
    LastSection = LogOutSection
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
        self.title = NSLocalizedString(@"Netflix", nil);

        self.tableView.rowHeight = 41;
        self.tableView.backgroundColor = [ColorCache netflixRed];
    }
    return self;
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (BOOL) hasAccount {
    return self.model.netflixUserId.length > 0;
}


- (void) majorRefresh {
    self.tableView.rowHeight = 41;
    if ([self.tableView numberOfRowsInSection:0] == 1 &&
        self.hasAccount) {
        [self.tableView beginUpdates];
        {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
        }
        [self.tableView endUpdates];
    } else {
        [self.tableView reloadData];
    }
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
}


- (void) viewDidAppear:(BOOL)animated {
    [self majorRefresh];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return YES;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    return 9;
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
        } else if (row == BrowseSection) {
            cell.text = NSLocalizedString(@"Browse", nil);
            cell.image = [UIImage imageNamed:@"NetflixBrowse.png"];
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
        } else if (row == LogOutSection) {
            cell.text = NSLocalizedString(@"Log Out of Netflix", nil);
            cell.image = [UIImage imageNamed:@"NetflixLogOff.png"];
            cell.textColor = [ColorCache commandColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
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
        
        [self.tableView beginUpdates];
        {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
        }
        [self.tableView endUpdates];
    }
}


- (void) didSelectQueuesRow {
    NetflixFeedsViewController* controller = [[[NetflixFeedsViewController alloc] initWithNavigationController:navigationController] autorelease];
    [navigationController pushViewController:controller animated:YES];
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


- (void) didSelectLoggedInRow:(NSInteger) row {
    if (row == SearchSection) {
        [self didSelectSearchRow];
    } else if (row == DVDSection) {
        [self didSelectQueueRow:[NetflixCache dvdQueueKey]];
    } else if (row == InstantSection) {
        [self didSelectQueueRow:[NetflixCache instantQueueKey]];
    } else if (row == RecommendationsSection) {
        [self didSelectQueueRow:[NetflixCache recommendationKey]];
    } else if (row == AtHomeSection) {
        [self didSelectQueueRow:[NetflixCache atHomeKey]];
    } else if (row == RentalHistorySection) {
        [self didSelectRentalHistoryRow];
    } else if (row == LogOutSection) {
        [self didSelectLogoutRow];
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasAccount) {
        [self didSelectLoggedInRow:indexPath.row];
    } else {
        if (indexPath.row == 0) {
            NetflixLoginViewController* controller = [[[NetflixLoginViewController alloc] initWithNavigationController:navigationController] autorelease];
            [navigationController pushViewController:controller animated:YES];
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

@end