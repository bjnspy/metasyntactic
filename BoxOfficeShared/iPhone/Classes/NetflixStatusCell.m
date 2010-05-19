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

#import "NetflixStatusCell.h"

#import "BoxOfficeStockImages.h"
#import "MovieDetailsViewController.h"

@interface NetflixStatusCell()
@property (retain) TappableImageView* removeMovieImageView;
@property (retain) TappableImageView* moveMovieImageView;

@property (retain) Status* status;
@end


@implementation NetflixStatusCell

@synthesize removeMovieImageView;
@synthesize moveMovieImageView;
@synthesize status;

- (void) dealloc {
  self.removeMovieImageView = nil;
  self.moveMovieImageView = nil;
  self.status = nil;

  [super dealloc];
}


- (void) initialize {
  self.textLabel.text = status.description;

  [removeMovieImageView removeFromSuperview];
  [moveMovieImageView removeFromSuperview];

  if (!status.queue.isAtHomeQueue && status.description.length > 0) {
    CGRect deleteFrame = removeMovieImageView.frame;
    CGRect moveFrame = moveMovieImageView.frame;

    deleteFrame.origin.x = moveFrame.size.width;
    removeMovieImageView.frame = deleteFrame;

    CGRect frame = CGRectMake(0, 0, deleteFrame.origin.x + deleteFrame.size.width, MAX(deleteFrame.size.height, moveFrame.size.height));
    UIView* view = [[[UIView alloc] initWithFrame:frame] autorelease];

    [view addSubview:removeMovieImageView];

    if (!status.saved && status.position != 0) {
      [view addSubview:moveMovieImageView];
    }

    self.accessoryView = view;
  }
}


- (id)         initWithStatus:(Status*) status_
                          row:(NSInteger) row
    tappableImageViewDelegate:(id<TappableImageViewDelegate>) delegate {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault
                   reuseIdentifier:nil])) {
    self.status = status_;

    self.textLabel.font = [UIFont boldSystemFontOfSize:16];
    self.textLabel.textAlignment = UITextAlignmentCenter;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.removeMovieImageView = [[[TappableImageView alloc] initWithImage:BoxOfficeStockImage(@"DeleteMovie.png")] autorelease];
    self.moveMovieImageView = [[[TappableImageView alloc] initWithImage:[BoxOfficeStockImages upArrow]] autorelease];
    removeMovieImageView.contentMode = moveMovieImageView.contentMode = UIViewContentModeCenter;

    moveMovieImageView.delegate = delegate;
    removeMovieImageView.delegate = delegate;

    moveMovieImageView.tag = SET_BITS(MOVE_NETFLIX_MOVIE_IMAGE_VIEW_TAG, row);
    removeMovieImageView.tag = SET_BITS(REMOVE_NETFLIX_MOVIE_IMAGE_VIEW_TAG, row);


    CGRect frame = removeMovieImageView.frame;
    frame.size.height += 20;
    frame.size.width += 20;
    removeMovieImageView.frame = frame;
    moveMovieImageView.frame = frame;

    [self initialize];
  }

  return self;
}


- (void) enterReadonlyMode {
  UIActivityIndicatorView* view = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
  self.accessoryView = view;
  [view startAnimating];
}

@end
