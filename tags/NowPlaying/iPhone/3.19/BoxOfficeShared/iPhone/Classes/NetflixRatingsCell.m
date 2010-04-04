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

#import "NetflixRatingsCell.h"

#import "BoxOfficeStockImages.h"
#import "MovieDetailsViewController.h"

@interface NetflixRatingsCell()
@property (retain) UITableViewController<TappableImageViewDelegate>* tappableTableView;
@property (retain) Movie* movie;
@property (retain) NetflixAccount* account;
@property (retain) NSArray* imageViews;
@end

@implementation NetflixRatingsCell

@synthesize tappableTableView;
@synthesize movie;
@synthesize account;
@synthesize imageViews;

- (void) dealloc {
  self.tappableTableView = nil;
  self.movie = nil;
  self.account = nil;
  self.imageViews = nil;

  [super dealloc];
}


- (NSInteger) halfWayPoint {
  NSInteger width = self.tableViewController.view.frame.size.width;
  
  NSInteger halfPoint = width / 2;
  halfPoint -= groupedTableViewMargin;
  
  return halfPoint;
}


- (NetflixUpdater*) netflixUpdater {
  return [NetflixUpdater updater];
}


- (void) setupNetflixRating {
  CGFloat rating = [[[NetflixCache cache] netflixRatingForMovie:movie account:account] floatValue];

  NSMutableArray* array = [NSMutableArray array];
  for (NSInteger i = 0; i < 5; i++) {
    UIImage* image;

    CGFloat value = rating - i;
    if (value < 0.2) {
      image = [BoxOfficeStockImages redStar_0_5_Image];
    } else if (value < 0.4) {
      image = [BoxOfficeStockImages redStar_1_5_Image];
    } else if (value < 0.6) {
      image = [BoxOfficeStockImages redStar_2_5_Image];
    } else if (value < 0.8) {
      image = [BoxOfficeStockImages redStar_3_5_Image];
    } else if (value < 1) {
      image = [BoxOfficeStockImages redStar_4_5_Image];
    } else {
      image = [BoxOfficeStockImages redStar_5_5_Image];
    }

    TappableImageView* imageView = [[[TappableImageView alloc] initWithImage:image] autorelease];
    imageView.delegate = self.tappableTableView;
    imageView.tag = SET_BITS(RATE_NETFLIX_MOVIE_IMAGE_VIEW_TAG, (i + 1));
    imageView.contentMode = UIViewContentModeCenter;

    CGRect rect = imageView.frame;
    rect.origin.y = 5;
    rect.size.width += 10;
    rect.size.height += 10;
    NSInteger halfWayPoint = [self halfWayPoint];

    rect.origin.x = (halfWayPoint - 135) + (40 * (i + 1));
    imageView.frame = rect;

    [self.contentView addSubview:imageView];
    [array addObject:imageView];
  }

  self.imageViews = array;
}


- (void) setupUserRating:(NSString*) userRating {
  CGFloat rating = [userRating floatValue];

  NSMutableArray* array = [NSMutableArray array];
  for (NSInteger i = -1; i < 5; i++) {
    UIImage* image;
    if (i == -1) {
      image = BoxOfficeStockImage(@"ClearRating.png");
    } else {
      CGFloat value = rating - i;
      if (value < 1) {
        image = [BoxOfficeStockImages emptyStarImage];
      } else {
        image = [BoxOfficeStockImages filledYellowStarImage];
      }
    }

    TappableImageView* imageView = [[[TappableImageView alloc] initWithImage:image] autorelease];
    imageView.delegate = self.tappableTableView;
    imageView.tag = SET_BITS(RATE_NETFLIX_MOVIE_IMAGE_VIEW_TAG, (i + 1));
    imageView.contentMode = UIViewContentModeCenter;

    CGRect rect = imageView.frame;
    rect.origin.y = 5;
    rect.size.width += 10;
    rect.size.height += 10;
    NSInteger halfWayPoint = [self halfWayPoint];

    rect.origin.x = (halfWayPoint - 115) + (40 * (i + 1));
    imageView.frame = rect;

    [self.contentView addSubview:imageView];
    [array addObject:imageView];
  }
  self.imageViews = array;
}


- (void) clearRating {
  for (UIView* view in self.contentView.subviews) {
    [view removeFromSuperview];
  }

  self.imageViews = [NSArray array];
}


- (void) setupRating {
  [self clearRating];

  NSString* userRating = [[NetflixCache cache] userRatingForMovie:movie account:account];
  if (userRating.length > 0) {
    [self setupUserRating:userRating];
  } else {
    [self setupNetflixRating];
  }
}


- (id)    initWithMovie:(Movie*) movie_
    tableViewController:(UITableViewController<TappableImageViewDelegate>*) tableViewController_ {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault
                   reuseIdentifier:nil
               tableViewController:tableViewController_])) {
    self.tappableTableView = tableViewController_;
    self.movie = movie_;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageViews = [NSMutableArray array];
    [self setupRating];
  }

  return self;
}


- (void) refresh:(NetflixAccount*) account_ {
  self.account = account_;
  [self setupRating];
}

@end
