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
