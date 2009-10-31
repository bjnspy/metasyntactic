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

#import "AbstractDVDBlurayCache.h"

#import "CacheUpdater.h"
#import "DVD.h"
#import "Model.h"

@interface AbstractDVDBlurayCache()
@property (retain) ThreadsafeValue* moviesSetData;
@property (retain) ThreadsafeValue* moviesData;
@property (retain) ThreadsafeValue* bookmarksData;
@property BOOL updated;
@end


@implementation AbstractDVDBlurayCache

@synthesize moviesSetData;
@synthesize moviesData;
@synthesize bookmarksData;
@synthesize updated;

- (void) dealloc {
  self.moviesSetData = nil;
  self.moviesData = nil;
  self.bookmarksData = nil;
  self.updated = NO;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.bookmarksData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadBookmarks) saveSelector:@selector(saveBookmarks:)];
    self.moviesSetData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadMoviesSet) saveSelector:nil];
    self.moviesData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadMovies) saveSelector:@selector(saveMovies:)];
  }

  return self;
}


- (Model*) model {
  return [Model model];
}


- (NSString*) serverAddress {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSString*) directory {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSString*) detailsDirectory {
  return [self.directory stringByAppendingPathComponent:@"Details"];
}


- (NSString*) moviesFile {
  return [[self directory] stringByAppendingPathComponent:@"Movies.plist"];
}


- (NSArray*) loadMovies {
  NSArray* encodedMovies = [FileUtilities readObject:self.moviesFile];
  return [Movie decodeArray:encodedMovies];
}


- (void) saveMovies:(NSArray*) movies {
  [FileUtilities writeObject:[Movie encodeArray:movies] toFile:self.moviesFile];
}


- (void) setMovies:(NSArray*) array {
  moviesData.value = array;
  moviesSetData.value = [PointerSet setWithArray:array];
}


- (NSArray*) movies {
  return moviesData.value;
}


- (NSSet*) loadMoviesSet {
  return [PointerSet setWithArray:self.movies];
}


- (NSSet*) moviesSet {
  return moviesSetData.value;
}


- (NSArray*) loadBookmarksArray {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSDictionary*) loadBookmarks {
  NSArray* movies = [self loadBookmarksArray];
  if (movies.count == 0) {
    return [NSMutableDictionary dictionary];
  }

  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  for (Movie* movie in movies) {
    [result setObject:movie forKey:movie.canonicalTitle];
  }

  return result;
}


- (void) saveBookmarks:(NSDictionary*) bookmarks {
  [self.model setBookmarkedDVD:bookmarks.allValues];
}


- (NSDictionary*) bookmarks {
  return bookmarksData.value;
}


- (void) update {
  if (self.model.userAddress.length == 0) {
    return;
  }

  if (!self.model.dvdBlurayCacheEnabled) {
    return;
  }

  if (updated) {
    return;
  }
  self.updated = YES;

  [[OperationQueue operationQueue] performSelector:@selector(updateMoviesBackgroundEntryPoint)
                                          onTarget:self
                                              gate:nil
                                          priority:Priority];
}


- (NSArray*) split:(NSString*) value {
  if (value.length == 0) {
    return [NSArray array];
  }

  return [value componentsSeparatedByString:@"/"];
}


- (NSString*) massage:(NSString*) text {
  unichar a1[] = { 0xE2, 0x20AC, 0x201C };
  text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a1 length:ArrayLength(a1)]
                                         withString:@"-"];

  unichar a2[] = { 0xEF, 0xBF, 0xBD };
  text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a2 length:ArrayLength(a2)]
                                         withString:@"'"];

  unichar a3[] = { 0xE2, 0x20AC, 0x153 };
  text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a3 length:ArrayLength(a3)]
                                         withString:@"\""];

  unichar a4[] = { 0xE2, 0x20AC, 0x9D };
  text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a4 length:ArrayLength(a4)]
                                         withString:@"\""];

  unichar a5[] = { 0xE2, 0x20AC, 0x2122 };
  text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a5 length:ArrayLength(a5)]
                                         withString:@"'"];

  unichar a6[] = { 0xC2, 0xA0 };
  text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a6 length:ArrayLength(a6)]
                                         withString:@" "];

  unichar a7[] = { 0xE2, 0x20AC, 0x201D };
  text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a7 length:ArrayLength(a7)]
                                         withString:@"-"];

  unichar a8[] = { 0xC2, 0xAE };
  text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a8 length:ArrayLength(a8)]
                                         withString:@"Â®"];

  unichar a9[] = { 0xE2, 0x20AC, 0xA2 };
  text = [text stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:a9 length:ArrayLength(a9)]
                                         withString:@"â€¢"];

  return text;
}


