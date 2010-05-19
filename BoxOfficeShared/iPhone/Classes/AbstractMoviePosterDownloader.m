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

#import "AbstractMoviePosterDownloader.h"

#import "Application.h"

@interface AbstractMoviePosterDownloader()
@property (retain) NSDictionary* movieNameToPosterMap;
@property (retain) NSLock* gate;
@end

@implementation AbstractMoviePosterDownloader

@synthesize movieNameToPosterMap;
@synthesize gate;

- (void) dealloc {
  self.movieNameToPosterMap = nil;
  self.gate = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.gate = [[[NSLock alloc] init] autorelease];
  }

  return self;
}


- (NSDictionary*) createMapWorker AbstractMethod;


- (NSString*) indexFile {
  NSString* name = [NSString stringWithFormat:@"%@.plist", NSStringFromClass([self class])];
  return [[Application moviesPostersDirectory] stringByAppendingPathComponent:name];
}


- (BOOL) tooSoon {
  NSDate* modificationDate = [FileUtilities modificationDate:[self indexFile]];
  if (modificationDate == nil) {
    return NO;
  }

  return ABS([modificationDate timeIntervalSinceNow]) < ONE_DAY;
}


- (NSDictionary*) createMap {
  NSDictionary* existingMap = [FileUtilities readObject:[self indexFile]];
  if (existingMap.count > 0 && [self tooSoon]) {
    // we had a usable existing map.  use that for now.
    return existingMap;
  }

  // We either didn't have a map, or too much time has passed.
  // try to get an up to date map.

  NSDictionary* currentMap = [self createMapWorker];
  if (currentMap.count > 0) {
    // we got a good map.  store it for the future.
    [FileUtilities writeObject:currentMap toFile:[self indexFile]];
    return currentMap;
  }

  // we didn't get a new map.  use the old one if it has usable data.
  if (existingMap.count > 0) {
    return existingMap;
  }

  // no good date.  just return an empty map.
  return [NSDictionary dictionary];
}


- (NSData*) downloadWorker:(Movie*) movie {
  if (movieNameToPosterMap == nil) {
    self.movieNameToPosterMap = [self createMap];
  }

  NSString* key = [[DifferenceEngine engine] findClosestMatch:movie.canonicalTitle.lowercaseString
                                                      inArray:movieNameToPosterMap.allKeys];
  if (key == nil) {
    return nil;
  }

  NSArray* posterUrls = [movieNameToPosterMap objectForKey:key];
  if (![posterUrls isKindOfClass:[NSArray class]]) {
    [Application moveItemToTrash:[self indexFile]];
    self.movieNameToPosterMap = nil;
    return nil;
  }
  if (posterUrls.count == 0) {
    return nil;
  }

  NSString* url = posterUrls.firstObject;
  return [NetworkUtilities dataWithContentsOfAddress:url pause:NO];
}


- (NSData*) download:(Movie*) movie {
  NSData* result;
  [gate lock];
  {
    result = [self downloadWorker:movie];
  }
  [gate unlock];
  return result;
}

@end
