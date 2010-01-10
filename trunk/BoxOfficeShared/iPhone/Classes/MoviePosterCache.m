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

#import "AppleMoviePosterDownloader.h"
#import "Application.h"
#import "FandangoMoviePosterDownloader.h"
#import "ImdbMoviePosterDownloader.h"
#import "LargeMoviePosterCache.h"
#import "PreviewNetworksMoviePosterDownloader.h"

@interface MoviePosterCache()
@property (retain) ImdbMoviePosterDownloader* imdbDownloader;
@property (retain) AppleMoviePosterDownloader* appleDownloader;
@property (retain) FandangoMoviePosterDownloader* fandangoDownloader;
@property (retain) PreviewNetworksMoviePosterDownloader* previewNetworksDownloader;
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

@synthesize imdbDownloader;
@synthesize appleDownloader;
@synthesize fandangoDownloader;
@synthesize previewNetworksDownloader;

- (void) dealloc {
  self.imdbDownloader = nil;
  self.appleDownloader = nil;
  self.fandangoDownloader = nil;
  self.previewNetworksDownloader = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.imdbDownloader = [[[ImdbMoviePosterDownloader alloc] init] autorelease];
    self.appleDownloader = [[[AppleMoviePosterDownloader alloc] init] autorelease];
    self.fandangoDownloader = [[[FandangoMoviePosterDownloader alloc] init] autorelease];
    self.previewNetworksDownloader = [[[PreviewNetworksMoviePosterDownloader alloc] init] autorelease];
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

  data = [previewNetworksDownloader download:movie];
  if (data != nil) {
    return data;
  }

  data = [appleDownloader download:movie];
  if (data != nil) {
    return data;
  }

  data = [fandangoDownloader download:movie];
  if (data != nil) {
    return data;
  }

  data = [imdbDownloader download:movie];
  if (data != nil) {
    return data;
  }

  [[LargeMoviePosterCache cache] downloadFirstPosterForMovie:movie];

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
