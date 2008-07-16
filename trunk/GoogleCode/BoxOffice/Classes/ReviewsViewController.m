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
    CGFloat width = review.link ? 255 : 285;
    CGSize size = CGSizeMake(width, 1000);
    size = [text sizeWithFont:[UIFont fontWithName:@"helvetica" size:14]
            constrainedToSize:size
                lineBreakMode:UILineBreakModeWordWrap];
    
    return max_d(size.height + 10, [self.tableView rowHeight]);    
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    Review* review = [reviews objectAtIndex:section];
    
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (row == 0) {
        if (review.positive) {
            cell.image = [Application freshImage];
        } else {
            cell.image = [Application rottenImage];
        }
        
        //cell.text = [NSString stringWithFormat:@"%@, %@", review.author, review.source];

        UILabel* authorLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        UILabel* sourceLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];

        authorLabel.text = review.author;
        sourceLabel.text = review.source;
        authorLabel.font = [UIFont boldSystemFontOfSize:14];
        sourceLabel.font = [UIFont boldSystemFontOfSize:12];
        
        [authorLabel sizeToFit];
        [sourceLabel sizeToFit];
        
        CGRect frame;
        
        frame = authorLabel.frame;
        frame.origin.y = 5;
        frame.origin.x = 50;
        authorLabel.frame = frame;
        
        frame = sourceLabel.frame;
        frame.origin.y = 23;
        frame.origin.x = 50;
        sourceLabel.frame = frame;
        
        [cell.contentView addSubview:authorLabel];
        [cell.contentView addSubview:sourceLabel];
        
        return cell;
         
    } else {
        CGRect rect = CGRectMake(10, 5, review.link ? 255 : 285, [self heightForReview:review] - 10);
        UILabel* label = [[[UILabel alloc] initWithFrame:rect] autorelease];
        label.font = [UIFont fontWithName:@"helvetica" size:14];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0;
        label.text = review.text;
        
        [cell.contentView addSubview:label]; 
    }
    
    return cell;
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

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (row == 0) {
        return [tableView rowHeight];
    } else {
        Review* review = [reviews objectAtIndex:section];
    
        return [self heightForReview:review];
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
