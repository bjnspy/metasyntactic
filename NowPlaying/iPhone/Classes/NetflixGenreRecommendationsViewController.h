//
//  NetflixGenreRecommendationsViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RefreshableTableViewController.h"

@interface NetflixGenreRecommendationsViewController : RefreshableTableViewController {
@private
    AbstractNavigationController* navigationController;
    NSString* genre;
    NSArray* movies;

    NSArray* visibleIndexPaths;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController genre:(NSString*) genre;

@end
