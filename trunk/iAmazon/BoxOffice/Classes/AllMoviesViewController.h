//
//  AllMoviesViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeModel.h"

@class MoviesNavigationController;

@interface AllMoviesViewController : UITableViewController {
    MoviesNavigationController* navigationController;
}

@property (assign) MoviesNavigationController* navigationController;

- (id) initWithNavigationController:(MoviesNavigationController*) navigationController;
- (void) dealloc;

- (void) refresh;
- (BoxOfficeModel*) model;

@end
