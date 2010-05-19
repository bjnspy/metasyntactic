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

#import "PostersViewController.h"

#import "LargeMoviePosterCache.h"

@interface PostersViewController()
@property (retain) Movie* movie;
@end


@implementation PostersViewController

@synthesize movie;

- (void) dealloc {
  self.movie = nil;

  [super dealloc];
}


- (id) initWithMovie:(Movie*) movie_
         posterCount:(NSInteger) posterCount_ {
  if ((self = [super initWithImageCount:posterCount_])) {
    self.movie = movie_;
  }

  return self;
}


- (BOOL) allImagesDownloaded {
  return [[LargeMoviePosterCache cache] allPostersDownloadedForMovie:movie];
}


- (BOOL) imageExistsForPage:(NSInteger) page {
  return [[LargeMoviePosterCache cache] posterExistsForMovie:movie index:page];
}


- (UIImage*) imageForPage:(NSInteger) page {
  return [[LargeMoviePosterCache cache] posterForMovie:movie index:page loadFromDisk:YES];
}


- (BOOL) allowsSaving {
  return YES;
}

@end
