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

#import "AbstractDetailsViewController.h"

static const NSInteger ADD_NETFLIX_MOVIE_ACTION_SHEET_TAG = 1 << 31;
static const NSInteger REMOVE_NETFLIX_MOVIE_ACTION_SHEET_TAG = 1 << 30;
static const NSInteger VISIT_WEBSITES_ACTION_SHEET_TAG = 1 << 29;

static const NSInteger ZOOM_POSTER_IMAGE_VIEW_TAG = 1 << 31;
static const NSInteger RATE_NETFLIX_MOVIE_IMAGE_VIEW_TAG = 1 << 30;
static const NSInteger MOVE_NETFLIX_MOVIE_IMAGE_VIEW_TAG = 1 << 29;
static const NSInteger REMOVE_NETFLIX_MOVIE_IMAGE_VIEW_TAG = 1 << 28;

@interface MovieDetailsViewController : AbstractDetailsViewController<
UIActionSheetDelegate,
MapViewControllerDelegate,
TappableImageViewDelegate,
NetflixAddMovieDelegate,
NetflixModifyQueueDelegate,
NetflixMoveMovieDelegate,
NetflixChangeRatingDelegate> {
@private
  Movie* movie;
  DVD* dvd;

  NetflixAccount* netflixAccount;
  Movie* netflixMovie;
  NetflixRatingsCell* netflixRatingsCell;
  NSArray* netflixStatusCells;

  NSMutableArray* filteredTheatersArray;
  NSMutableArray* allTheatersArray;
  NSMutableArray* showtimesArray;
  NSArray* trailersArray;
  NSArray* reviewsArray;
  NSDictionary* websites;

  ActionsView* actionsView;
  UIButton* bookmarkButton;

  BOOL filterTheatersByDistance;
  BOOL expandedDetails;

  UIImage* posterImage;
  TappableImageView* posterImageView;
  NSInteger posterCount;

  NSDictionary* buttonIndexToActionMap;

  MPMoviePlayerController* moviePlayerController;
  BOOL playingTrailer;
}

- (id) initWithMovie:(Movie*) movie;

+ (UIImage*) posterForMovie:(Movie*) movie;

@end
