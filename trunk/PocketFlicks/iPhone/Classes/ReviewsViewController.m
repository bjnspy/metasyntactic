// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "ReviewsViewController.h"

#import "Model.h"
#import "MoviesNavigationController.h"
#import "Review.h"
#import "ReviewBodyCell.h"
#import "ReviewTitleCell.h"
#import "Score.h"

@interface ReviewsViewController()
@property (retain) Movie* movie;
@property (retain) NSArray* reviews;
@end


@implementation ReviewsViewController

@synthesize movie;
@synthesize reviews;

- (void) dealloc {
    self.movie = nil;
    self.reviews = nil;

    [super dealloc];
}


- (id) initWithMovie:(Movie*) movie__ {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.movie = movie__;
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (void) loadView {
    [super loadView];

    self.title = LocalizedString(@"Reviews", nil);

    self.reviews = [self.model reviewsForMovie:movie];
}


- (void) didReceiveMemoryWarningWorker {
    [super didReceiveMemoryWarningWorker];
    self.reviews = nil;
}


- (UITableViewCell*) reviewCellForRow:(NSInteger) row
                              section:(NSInteger) section {
    Review* review = [reviews objectAtIndex:section];

    if (row == 0) {
        static NSString* reuseIdentifier = @"titleReuseIdentifier";

        ReviewTitleCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewTitleCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
        }

        [cell setReview:review];

        return cell;
    } else {
        static NSString* reuseIdentifier = @"bodyReuseIdentifier";

        ReviewBodyCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewBodyCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
        }

        if (review.link.length != 0) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.model.rottenTomatoesScores || self.model.metacriticScores) {
            cell.textLabel.text = @"Metacritic.com";
        } else if (self.model.googleScores) {
            cell.textLabel.text = @"Google.com";
        }
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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


- (CommonNavigationController*) commonNavigationController {
  return (id)self.navigationController;
}


- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < reviews.count) {
        Review* review = [reviews objectAtIndex:indexPath.section];
        if (review.link) {
            [self.commonNavigationController pushBrowser:review.link animated:YES];
        }
    } else {
        if (self.model.rottenTomatoesScores || self.model.metacriticScores) {
            Score* score = [self.model metacriticScoreForMovie:movie];
            NSString* address = score.identifier.length > 0 ? score.identifier : @"http://www.metacritic.com";
            [self.commonNavigationController pushBrowser:address animated:YES];
        } else if (self.model.googleScores) {
            [self.commonNavigationController pushBrowser:@"http://www.google.com/movies" animated:YES];
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

            return MAX([ReviewBodyCell height:review], self.tableView.rowHeight);
        }
    }

    return tableView.rowHeight;
}


- (void) minorRefreshWorker {
    //[self majorRefresh];
}


- (void) majorRefreshWorker {
    //[self reloadTableViewData];
}

@end
