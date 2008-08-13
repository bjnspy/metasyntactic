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
#import "BoxOfficeModel.h"
#import "FontCache.h"
#import "MoviesNavigationController.h"
#import "Review.h"
#import "ReviewBodyCell.h"
#import "ReviewTitleCell.h"

@implementation ReviewsViewController

@synthesize navigationController;
@synthesize reviews;

- (void) dealloc {
    self.navigationController = nil;
    self.reviews = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(MoviesNavigationController*) navigationController_
                            reviews:(NSArray*) reviews_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
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


- (UITableViewCell*) reviewCellForRow:(NSInteger) row
                              section:(NSInteger) section {
    Review* review = [reviews objectAtIndex:section];
    
    if (row == 0) {
        static NSString* reuseIdentifier = @"ReviewTitleCellIdentifier";
        
        ReviewTitleCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewTitleCell alloc] initWithModel:self.model
                                                     frame:[UIScreen mainScreen].bounds
                                           reuseIdentifier:reuseIdentifier] autorelease];
        }
        
        [cell setReview:review];
        
        return cell;
    } else {
        static NSString* reuseIdentifier = @"ReviewBodyCellIdentifier";
        
        ReviewBodyCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewBodyCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:reuseIdentifier] autorelease];
        }
        
        [cell setReview:review];
        
        return cell;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < reviews.count) {
        return [self reviewCellForRow:indexPath.row section:indexPath.section];
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.model.rottenTomatoesRatings) {
            cell.text = @"RottenTomatoes.com";
        } else if (self.model.metacriticRatings) {
            cell.text = @"Metacritic.com";
        }
        return cell;
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == reviews.count) {
        return @"For movie reviews and more, visit";
    }
    
    return nil;
}


- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < reviews.count) {
        Review* review = [reviews objectAtIndex:indexPath.section];
        if (review.link) {
            [Application openBrowser:review.link];
        }
    } else {
        if (self.model.rottenTomatoesRatings) {
            [Application openBrowser:@"http://www.rottentomatoes.com"];
        } else if (self.model.metacriticRatings) {
            [Application openBrowser:@"http://www.metacritic.com"];
        }
    }
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return reviews.count + 1;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section < reviews.count) {
        return 2;
    } else {
        return 1;
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < reviews.count) {
        if (indexPath.row == 1) {
            Review* review = [reviews objectAtIndex:indexPath.section];
            
            return MAX([review heightWithFont:[FontCache helvetica14]], [self.tableView rowHeight]);
        }
    }
    
    return [tableView rowHeight];
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < reviews.count) {
        if (indexPath.row == 1) {
            Review* review = [reviews objectAtIndex:indexPath.section];
            if (review.link != nil) {
                return UITableViewCellAccessoryDetailDisclosureButton;
            }
        }
        
        return UITableViewCellAccessoryNone;
    } else {
        return UITableViewCellAccessoryDetailDisclosureButton;
    }
}


@end
