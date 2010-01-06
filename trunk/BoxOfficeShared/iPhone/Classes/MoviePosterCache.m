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

#import "MoviePosterCache.h"

#import "ApplePosterDownloader.h"
#import "Application.h"
#import "FandangoPosterDownloader.h"
#import "ImdbPosterDownloader.h"
#import "LargePosterCache.h"
#import "PreviewNetworksPosterDownloader.h"

@interface MoviePosterCache()
@property (retain) ImdbPosterDownloader* imdbPosterDownloader;
@property (retain) ApplePosterDownloader* applePosterDownloader;
@property (retain) FandangoPosterDownloader* fandangoPosterDownloader;
@property (retain) PreviewNetworksPosterDownloader* previewNetworksPosterDownloader;
@end


@implementation MoviePosterCache

static MoviePosterCache* cache;

+ (void) initialize {
  if (self == [MoviePosterCache class]) {
    cache = [[MoviePosterCache alloc] init];
  }
}


+ (MoviePosterCache*) cache {
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
  return [[Application sentinelsMoviesPostersDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.identifier]];
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


- (NSData*) downloadPoster:(Movie*) movie {
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


- (Movie*) appropriateMovie:(Movie*) movie {
  Movie* possible = [[NetflixCache cache] correspondingNetflixMovie:movie];
  if (possible != nil) {
    return possible;
  }

  return movie;
}


- (void) updateMovieDetails:(Movie*) movie force:(BOOL) force {
  [self updateObjectDetails:movie force:force];
  [self updateObjectDetails:[self appropriateMovie:movie] force:force];
}


- (UIImage*) posterForMovie:(Movie*) movie loadFromDisk:(BOOL) loadFromDisk {
  UIImage* image;
  if ((image = [self posterForObject:movie loadFromDisk:loadFromDisk]) != nil ||
      (image = [self posterForObject:[self appropriateMovie:movie] loadFromDisk:loadFromDisk]) != nil) {
    return image;
  }
  return nil;
}


- (UIImage*) smallPosterForMovie:(Movie*) movie
                    loadFromDisk:(BOOL) loadFromDisk {
  UIImage* image;
  if ((image = [self smallPosterForObject:movie loadFromDisk:loadFromDisk]) != nil ||
      (image = [self smallPosterForObject:[self appropriateMovie:movie] loadFromDisk:loadFromDisk]) != nil) {
    return image;
  }
  return nil;
}

@end
