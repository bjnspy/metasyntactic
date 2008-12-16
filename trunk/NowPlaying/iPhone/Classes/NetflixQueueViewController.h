//
//  NetflixQueueViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixReorderQueueDelegate.h"
#import "TappableImageViewDelegate.h"

@interface NetflixQueueViewController : UITableViewController<TappableImageViewDelegate, NetflixReorderQueueDelegate> {
@private
    AbstractNavigationController* navigationController;
    Feed* feed;
    Queue* queue;
    
    UIBarButtonItem* backButton;
    BOOL upArrowTapped;
    
    NSMutableArray* mutableMovies;
    
    BOOL readonlyMode;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController feed:(Feed*) feed;

@end
