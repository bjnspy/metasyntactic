//
//  ReviewsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoviesNavigationController;

@interface ReviewsViewController :  UITableViewController {
    MoviesNavigationController* navigationController;

    NSArray* reviews;
}

@property (assign) MoviesNavigationController* navigationController;
@property (retain) NSArray* reviews;

- (id) initWithNavigationController:(MoviesNavigationController*) controller
                            reviews:(NSArray*) reviews;

@end