- (void) processVideoElement:(XmlElement*) videoElement
                      result:(NSMutableDictionary*) result {
  NSString* title = [videoElement attributeValue:@"title"];
  NSString* releaseDateString = [videoElement attributeValue:@"release_date"];
  NSString* price = [videoElement attributeValue:@"retail_price"];
  NSString* rating = [videoElement attributeValue:@"mpaa_rating"];
  NSString* format = [videoElement attributeValue:@"format"];
  NSArray* genres = [self split:[videoElement attributeValue:@"genre"]];
  NSArray* cast = [self split:[videoElement attributeValue:@"cast"]];
  NSArray* directors = [self split:[videoElement attributeValue:@"director"]];
  NSString* discs = [videoElement attributeValue:@"discs"];
  NSString* poster = [videoElement attributeValue:@"image"];
  NSString* synopsis = [videoElement attributeValue:@"synopsis"];
  NSDate* releaseDate = [DateUtilities parseISO8601Date:releaseDateString];
  NSString* url = [videoElement attributeValue:@"url"];
  NSString* length = [videoElement attributeValue:@"length"];
  NSString* studio = [videoElement attributeValue:@"studio"];

  synopsis = [self massage:synopsis];

  DVD* dvd = [DVD dvdWithTitle:title
                         price:price
                        format:format
                         discs:discs
                           url:url];

  Movie* movie = [Movie movieWithIdentifier:[NSString stringWithFormat:@"%@-%@", title, NSStringFromClass([self class])]
                                      title:title
                                     rating:rating
                                     length:[length intValue]
                                releaseDate:releaseDate
                                imdbAddress:@""
                                     poster:poster
                                   synopsis:synopsis
                                     studio:studio
                                  directors:directors
                                       cast:cast
                                     genres:genres];

  [result setObject:dvd forKey:movie];
}


- (NSDictionary*) processElement:(XmlElement*) element {
  NSMutableDictionary* result = [NSMutableDictionary dictionary];

  for (XmlElement* child in element.children) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      [self processVideoElement:child result:result];
    }
    [pool release];
  }

  return result;
}


- (NSString*) detailsFile:(Movie*) movie set:(NSSet*) movies {
  if (movies == nil || [movies containsObject:movie]) {
    return [[[self detailsDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]]
            stringByAppendingString:@".plist"];
  }

  return nil;
}


- (NSString*) detailsFile:(Movie*) movie {
  NSAssert([NSThread isMainThread], @"");

  return [self detailsFile:movie set:self.moviesSet];
}


- (void) saveData:(NSDictionary*) dictionary {
  for (Movie* movie in dictionary) {
    DVD* dvd = [dictionary objectForKey:movie];
    [FileUtilities writeObject:dvd.dictionary toFile:[self detailsFile:movie set:nil]];
  }
}


- (void) updateMoviesBackgroundEntryPointWorker {
  XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:self.serverAddress pause:NO];

  if (element == nil) {
    return;
  }

  NSDictionary* map = [self processElement:element];

  if (map.count == 0) {
    return;
  }

  NSMutableArray* movies = [NSMutableArray arrayWithArray:map.allKeys];
  // add in any previously bookmarked movies that we now no longer know about.
  for (Movie* movie in self.bookmarks.allValues) {
    if (![movies containsObject:movie]) {
      [movies addObject:movie];
    }
  }

  // also determine if any of the data we found match items the user bookmarked
  NSMutableDictionary* bookmarks = [NSMutableDictionary dictionaryWithDictionary:self.bookmarks];
  for (Movie* movie in movies) {
    if ([self.model isBookmarked:movie]) {
      [bookmarks setObject:movie forKey:movie.canonicalTitle];
    }
  }
  bookmarksData.value = bookmarks;

  [self saveData:map];

  [dataGate lock];
  {
    [self setMovies:movies];
    [self clearUpdatedMovies];
  }
  [dataGate unlock];

  [MetasyntacticSharedApplication majorRefresh];
}


- (NSString*) notificationString {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) tooSoon {
  NSDate* lastUpdateDate = [FileUtilities modificationDate:self.moviesFile];
  return lastUpdateDate != nil &&
  (ABS(lastUpdateDate.timeIntervalSinceNow) < THREE_DAYS);
}


- (void) updateMoviesBackgroundEntryPoint {
  if (![self tooSoon]) {
    NSString* notification = [self notificationString];
    [NotificationCenter addNotification:notification];
    {
      [self updateMoviesBackgroundEntryPointWorker];
    }
    [NotificationCenter removeNotification:notification];
  }

  NSArray* movies = self.movies;
  [[CacheUpdater cacheUpdater] addMovies:movies];
}


- (void) updateMovieDetails:(Movie*) movie force:(BOOL) force {
}


- (DVD*) detailsForMovie:(Movie*) movie {
  NSDictionary* dictionary = [FileUtilities readObject:[self detailsFile:movie]];
  if (dictionary == nil) {
    return nil;
  }

  return [DVD createWithDictionary:dictionary];
}


- (void) addBookmark:(NSString*) canonicalTitle {
  for (Movie* movie in self.movies) {
    if ([movie.canonicalTitle isEqual:canonicalTitle]) {
      NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:self.bookmarks];
      [dictionary setObject:movie forKey:canonicalTitle];
      bookmarksData.value = dictionary;
      return;
    }
  }
}


- (void) removeBookmark:(NSString*) canonicalTitle {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:self.bookmarks];
  [dictionary removeObjectForKey:canonicalTitle];
  bookmarksData.value = dictionary;
}

@end
