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

double max_d(double a, double b) {
    return a > b ? a : b;
}

- (CGFloat) heightForReview:(Review*) review {
    NSString* text = review.text;
    CGFloat width = review.link ? 215 : 245;
    CGSize size = CGSizeMake(width, 1000);
    size = [text sizeWithFont:[UIFont fontWithName:@"helvetica" size:14]
            constrainedToSize:size
                lineBreakMode:UILineBreakModeWordWrap];
    
    return max_d(size.height + 10, [self.tableView rowHeight]);    
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    //NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Review* review = [reviews objectAtIndex:row];
    if (review.positive) {
        cell.image = [Application freshImage];
    } else {
        cell.image = [Application rottenImage];
    }
    
    CGRect rect = CGRectMake(50, 5, review.link ? 215 : 245, [self heightForReview:review] - 10);
    UILabel* label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.font = [UIFont fontWithName:@"helvetica" size:14];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    label.text = review.text;
    
    [cell.contentView addSubview:label]; 
    
    return cell;
}

- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    Review* review = [reviews objectAtIndex:[indexPath row]];
    if (review.link) {
        [Application openBrowser:review.link];
    }    
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {

}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    return reviews.count;
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    Review* review = [reviews objectAtIndex:[indexPath row]];
    
    return [self heightForReview:review];
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    Review* review = [reviews objectAtIndex:[indexPath row]];
    if (review.link == nil) {
        return UITableViewCellAccessoryNone;
    } else {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
}

@end
