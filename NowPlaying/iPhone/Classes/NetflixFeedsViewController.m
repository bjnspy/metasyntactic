//
//  NetflixFeedsViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixFeedsViewController.h"

#import "AbstractNavigationController.h"
#import "AutoResizingCell.h"
#import "Feed.h"
#import "GlobalActivityIndicator.h"
#import "NetflixCache.h"
#import "NetflixQueueViewController.h"
#import "NowPlayingModel.h"

@interface NetflixFeedsViewController()
@property (assign) AbstractNavigationController* navigationController;
@end


@implementation NetflixFeedsViewController

@synthesize navigationController;

- (void)dealloc {
    self.navigationController = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.title = NSLocalizedString(@"Queues", nil);
    }
    
    return self;
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    [self majorRefresh];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSArray*) feeds {
    NSArray* feeds = self.model.netflixCache.feeds;
    
    NSMutableArray* result = [NSMutableArray array];
    for (Feed* feed in feeds) {
        if (!feed.isRecommendationFeed) {
            [result addObject:feed];
        }
    }
    return result;
}


- (BOOL) hasFeeds {
    return self.feeds.count > 0;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* feeds = self.feeds;
    
    if (feeds.count == 0) {
        return 1;
    } else {
        return feeds.count;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AutoResizingCell *cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero] autorelease];

    NSArray* feeds = self.feeds;
    if (feeds.count == 0) {
        cell.text = self.model.netflixCache.noInformationFound;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        Feed* feed = [feeds objectAtIndex:indexPath.row];
        NSArray* queue = [self.model.netflixCache queueForFeed:feed];
        
        id argument = (queue == nil ? (id)NSLocalizedString(@"downloading", nil) : (id)[NSNumber numberWithInt:queue.count]);
        cell.text = [NSString stringWithFormat:feed.title, argument];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSArray* feeds = self.feeds;
    if (feeds.count == 0) {
        return;
    }
    
    Feed* feed = [feeds objectAtIndex:indexPath.row];
    NetflixQueueViewController* controller = [[[NetflixQueueViewController alloc] initWithNavigationController:navigationController feed:feed] autorelease];
    [navigationController pushViewController:controller animated:YES];
}

@end