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

#import "LargePosterCache.h"

#import "Application.h"
#import "Model.h"

@interface LargePosterCache()
@property (retain) AutoreleasingMutableDictionary* yearToMovieNames;
@property (retain) AutoreleasingMutableDictionary* yearToTitleToPosterUrls;
@property BOOL updated;
@end

@implementation LargePosterCache

static LargePosterCache* cache;

+ (void) initialize {
  if (self == [LargePosterCache class]) {
    cache = [[LargePosterCache alloc] init];
  }
}

@synthesize yearToMovieNames;
@synthesize yearToTitleToPosterUrls;
@synthesize updated;

const NSInteger UNKNOWN_YEAR = 0;
const NSInteger START_YEAR = 1912;

- (void) dealloc {
  self.yearToMovieNames = nil;
  self.yearToTitleToPosterUrls = nil;
  self.updated = NO;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.yearToMovieNames = [AutoreleasingMutableDictionary dictionary];
    self.yearToTitleToPosterUrls = [AutoreleasingMutableDictionary dictionary];
  }

  return self;
}


+ (LargePosterCache*) cache {
  return cache;
}


- (NSString*) posterFilePath:(Movie*) movie
                       index:(NSInteger) index {
  NSString* sanitizedTitle;
  if (movie.isNetflix) {
    sanitizedTitle = [FileUtilities sanitizeFileName:movie.simpleNetflixIdentifier];
  } else {
    sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
  }

  sanitizedTitle = [sanitizedTitle stringByAppendingFormat:@"-%d", index];
  return [[[Application largeMoviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (NSString*) smallPosterFilePath:(Movie*) movie {
  NSString* sanitizedTitle;
  if (movie.isNetflix) {
    sanitizedTitle = [FileUtilities sanitizeFileName:movie.simpleNetflixIdentifier];
  } else {
    sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
  }

  sanitizedTitle = [sanitizedTitle stringByAppendingFormat:@"-0-small", index];
  return [[[Application largeMoviesPostersDirectory] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"png"];
}


- (NetflixCache*) netflixCache {
  return [NetflixCache cache];
}


- (Movie*) appropriateMovie:(Movie*) movie {
  Movie* possible = [self.netflixCache correspondingNetflixMovie:movie];
  if (possible != nil) {
    return possible;
  }

  return movie;
}


- (ImageCache*) imageCache {
  return [ImageCache cache];
}


- (UIImage*) posterForMovie:(Movie*) movie
                      index:(NSInteger) index
               loadFromDisk:(BOOL) loadFromDisk {
  movie = [self appropriateMovie:movie];
  NSString* path = [self posterFilePath:movie index:index];
  return [self.imageCache imageForPath:path loadFromDisk:loadFromDisk];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie
                    loadFromDisk:(BOOL) loadFromDisk {
  NSAssert([NSThread isMainThread], @"");
  movie = [self appropriateMovie:movie];

  NSString* smallPosterPath = [self smallPosterFilePath:movie];
  UIImage* image = [self.imageCache imageForPath:smallPosterPath loadFromDisk:loadFromDisk];
  if (image != nil || !loadFromDisk) {
    return image;
  }

  NSData* smallPosterData;
  if ([FileUtilities size:smallPosterPath] == 0) {
    NSData* normalPosterData = [FileUtilities readData:[self posterFilePath:movie index:0]];
    smallPosterData = [ImageUtilities scaleImageData:normalPosterData
                                            toHeight:SMALL_POSTER_HEIGHT];
    [FileUtilities writeData:smallPosterData
                      toFile:smallPosterPath];

    UIImage* image = [UIImage imageWithData:smallPosterData];
    [self.imageCache setImage:image forPath:smallPosterPath];
    return image;
  }

  return nil;
}


- (BOOL) posterExistsForMovie:(Movie*) movie
                        index:(NSInteger) index {
  movie = [self appropriateMovie:movie];
  NSString* path = [self posterFilePath:movie index:index];
  return [FileUtilities fileExists:path];
}


- (UIImage*) posterForMovie:(Movie*) movie
               loadFromDisk:(BOOL) loadFromDisk {
  movie = [self appropriateMovie:movie];
  NSAssert([NSThread isMainThread], @"");
  return [self posterForMovie:movie index:0 loadFromDisk:loadFromDisk];
}


- (NSString*) indexFile:(NSInteger) year {
  NSString* file = [NSString stringWithFormat:@"%d-Index.plist", year];
  return [[Application largeMoviesPostersIndexDirectory] stringByAppendingPathComponent:file];
}


- (NSString*) mapFile:(NSInteger) year {
  NSString* file = [NSString stringWithFormat:@"%d-Map.plist", year];
  return [[Application largeMoviesPostersIndexDirectory] stringByAppendingPathComponent:file];
}


+ (NSDictionary*) processPosterListings:(XmlElement*) posterListingsElement  {
  if (posterListingsElement == nil) {
    return nil;
  }

  NSMutableDictionary* titleToPosters = [NSMutableDictionary dictionary];

  for (XmlElement* itemElement in posterListingsElement.children) {
    NSString* title = [itemElement attributeValue:@"title"];
    title = [StringUtilities makeCanonical:title];
    title = [title lowercaseString];

    if (title.length == 0) {
      continue;
    }

    NSMutableArray* posters = [NSMutableArray array];
    for (XmlElement* locElement in itemElement.children) {
      NSString* poster = [locElement text];
      if (poster.length > 0) {
        [posters addObject:poster];
      }
    }

    if (posters.count > 0) {
      [titleToPosters setObject:posters forKey:title];
    }
  }

  if (titleToPosters.count == 0) {
    return nil;
  }

  return titleToPosters;
}


- (void) ensureIndexWorker:(NSInteger) year
             updateIfStale:(BOOL) updateIfStale {
  NSString* indexFile = [self indexFile:year];
  if ([FileUtilities fileExists:indexFile]) {
    if (!updateIfStale) {
      return;
    }

    NSDate* modificationDate = [FileUtilities modificationDate:indexFile];
    if (modificationDate != nil) {
      if (ABS(modificationDate.timeIntervalSinceNow) < ONE_WEEK) {
        return;
      }
    }
  }

  NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupPosterListings%@?provider=imp&year=%d",
                       [Application apiHost], [Application apiVersion], year];
  XmlElement* result = [NetworkUtilities xmlWithContentsOfAddress:address pause:NO];

  NSDictionary* titleToPosters = [LargePosterCache processPosterListings:result];

  if (titleToPosters.count > 0) {
    [FileUtilities writeObject:titleToPosters.allKeys toFile:indexFile];
    [FileUtilities writeObject:titleToPosters toFile:[self mapFile:year]];
  }
}


- (void) ensureIndex:(NSInteger) year
       updateIfStale:(BOOL) updateIfStale {
  [self ensureIndexWorker:year updateIfStale:updateIfStale];
  NSArray* array = [FileUtilities readObject:[self indexFile:year]];

  if (array.count > 0) {
    [dataGate lock];
    {
      [yearToMovieNames setObject:array forKey:[NSNumber numberWithInteger:year]];
    }
    [dataGate unlock];
    [self clearUpdatedMovies];
  }
}


- (NSInteger) yearForDate:(NSDate*) date {
  NSDateComponents* components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:date];
  return components.year;
}


- (NSInteger) currentYear {
  NSDate* date = [DateUtilities today];
  return [self yearForDate:date];
}


- (void) update {
  if (![Model model].largePosterCacheEnabled) {
    return;
  }

  if (updated) {
    return;
  }
  self.updated = YES;

  [ThreadingUtilities backgroundSelector:@selector(ensureIndices)
                                onTarget:self
                                    gate:nil
                                  daemon:NO];
}


- (void) ensureIndices {
  NSInteger year = self.currentYear;
  for (NSInteger i = year + 1; i >= START_YEAR; i--) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      BOOL updateIfStale = (i >= (year - 1) && i <= (year + 1));
      [self ensureIndex:i updateIfStale:updateIfStale];
    }
    [pool release];
  }
}


- (NSArray*) posterNames:(Movie*) movie year:(NSInteger) year {
  NSArray* movieNames;
  [dataGate lock];
  {
    movieNames = [yearToMovieNames objectForKey:[NSNumber numberWithInteger:year]];
  }
  [dataGate unlock];

  NSString* lowercaseTitle = movie.canonicalTitle.lowercaseString;
  if ([movieNames containsObject:lowercaseTitle]) {
    NSDictionary* dictionary = [FileUtilities readObject:[self mapFile:year]];
    return [dictionary objectForKey:lowercaseTitle];
  }

  for (NSString* key in movieNames) {
    if ([DifferenceEngine substringSimilar:key other:lowercaseTitle]) {
      NSDictionary* dictionary = [FileUtilities readObject:[self mapFile:year]];
      return [dictionary objectForKey:key];
    }
  }

  return [NSArray array];
}


- (NSArray*) posterUrls:(Movie*) movie year:(NSInteger) year {
  NSArray* result = [self posterNames:movie year:year];
  if (result.count == 0) {
    return result;
  }

  NSMutableArray* urls = [NSMutableArray array];
  for (NSString* name in result) {
    NSString* url = [NSString stringWithFormat:@"http://www.impawards.com/%d/posters/%@", year, name];
    [urls addObject:url];
  }
  return urls;
}


- (NSArray*) posterUrlsWorker:(Movie*) movie
                         year:(NSInteger) releaseYear {
  if (releaseYear == UNKNOWN_YEAR) {
    NSInteger currentYear = self.currentYear;
    for (NSInteger i = currentYear + 1; i >= START_YEAR; i--) {
      NSArray* result = [self posterUrls:movie year:i];
      if (result.count > 0) {
        return result;
      }
    }
  } else {
    NSArray* result;
    if ((result = [self posterUrls:movie year:releaseYear]).count > 0 ||
        (result = [self posterUrls:movie year:releaseYear - 1]).count > 0 ||
        (result = [self posterUrls:movie year:releaseYear - 2]).count > 0 ||
        (result = [self posterUrls:movie year:releaseYear + 1]).count > 0 ||
        (result = [self posterUrls:movie year:releaseYear + 2]).count > 0) {
      return result;
    }
  }

  return [NSArray array];
}


- (NSArray*) posterUrlsFromCache:(Movie*) movie year:(NSInteger) year {
  NSArray* result;

  NSMutableDictionary* titleToPosterUrls;
  [dataGate lock];
  {
    NSNumber* yearNumber = [NSNumber numberWithInteger:year];
    titleToPosterUrls = [yearToTitleToPosterUrls objectForKey:yearNumber];
    if (titleToPosterUrls == nil) {
      titleToPosterUrls = [NSMutableDictionary dictionary];
      [yearToTitleToPosterUrls setObject:titleToPosterUrls forKey:yearNumber];
    }
    result = [titleToPosterUrls objectForKey:movie.canonicalTitle];
  }
  [dataGate unlock];

  if (result == nil) {
    result = [self posterUrlsWorker:movie year:year];
    if (result.count > 0) {
      [dataGate lock];
      {
        [titleToPosterUrls setObject:result forKey:movie.canonicalTitle];
      }
      [dataGate unlock];
    }
  }
  return result;
}


- (NSArray*) posterUrls:(Movie*) movie {
  NSDate* date = movie.releaseDate;

  NSInteger year;
  if (date == nil) {
    year = UNKNOWN_YEAR;
  } else {
    year = [self yearForDate:date];
  }
  return [self posterUrlsFromCache:movie year:year];
}


- (NSData*) resizeImage:(NSData*) data {
  UIImage* image = [[[UIImage alloc] initWithData:data] autorelease];
  if (image == nil) {
    return nil;
  }

  CGSize size = image.size;
  if (size.height >= size.width && image.size.height > (FULL_SCREEN_POSTER_HEIGHT + 1)) {
    return [ImageUtilities scaleImageData:data
                                 toHeight:FULL_SCREEN_POSTER_HEIGHT];

  } else if (size.width >= size.height && image.size.width > (FULL_SCREEN_POSTER_HEIGHT + 1)) {
    return [ImageUtilities scaleImageData:data
                                 toHeight:FULL_SCREEN_POSTER_WIDTH];
  }

  return data;
}


- (NSData*) uploadUrl:(NSString*) url
                 data:(NSData*) data
         insertionKey:(NSString*) insertionKey {
  // First resize down to our max image dimensions
  data = [self resizeImage:data];
  if (data.length == 0) {
    // we couldn't resize.  throw this data away.
    return nil;
  }

  NSString* cacheUrl = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource%@",
                        [Application apiHost], [Application apiVersion]];

  NSMutableURLRequest* request = [NetworkUtilities createRequest:[NSURL URLWithString:cacheUrl]];
  [request setHTTPMethod:@"POST"];

  NSArray* parameters = [NSArray arrayWithObjects:
                         [OARequestParameter parameterWithName:@"q" value:url],
                         [OARequestParameter parameterWithName:@"insertion_key" value:insertionKey],
                         [OARequestParameter parameterWithName:@"body" value:[Base64 encode:data]], nil];

  [NSMutableURLRequestAdditions setParameters:parameters
                                   forRequest:request];

  NSURLResponse* urlResponse = nil;
  NSError* error = nil;
  [NSURLConnection sendSynchronousRequest:request
                        returningResponse:&urlResponse
                                    error:&error];

  return data;
}


- (NSData*) downloadUrlData:(NSString*) url {
  NSString* noFetchCacheUrl = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource%@?q=%@&lookup_only=true",
                               [Application apiHost], [Application apiVersion],
                               [StringUtilities stringByAddingPercentEscapes:url]];

  // Try first from the cache.
  NSHTTPURLResponse* response = nil;
  NSData* data = [NetworkUtilities dataWithContentsOfAddress:noFetchCacheUrl response:&response pause:NO];
  if (data.length == 0) {

    // Wasn't in the cache.  Get directly from the source.
    data = [NetworkUtilities dataWithContentsOfAddress:url pause:NO];

    NSString* insertionKey = [[response allHeaderFields] objectForKey:@"Insertion-Key"];
    if (data.length > 0 && insertionKey.length > 0) {

      // Now store in the cache.
      data = [self uploadUrl:url data:data insertionKey:insertionKey];
    }
  }

  return data;
}


