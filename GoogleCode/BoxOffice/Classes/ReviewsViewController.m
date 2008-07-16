//
//  ReviewsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ReviewsViewController.h"
#import "Application.h"
#import "Review.h"
#import "ReviewTitleCell.h"
#import "ReviewBodyCell.h"

@implementation ReviewsViewController

@synthesize reviews;

- (void) dealloc {
    self.reviews = nil;
    
    [super dealloc];
}

- (id) initWithReviews:(NSArray*) reviews_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = NSLocalizedString(@"Reviews", nil);
        self.reviews = reviews_;
    }
    
    return self;
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    Review* review = [reviews objectAtIndex:section];
        
    if (row == 0) {
        static NSString* reuseIdentifier = @"ReviewTitleCellIdentifier";
        
        ReviewTitleCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewTitleCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:reuseIdentifier] autorelease];
        }
        
        [cell setReview:review];
        
        return cell;
    } else {
        static NSString* reuseIdentifier = @"ReviewBodyCellIdentifier";
        
        ReviewBodyCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewBodyCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:reuseIdentifier] autorelease];
        }
        
        [cell setReview:review];
        
        return cell;
    }
}

- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    Review* review = [reviews objectAtIndex:[indexPath section]];
    if (review.link) {
        [Application openBrowser:review.link];
    }    
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {

}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return reviews.count;
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    return 2;
}



double max_d(double a, double b) {
    return a > b ? a : b;
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (row == 0) {
        return [tableView rowHeight];
    } else {
        Review* review = [reviews objectAtIndex:section];
    
        return max_d([review heightWithFont:[Application helvetica14]], [self.tableView rowHeight]);
    }
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (row == 1) {
        Review* review = [reviews objectAtIndex:section];
        if (review.link != nil) {
            return UITableViewCellAccessoryDetailDisclosureButton;
        }
    }
    
    return UITableViewCellAccessoryNone;
}

@end
