//
//  ReviewsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReviewsViewController :  UITableViewController {
    NSArray* reviews;
}

@property (retain) NSArray* reviews;

- (id) initWithReviews:(NSArray*) reviews;

@end