- (void) downloadPosterForMovieWorker:(Movie*) movie
                                 urls:(NSArray*) urls
                                index:(NSInteger) index {
  NSAssert(![NSThread isMainThread], @"");
  if (index < 0 || index >= urls.count) {
    return;
  }

  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  {
    NSString* url = [urls objectAtIndex:index];

    NSData* data = [self downloadUrlData:url];

    if (data.length > 0) {
      [FileUtilities writeData:data toFile:[self posterFilePath:movie index:index]];
      [MetasyntacticSharedApplication minorRefresh];
    }
  }
  [pool release];
}


- (void) downloadPosterForMovie:(Movie*) movie
                           urls:(NSArray*) urls
                          index:(NSInteger) index {
  NSAssert(![NSThread isMainThread], @"");
  if (![FileUtilities fileExists:[self posterFilePath:movie index:index]]) {
    [self downloadPosterForMovieWorker:movie urls:urls index:index];
  }
}


- (void) downloadFirstPosterForMovie:(Movie*) movie {
  movie = [self appropriateMovie:movie];
  NSArray* urls = [self posterUrls:movie];
  [self downloadPosterForMovie:movie urls:urls index:0];
}


- (void) downloadAllPostersForMovie:(Movie*) movie {
  movie = [self appropriateMovie:movie];
  NSArray* urls = [self posterUrls:movie];
  for (NSInteger i = 0; i < urls.count; i++) {
    [self downloadPosterForMovie:movie urls:urls index:i];
  }
}


- (NSInteger) posterCountForMovie:(Movie*) movie {
  movie = [self appropriateMovie:movie];
  return [[self posterUrls:movie] count];
}


- (BOOL) allPostersDownloadedForMovie:(Movie*) movie {
  movie = [self appropriateMovie:movie];
  NSInteger posterCount = [self posterCountForMovie:movie];

  for (NSInteger i = 0; i < posterCount; i++) {
    if (![FileUtilities fileExists:[self posterFilePath:movie index:i]]) {
      return NO;
    }
  }

  return YES;
}

@end
