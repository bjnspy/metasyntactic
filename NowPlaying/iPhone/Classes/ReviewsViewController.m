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

#import "AppDelegate.h"
#import "Application.h"
#import "GlobalActivityIndicator.h"
#import "MoviesNavigationController.h"
#import "Model.h"
#import "Review.h"
#import "ReviewBodyCell.h"
#import "ReviewTitleCell.h"
#import "Score.h"
#import "Utilities.h"
#import "WebViewController.h"

@interface ReviewsViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) Movie* movie;
@property (retain) NSArray* reviews;
@end


@implementation ReviewsViewController

@synthesize navigationController;
@synthesize movie;
@synthesize reviews;

- (void) dealloc {
    self.navigationController = nil;
    self.movie = nil;
    self.reviews = nil;

    [super dealloc];
}


- (Model*) model {
    return navigationController.model;
}


- (Controller*) controller {
    return navigationController.controller;
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                              movie:(Movie*) movie_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
        self.movie = movie_;
    }

    return self;
}


- (void) loadView {
    [super loadView];

    self.title = NSLocalizedString(@"Reviews", nil);

    self.reviews = [self.model reviewsForMovie:movie];
}


- (void) viewDidAppear:(BOOL) animated {
    visible = YES;
    [self.model saveNavigationStack:self.navigationController];
}


- (void) viewDidDisappear:(BOOL) animated {
    visible = NO;
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    self.reviews = nil;

    [super didReceiveMemoryWarning];
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[AppDelegate globalActivityView]] autorelease];
    [self majorRefresh];
}


- (UITableViewCell*) reviewCellForRow:(NSInteger) row
                              section:(NSInteger) section {
    Review* review = [reviews objectAtIndex:section];

    if (row == 0) {
        static NSString* reuseIdentifier = @"titleReuseIdentifier";

        ReviewTitleCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewTitleCell alloc] initWithModel:self.model
                                           reuseIdentifier:reuseIdentifier] autorelease];
        }

        [cell setReview:review];

        return cell;
    } else {
        static NSString* reuseIdentifier = @"bodyReuseIdentifier";

        ReviewBodyCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ReviewBodyCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame reuseIdentifier:reuseIdentifier] autorelease];
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
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.model.rottenTomatoesScores || self.model.metacriticScores) {
            cell.text = @"Metacritic.com";
        } else if (self.model.googleScores) {
            cell.text = @"Google.com";
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


- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < reviews.count) {
        Review* review = [reviews objectAtIndex:indexPath.section];
        if (review.link) {
            [navigationController pushBrowser:review.link animated:YES];
        }
    } else {
        if (self.model.rottenTomatoesScores || self.model.metacriticScores) {
            Score* score = [self.model metacriticScoreForMovie:movie];
            NSString* address = score.identifier.length > 0 ? score.identifier : @"http://www.metacritic.com";
            [navigationController pushBrowser:address animated:YES];
        } else if (self.model.googleScores) {
            [navigationController pushBrowser:@"http://www.google.com/movies" animated:YES];
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


- (void) minorRefresh {
    [self majorRefresh];
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}

@end