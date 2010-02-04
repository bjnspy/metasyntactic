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
