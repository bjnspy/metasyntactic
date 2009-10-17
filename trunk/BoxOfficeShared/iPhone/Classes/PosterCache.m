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


+ (PosterCache*) cache {
  return [[[PosterCache alloc] init] autorelease];
}


- (Model*) model {
  return [Model model];
}


- (NSString*) standardPosterPath:(Movie*) movie {
  NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
  return [[[Application moviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallPosterPath:(Movie*) movie {
  NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
  return [[[Application moviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingString:@"-small.png"];
}


- (NSString*) posterFilePath:(Movie*) movie {
  if (movie.isNetflix) {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:[NetflixCache simpleNetflixIdentifier:movie]];
    return [[[Application netflixMoviePostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
  } else {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    return [[[Application moviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
  }
}


- (NSString*) smallPosterFilePath:(Movie*) movie {
  if (movie.isNetflix) {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:[NetflixCache simpleNetflixIdentifier:movie]];
    return [[[Application netflixMoviePostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"-small.png"];
  } else {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    return [[[Application moviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingString:@"-small.png"];
  }
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

  [self.model.largePosterCache downloadFirstPosterForMovie:movie];

  // if we had a network connection, then it means we don't know of any
  // posters for this movie.  record that fact and try again another time
  if ([NetworkUtilities isNetworkAvailable]) {
    return [NSData data];
  }

  return nil;
}


- (void) updateMovieDetails:(Movie*) movie force:force {
  NSString* path = [self posterFilePath:movie];

  NSDate* modificationDate = [FileUtilities modificationDate:path];
  if (modificationDate != nil) {
    if ([FileUtilities size:path] > 0) {
      // already have a real poster.
      return;
    }

    if (!force) {
      // sentinel value.  only update if it's been long enough.
      if (ABS(modificationDate.timeIntervalSinceNow) < THREE_DAYS) {
        return;
      }
    }
  }

  NSData* data = [self downloadPosterWorker:movie];
  if (data != nil) {
    [FileUtilities writeData:data toFile:path];

    // If we don't have a poster for this movie, store the netflix poster in the
    // standard poster location as well.
    if (movie.isNetflix &&
        data.length > 0 &&
        ![FileUtilities fileExists:[self standardPosterPath:movie]]) {
      [FileUtilities writeData:data toFile:[self standardPosterPath:movie]];
    }


    if (data.length > 0) {
      [MetasyntacticSharedApplication minorRefresh];
    }
  }
}


- (UIImage*) posterForMovie:(Movie*) movie
               loadFromDisk:(BOOL) loadFromDisk{
  NSString* path = [self posterFilePath:movie];
  return [self.model.imageCache imageForPath:path loadFromDisk:loadFromDisk];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie
                    loadFromDisk:(BOOL) loadFromDisk {
  NSString* smallPosterPath = [self smallPosterFilePath:movie];

  UIImage* image = [self.model.imageCache imageForPath:smallPosterPath loadFromDisk:loadFromDisk];
  if (image != nil || !loadFromDisk) {
    return image;
  }

  NSData* smallPosterData;
  if ([FileUtilities size:smallPosterPath] == 0) {
    NSData* normalPosterData = [FileUtilities readData:[self posterFilePath:movie]];
    smallPosterData = [ImageUtilities scaleImageData:normalPosterData
                                            toHeight:SMALL_POSTER_HEIGHT];

    [FileUtilities writeData:smallPosterData toFile:smallPosterPath];
    // If we don't have a poster for this movie, store the netflix poster in the
    // standard poster location as well.
    if (movie.isNetflix &&
        smallPosterData.length > 0 &&
        ![FileUtilities fileExists:[self smallPosterPath:movie]]) {
      [FileUtilities writeData:smallPosterData toFile:[self smallPosterPath:movie]];
    }

    UIImage* image = [UIImage imageWithData:smallPosterData];
    [self.model.imageCache setImage:image forPath:smallPosterPath];
    return image;
  }

  return nil;
}

@end
