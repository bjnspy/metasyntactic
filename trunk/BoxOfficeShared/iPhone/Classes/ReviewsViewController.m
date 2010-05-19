// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "ReviewsViewController.h"

#import "Model.h"
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


- (id) initWithMovie:(Movie*) movie_ {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.movie = movie_;
  }

  return self;
}


- (void) loadView {
  [super loadView];

  self.title = LocalizedString(@"Reviews", nil);

  self.reviews = [[Model model] reviewsForMovie:movie];
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
      cell = [[[ReviewBodyCell alloc] initWithReuseIdentifier:reuseIdentifier
                                          tableViewController:self] autorelease];
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
    if ([Model model].rottenTomatoesScores) {
      cell.textLabel.text = @"RottenTomatoes.com";
    } else if ([Model model].metacriticScores) {
      cell.textLabel.text = @"Metacritic.com";
    } else if ([Model model].googleScores) {
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
  return (id) self.navigationController;
}


- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section < reviews.count) {
    Review* review = [reviews objectAtIndex:indexPath.section];
    if (review.link) {
      [self.commonNavigationController pushBrowser:review.link animated:YES];
    }
  } else {
    if ([Model model].rottenTomatoesScores) {
      Score* score = [[Model model] rottenTomatoesScoreForMovie:movie];
      NSString* address = score.identifier.length > 0 ? score.identifier : @"http://www.rottentomatoes.com";
      [self.commonNavigationController pushBrowser:address animated:YES];
    } else if ([Model model].metacriticScores) {
      Score* score = [[Model model] metacriticScoreForMovie:movie];
      NSString* address = score.identifier.length > 0 ? score.identifier : @"http://www.metacritic.com";
      [self.commonNavigationController pushBrowser:address animated:YES];
    } else if ([Model model].googleScores) {
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
      id cell = [self tableView:tableView
                    cellForRowAtIndexPath:indexPath];

      return MAX([cell height], self.tableView.rowHeight);
    }
  }

  return tableView.rowHeight;
}

@end
