// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "ReviewsViewController.h"
#import "Application.h"
#import "Review.h"
#import "ReviewTitleCell.h"
#import "ReviewBodyCell.h"
#import "MoviesNavigationController.h"
#import "Utilities.h"
#import "FontCache.h"

@implementation ReviewsViewController

@synthesize navigationController;
@synthesize reviews;

- (void) dealloc {
    self.navigationController = nil;
    self.reviews = nil;

    [super dealloc];
}

- (id) initWithNavigationController:(MoviesNavigationController*) controller
                            reviews:(NSArray*) reviews_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.title = NSLocalizedString(@"Reviews", nil);
        self.reviews = reviews_;
    }

    return self;
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[navigationController model].activityView] autorelease];

    [[navigationController model] setCurrentlyShowingReviews];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger row = indexPath.row;
    Review* review = [reviews objectAtIndex:indexPath.section];

    if (row == 0) {
        static NSString* reuseIdentifier = @"ReviewTitleCellIdentifier";

        ReviewTitleCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewTitleCell alloc] initWithModel:self.model
                                                     frame:[UIScreen mainScreen].bounds
                                           reuseIdentifier:reuseIdentifier] autorelease];
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
    Review* review = [reviews objectAtIndex:indexPath.section];
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
    if (indexPath.row == 0) {
        return [tableView rowHeight];
    } else {
        Review* review = [reviews objectAtIndex:indexPath.section];

        return MAX([review heightWithFont:[FontCache helvetica14]], [self.tableView rowHeight]);
    }
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.row == 1) {
        Review* review = [reviews objectAtIndex:indexPath.section];
        if (review.link != nil) {
            return UITableViewCellAccessoryDetailDisclosureButton;
        }
    }

    return UITableViewCellAccessoryNone;
}

@end
