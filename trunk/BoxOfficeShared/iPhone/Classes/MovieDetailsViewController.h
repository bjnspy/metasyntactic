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
