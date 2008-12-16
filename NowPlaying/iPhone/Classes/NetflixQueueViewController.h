//
//  NetflixQueueViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TappableImageViewDelegate.h"

@interface NetflixQueueViewController : UITableViewController<TappableImageViewDelegate> {
@private
    AbstractNavigationController* navigationController;
    Feed* feed;
    NSArray* movies;
    
    UIBarButtonItem* backButton;
    BOOL upArrowTapped;
    
    NSArray* originalMovies;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController feed:(Feed*) feed;

@end
