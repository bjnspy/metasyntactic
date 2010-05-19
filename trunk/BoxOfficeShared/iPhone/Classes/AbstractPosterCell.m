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

#import "AbstractPosterCell.h"

#import "BookmarkCache.h"
#import "Model.h"
#import "MovieCacheUpdater.h"

@implementation AbstractPosterCell

@synthesize movie;

- (void) dealloc {
  self.movie = nil;

  [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier
           tableViewController:(UITableViewController*) tableViewController_ {
  if ((self = [super initWithReuseIdentifier:reuseIdentifier
                         tableViewController:tableViewController_ ])) {
  }

  return self;
}


- (UIImage*) loadImageWorker {
  return [[Model model] smallPosterForMovie:movie loadFromDisk:YES];
}


- (UIImage*) retrieveImageFromCache {
  return [[Model model] smallPosterForMovie:movie loadFromDisk:NO];
}


- (void) prioritizeImage {
  [[MovieCacheUpdater updater] prioritizeMovie:movie now:NO];
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
  if ([[BookmarkCache cache] isBookmarked:movie_]) {
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
