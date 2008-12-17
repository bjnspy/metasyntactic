//
//  NetflixViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixViewController.h"

#import "ColorCache.h"
#import "GlobalActivityIndicator.h"
#import "NetflixCache.h"
#import "NetflixFeedsViewController.h"
#import "NetflixLoginViewController.h"
#import "NetflixNavigationController.h"
#import "NetflixQueueViewController.h"
#import "NowPlayingModel.h"

@interface NetflixViewController()
@property (assign) NetflixNavigationController* navigationController;
@end


@implementation NetflixViewController

@synthesize navigationController;

- (void) dealloc {
    self.navigationController = nil;
    [super dealloc];
}


- (id) initWithNavigationController:(NetflixNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.title = NSLocalizedString(@"Netflix", nil);
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
}


- (void) viewDidAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
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
    if (self.hasAccount) {
        return 6;
    } else {
        return 1;
    }
}


- (UITableViewCell*) cellForLoggedInRow:(NSInteger) row {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (row == 0) {
        cell.text = NSLocalizedString(@"Search", nil);
    } else if (row == 1) {
        cell.text = NSLocalizedString(@"Browse", nil);
    } else if (row == 2) {
        cell.text = NSLocalizedString(@"Queues", nil);
    } else if (row == 3) {
        cell.text = NSLocalizedString(@"Recommendations", nil);
    } else if (row == 4) {
        cell.text = NSLocalizedString(@"Rental History", nil);
    } else if (row == 5) {
        cell.text = NSLocalizedString(@"Tap to Log Out", nil);
        cell.textColor = [ColorCache commandColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (self.hasAccount) {
        return [self cellForLoggedInRow:indexPath.row];
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.text = NSLocalizedString(@"Tap to Log In", nil);
        cell.textColor = [ColorCache commandColor];
        return cell;
    }
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


- (void) didSelectRecommendationsRow {
    NetflixQueueViewController* controller =
    [[[NetflixQueueViewController alloc] initWithNavigationController:navigationController
                                                              feedKey:[NetflixCache recommendationKey]] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (void) didSelectLoggedInRow:(NSInteger) row {
    if (row == 2) {
        [self didSelectQueuesRow];
    } else if (row == 3) {
        [self didSelectRecommendationsRow];
    } else if (row == 5) {
        [self didSelectLogoutRow];
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasAccount) {
        [self didSelectLoggedInRow:indexPath.row];
    } else {
        NetflixLoginViewController* controller = [[[NetflixLoginViewController alloc] initWithNavigationController:navigationController] autorelease];
        [navigationController pushViewController:controller animated:YES];
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