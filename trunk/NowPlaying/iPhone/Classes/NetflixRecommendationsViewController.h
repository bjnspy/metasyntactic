//
//  NetflixRecommendationsViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RefreshableTableViewController.h"

@interface NetflixRecommendationsViewController : RefreshableTableViewController {
@private
    AbstractNavigationController* navigationController;

    NSArray* genres;
    MultiDictionary* genreToMovies;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController;

@end
