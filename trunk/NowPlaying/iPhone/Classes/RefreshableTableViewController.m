//
//  RefreshableTableViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RefreshableTableViewController.h"


@implementation RefreshableTableViewController

- (void)dealloc {
    [super dealloc];
}


- (id) initWithStyle:(UITableViewStyle) style {
    if (self = [super initWithStyle:style]) {
    }

    return self;
}


- (void) majorRefreshWorker {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) minorRefreshWorker {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) refreshWithSelector:(SEL) selector subclassSelector:(SEL) subclassSelector {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:selector
                                               object:nil];

    if (self.tableView.dragging || self.tableView.decelerating) {
        [self performSelector:selector withObject:nil afterDelay:1];
        return;
    }

    [self performSelector:subclassSelector];
}


- (void) majorRefresh {
    [self refreshWithSelector:@selector(majorRefresh) subclassSelector:@selector(majorRefreshWorker)];
}


- (void) minorRefresh {
    [self refreshWithSelector:@selector(minorRefresh) subclassSelector:@selector(minorRefreshWorker)];
}

@end

