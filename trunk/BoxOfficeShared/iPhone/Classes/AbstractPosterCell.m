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

#import "AbstractPosterCell.h"

#import "BookmarkCache.h"
#import "CacheUpdater.h"
#import "Model.h"

@implementation AbstractPosterCell

@synthesize movie;

- (void) dealloc {
  self.movie = nil;

  [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
  if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
  }

  return self;
}


- (BookmarkCache*) bookmarkCache {
  return [BookmarkCache cache];
}


- (UIImage*) loadImageWorker {
  return [[Model model] smallPosterForMovie:movie loadFromDisk:YES];
}


- (UIImage*) retrieveImageFromCache {
  return [[Model model] smallPosterForMovie:movie loadFromDisk:NO];
}


- (void) prioritizeImage {
  [[CacheUpdater cacheUpdater] prioritizeMovie:movie now:NO];
}


- (void) onSetSameMovie:(Movie*) movie_
                  owner:(id) owner  {
  /*
  // refreshing with the same movie.
  // update our image if necessary.
  [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadImage) object:nil];

  UIImage* image = [self retrieveImageFromCache];
  if (image == nil) {
    [self clearImage];
  } else {
    [self setCellImage:image];
  }
   */
}


- (void) onSetDifferentMovie:(Movie*) movie_
                       owner:(id) owner  {
  // switching to a new movie.  update everything.
  self.movie = movie_;

  for (UILabel* label in self.allLabels) {
    [label removeFromSuperview];
  }

  // first see if we have this image already cached.  If so, use the cached
  // image.  Otherwise, load it from disk on the next run loop.
  UIImage* image = [self retrieveImageFromCache];
  if (image == nil) {
    [self clearImage];
  } else {
    [self setCellImage:image animated:NO];
  }

  [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadMovie:) object:owner];

  // if we're scrolling fast, then actually defer loading the image till
  // later.  Otherwise do it now.
  if ([[owner tableView] isDecelerating]) {
    [self performSelector:@selector(loadMovie:) withObject:owner afterDelay:0];
  } else {
    [self loadMovie:owner];
  }
}


- (void) loadMovieWorker:(id) owner AbstractMethod;


- (void) loadMovie:(id) owner {
  [self loadImage];
  [self loadMovieWorker:owner];
}


- (void) setMovie:(Movie*) movie_
            owner:(id) owner {
  if ([self.bookmarkCache isBookmarked:movie_]) {
    titleLabel.text = [NSString stringWithFormat:@"%@ %@", [StringUtilities starString], movie_.displayTitle];
  } else {
    titleLabel.text = movie_.displayTitle;
  }

  //if (movie == movie_) {
  //  [self onSetSameMovie:movie_ owner:owner];
  //} else {
    [self onSetDifferentMovie:movie_ owner:owner];
  //}
}

@end
