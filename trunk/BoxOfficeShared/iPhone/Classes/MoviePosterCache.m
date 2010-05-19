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
