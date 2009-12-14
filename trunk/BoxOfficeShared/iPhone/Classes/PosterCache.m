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

#import "PosterCache.h"

#import "ApplePosterDownloader.h"
#import "Application.h"
#import "FandangoPosterDownloader.h"
#import "ImdbPosterDownloader.h"
#import "LargePosterCache.h"
#import "Model.h"
#import "PreviewNetworksPosterDownloader.h"

@interface PosterCache()
@property (retain) ImdbPosterDownloader* imdbPosterDownloader;
@property (retain) ApplePosterDownloader* applePosterDownloader;
@property (retain) FandangoPosterDownloader* fandangoPosterDownloader;
@property (retain) PreviewNetworksPosterDownloader* previewNetworksPosterDownloader;
@end


@implementation PosterCache

static PosterCache* cache;

+ (void) initialize {
  if (self == [PosterCache class]) {
    cache = [[PosterCache alloc] init];
  }
}


+ (PosterCache*) cache {
  return cache;
}

@synthesize imdbPosterDownloader;
@synthesize applePosterDownloader;
@synthesize fandangoPosterDownloader;
@synthesize previewNetworksPosterDownloader;

- (void) dealloc {
  self.imdbPosterDownloader = nil;
  self.applePosterDownloader = nil;
  self.fandangoPosterDownloader = nil;
  self.previewNetworksPosterDownloader = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.imdbPosterDownloader = [[[ImdbPosterDownloader alloc] init] autorelease];
    self.applePosterDownloader = [[[ApplePosterDownloader alloc] init] autorelease];
    self.fandangoPosterDownloader = [[[FandangoPosterDownloader alloc] init] autorelease];
    self.previewNetworksPosterDownloader = [[[PreviewNetworksPosterDownloader alloc] init] autorelease];
  }

  return self;
}


- (NSString*) sentinelPath:(Movie*) movie {
  return [[Application sentinelsPostersDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.identifier]];
}


- (NSString*) posterFilePath:(Movie*) movie {
  NSString* sanitizedTitle;
  if (movie.isNetflix) {
    sanitizedTitle = [FileUtilities sanitizeFileName:movie.simpleNetflixIdentifier];
  } else {
    sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
  }
  return [[[Application moviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallPosterFilePath:(Movie*) movie {
  NSString* sanitizedTitle;
  if (movie.isNetflix) {
    sanitizedTitle = [FileUtilities sanitizeFileName:movie.simpleNetflixIdentifier];
  } else {
    sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
  }
  return [[[Application moviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"-small.png"];
}


- (NSData*) downloadPosterWorker:(Movie*) movie {
  NSData* data = [NetworkUtilities dataWithContentsOfAddress:movie.poster pause:NO];
  if (data != nil) {
    return data;
  }

  data = [previewNetworksPosterDownloader download:movie];
  if (data != nil) {
    return data;
  }

  data = [applePosterDownloader download:movie];
  if (data != nil) {
    return data;
  }

  data = [fandangoPosterDownloader download:movie];
  if (data != nil) {
    return data;
  }

  data = [imdbPosterDownloader download:movie];
  if (data != nil) {
    return data;
  }

  [[LargePosterCache cache] downloadFirstPosterForMovie:movie];

  // if we had a network connection, then it means we don't know of any
  // posters for this movie.  record that fact and try again another time
  if ([NetworkUtilities isNetworkAvailable]) {
    return [NSData data];
  }

  return nil;
}


- (void) updateMovieDetailsWorker:(Movie*) movie force:force {
  NSString* path = [self posterFilePath:movie];
  if ([FileUtilities size:path] > 0) {
    // already have a real poster.
    return;
  }

  NSString* sentinelPath = [self sentinelPath:movie];
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

  NSData* data = [self downloadPosterWorker:movie];
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


- (Movie*) appropriateMovie:(Movie*) movie {
  Movie* possible = [[NetflixCache cache] correspondingNetflixMovie:movie];
  if (possible != nil) {
    return possible;
  }

  return movie;
}


- (void) updateMovieDetails:(Movie*) movie force:force {
  [self updateMovieDetailsWorker:movie force:force];
  [self updateMovieDetailsWorker:[self appropriateMovie:movie] force:force];
}


- (UIImage*) posterForMovieWorker:(Movie*) movie
               loadFromDisk:(BOOL) loadFromDisk {
  NSString* path = [self posterFilePath:movie];
  return [[ImageCache cache] imageForPath:path loadFromDisk:loadFromDisk];
}


- (UIImage*) posterForMovie:(Movie*) movie
               loadFromDisk:(BOOL) loadFromDisk {
  UIImage* image;
  if ((image = [self posterForMovieWorker:movie loadFromDisk:loadFromDisk]) != nil ||
      (image = [self posterForMovieWorker:[self appropriateMovie:movie] loadFromDisk:loadFromDisk]) != nil) {
    return image;
  }
  return nil;
}


- (UIImage*) smallPosterForMovieWorker:(Movie*) movie
                    loadFromDisk:(BOOL) loadFromDisk {
  NSString* smallPosterPath = [self smallPosterFilePath:movie];

  UIImage* image = [[ImageCache cache] imageForPath:smallPosterPath loadFromDisk:loadFromDisk];
  if (image != nil || !loadFromDisk) {
    return image;
  }

  NSData* smallPosterData;
  if ([FileUtilities size:smallPosterPath] == 0) {
    NSData* normalPosterData = [FileUtilities readData:[self posterFilePath:movie]];
    smallPosterData = [ImageUtilities scaleImageData:normalPosterData
                                            toHeight:SMALL_POSTER_HEIGHT];

    [FileUtilities writeData:smallPosterData toFile:smallPosterPath];

    UIImage* image = [UIImage imageWithData:smallPosterData];
    [[ImageCache cache] setImage:image forPath:smallPosterPath];
    return image;
  }

  return nil;
}


- (UIImage*) smallPosterForMovie:(Movie*) movie
                    loadFromDisk:(BOOL) loadFromDisk {
  UIImage* image;
  if ((image = [self smallPosterForMovieWorker:movie loadFromDisk:loadFromDisk]) != nil ||
      (image = [self smallPosterForMovieWorker:[self appropriateMovie:movie] loadFromDisk:loadFromDisk]) != nil) {
    return image;
  }
  return nil;
}

@end
