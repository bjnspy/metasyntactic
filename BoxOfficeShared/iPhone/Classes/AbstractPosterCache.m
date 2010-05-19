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

#import "AbstractPosterCache.h"

#import "AppleMoviePosterDownloader.h"
#import "Application.h"
#import "FandangoMoviePosterDownloader.h"
#import "ImdbMoviePosterDownloader.h"
#import "LargeMoviePosterCache.h"
#import "PreviewNetworksMoviePosterDownloader.h"

@implementation AbstractPosterCache

- (NSString*) sentinelPath:(id) object AbstractMethod;


- (NSString*) posterFilePath:(id) object AbstractMethod;


- (NSString*) smallPosterFilePath:(id) object AbstractMethod;


- (NSData*) downloadPoster:(id) object AbstractMethod;


- (void) updateObjectDetails:(id) object force:(BOOL) force {
  NSString* path = [self posterFilePath:object];
  if ([FileUtilities size:path] > 0) {
    // already have a real poster.
    return;
  }

  NSString* sentinelPath = [self sentinelPath:object];
  if (!force) {
    // check if we have a sentinel
    NSDate* modificationDate = [FileUtilities modificationDate:sentinelPath];
    if (modificationDate != nil) {
      // sentinel value.  only update if it's been long enough.
      if (ABS(modificationDate.timeIntervalSinceNow) < THREE_DAYS) {
        return;
      }
    }
  }

  NSData* data = [self downloadPoster:object];
  if (data != nil) {
    if (data.length == 0) {
      // write to the sentinel so we don't do this for a while
      [FileUtilities writeData:data toFile:sentinelPath];
    } else {
      [FileUtilities writeData:data toFile:path];
      [MetasyntacticSharedApplication minorRefresh];
    }
  }
}


- (UIImage*) posterForObject:(id) object
                loadFromDisk:(BOOL) loadFromDisk {
  NSString* path = [self posterFilePath:object];
  return [[ImageCache cache] imageForPath:path loadFromDisk:loadFromDisk];
}


- (UIImage*) smallPosterForObject:(id) object
                     loadFromDisk:(BOOL) loadFromDisk {
  NSString* smallPosterPath = [self smallPosterFilePath:object];

  UIImage* image = [[ImageCache cache] imageForPath:smallPosterPath
                                       loadFromDisk:loadFromDisk];
  if (image != nil || !loadFromDisk) {
    return image;
  }

  NSData* smallPosterData;
  if ([FileUtilities size:smallPosterPath] == 0) {
    NSData* normalPosterData = [FileUtilities readData:[self posterFilePath:object]];
    smallPosterData = [ImageUtilities scaleImageData:normalPosterData
                                            toHeight:SMALL_POSTER_HEIGHT];

    [FileUtilities writeData:smallPosterData toFile:smallPosterPath];

    UIImage* image = [UIImage imageWithData:smallPosterData];
    [[ImageCache cache] setImage:image forPath:smallPosterPath];
    return image;
  }

  return nil;
}

@end
