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

#import "UpcomingCache.h"

#import "Application.h"
#import "CacheUpdater.h"
#import "Model.h"

@interface UpcomingCache()
@property (retain) ThreadsafeValue* hashData;
@property (retain) ThreadsafeValue* movieMapData;
@property (retain) ThreadsafeValue* studioKeysData;
@property (retain) ThreadsafeValue* titleKeysData;
@property (retain) ThreadsafeValue* bookmarksData;
@property BOOL updated;
@end


@implementation UpcomingCache

@synthesize hashData;
@synthesize movieMapData;
@synthesize studioKeysData;
@synthesize titleKeysData;
@synthesize bookmarksData;
@synthesize updated;

- (void) dealloc {
  self.hashData = nil;
  self.movieMapData = nil;
  self.studioKeysData = nil;
  self.titleKeysData = nil;
  self.bookmarksData = nil;
  self.updated = NO;

  [super dealloc];
}


- (NSString*) hashFile {
  return [[Application upcomingDirectory] stringByAppendingPathComponent:@"Hash.plist"];
}


- (NSString*) studiosFile {
  return [[Application upcomingDirectory] stringByAppendingPathComponent:@"Studios.plist"];
}


- (NSString*) titlesFile {
  return [[Application upcomingDirectory] stringByAppendingPathComponent:@"Titles.plist"];
}


- (id) init {
  if ((self = [super init])) {
    self.hashData = [PersistentStringThreadsafeValue valueWithGate:dataGate file:self.hashFile];
    self.movieMapData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadMovieMap) saveSelector:@selector(saveMovieMap:)];
    self.studioKeysData = [PersistentDictionaryThreadsafeValue valueWithGate:dataGate file:self.studiosFile];
    self.titleKeysData = [PersistentDictionaryThreadsafeValue valueWithGate:dataGate file:self.titlesFile];
    self.bookmarksData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadBookmarks) saveSelector:@selector(saveBookmarks:)];
  }

  return self;
}


+ (UpcomingCache*) cache {
  return [[[UpcomingCache alloc] init] autorelease];
}


- (Model*) model {
  return [Model model];
}


- (NSString*) moviesFile {
  return [[Application upcomingDirectory] stringByAppendingPathComponent:@"Movies.plist"];
}


- (NSArray*) processArray:(XmlElement*) element attribute:(NSString*) attribute {
  NSMutableArray* array = [NSMutableArray array];

  for (XmlElement* child in element.children) {
    [array addObject:[child attributeValue:attribute]];
  }

  return array;
}


- (NSString*) massageTitle:(NSString*) title {
  return [title stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
}


- (Movie*) processMovieElement:(XmlElement*) movieElement
                    studioKeys:(NSMutableDictionary*) studioKeys
                     titleKeys:(NSMutableDictionary*) titleKeys  {
  NSDate* releaseDate = [DateUtilities dateWithNaturalLanguageString:[movieElement attributeValue:@"date"]];
  NSString* poster = [movieElement attributeValue:@"poster"];
  NSString* rating = [movieElement attributeValue:@"rating"];
  NSString* studio = [movieElement attributeValue:@"studio"];
  NSString* title = [movieElement attributeValue:@"title"];
  title = [self massageTitle:title];
  NSArray* directors = [self processArray:[movieElement element:@"Directors"] attribute:@"name"];
  NSArray* cast = [self processArray:[movieElement element:@"Cast"] attribute:@"name"];
  NSArray* genres = [self processArray:[movieElement element:@"Genres"] attribute:@"value"];

  NSString* studioKey = [movieElement attributeValue:@"studio_key"];
  NSString* titleKey = [movieElement attributeValue:@"title_key"];
  if (studioKey.length == 0 || titleKey.length == 0) {
    return nil;
  }

  Movie* movie = [Movie movieWithIdentifier:[NSString stringWithFormat:@"%@-Upcoming", title]
                                      title:title
                                     rating:rating
                                     length:0
                                releaseDate:releaseDate
                                imdbAddress:@""
                                     poster:poster
                                   synopsis:@""
                                     studio:studio
                                  directors:directors
                                       cast:cast
                                     genres:genres];

  [studioKeys setObject:studioKey forKey:movie.canonicalTitle];
  [titleKeys setObject:titleKey forKey:movie.canonicalTitle];

  return movie;
}


- (NSMutableArray*) processResultElement:(XmlElement*) resultElement
                              studioKeys:(NSMutableDictionary*) studioKeys
                               titleKeys:(NSMutableDictionary*) titleKeys {
  NSMutableArray* result = [NSMutableArray array];
  NSDate* cutoff = [NSDate dateWithTimeIntervalSinceNow:-2 * ONE_WEEK];

  for (XmlElement* movieElement in resultElement.children) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      Movie* movie = [self processMovieElement:movieElement studioKeys:studioKeys titleKeys:titleKeys];

      if (movie != nil) {
        if([cutoff compare:movie.releaseDate] != NSOrderedDescending) {
          [result addObject:movie];
        }
      }
    }
    [pool release];
  }

  return result;
}


- (NSDictionary*) loadMovieMap {
  NSArray* array = [FileUtilities readObject:self.moviesFile];
  if (array.count == 0) {
    return [NSDictionary dictionary];
  }

  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  for (NSDictionary* dictionary in array) {
    Movie* movie = [Movie createWithDictionary:dictionary];
    [result setObject:movie forKey:movie.canonicalTitle];
  }

  return result;
}


- (void) saveMovieMap:(NSDictionary*) movieMap {
  [FileUtilities writeObject:[Movie encodeArray:movieMap.allValues] toFile:self.moviesFile];
}


- (NSDictionary*) movieMap {
  return movieMapData.value;
}


- (NSArray*) movies {
  return self.movieMap.allValues;
}


- (NSString*) hashValue {
  return hashData.value;
}


- (NSDictionary*) studioKeys {
  return studioKeysData.value;
}


- (NSDictionary*) titleKeys {
  return titleKeysData.value;
}


- (NSDictionary*) bookmarks {
  return bookmarksData.value;
}


- (NSMutableDictionary*) loadBookmarks {
  NSArray* movies = [self.model bookmarkedUpcoming];
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
  [self.model setBookmarkedUpcoming:bookmarks.allValues];
}


- (NSString*) castFile:(Movie*) movie {
  return [[[Application upcomingCastDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) synopsisFile:(Movie*) movie {
  return [[[Application upcomingSynopsesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) trailersFile:(Movie*) movie {
  return [[[Application upcomingTrailersDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) updateIndexBackgroundEntryPointWorker {
  NSString* localHash = self.hashValue;

  NSString* address1 = [NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingIndex%@?hash=true", [Application apiHost], [Application apiVersion]];
  NSString* serverHash = [NetworkUtilities stringWithContentsOfAddress:address1
                                                                 pause:NO];
  if (serverHash.length == 0) {
    serverHash = @"0";
  }

  if ([localHash isEqual:serverHash]) {
    // save the hash again so we don't check for a few more days.
    [FileUtilities writeObject:serverHash toFile:self.hashFile];
    return;
  }

  NSString* address2 = [NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingIndex%@", [Application apiHost], [Application apiVersion]];
  XmlElement* resultElement = [NetworkUtilities xmlWithContentsOfAddress:address2
                                                                   pause:NO];

  NSMutableDictionary* studioKeys = [NSMutableDictionary dictionary];
  NSMutableDictionary* titleKeys = [NSMutableDictionary dictionary];
  NSMutableArray* movies = [self processResultElement:resultElement studioKeys:studioKeys titleKeys:titleKeys];
  if (movies.count == 0) {
    return;
  }

  // add in any previously bookmarked movies that we now no longer know about.
  for (Movie* movie in self.bookmarks.allValues) {
    if (![movies containsObject:movie]) {
      [movies addObject:movie];
    }
  }

  // also determine if any of the data we found match items the user bookmarked
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:self.bookmarks];
  for (Movie* movie in movies) {
    if ([self.model isBookmarked:movie]) {
      [dictionary setObject:movie forKey:movie.canonicalTitle];
    }
  }

  NSMutableDictionary* movieMap = [NSMutableDictionary dictionary];
  for (Movie* movie in movies) {
    [movieMap setObject:movie forKey:movie.canonicalTitle];
  }

  [dataGate lock];
  {
    titleKeysData.value = titleKeys;
    studioKeysData.value = studioKeys;
    movieMapData.value = movieMap;
    bookmarksData.value = dictionary;

    // do this last, it signifies that we're done.
    hashData.value = serverHash;
    [self clearUpdatedMovies];
  }
  [dataGate unlock];

  [MetasyntacticSharedApplication majorRefresh];
}


- (BOOL) tooSoon {
  NSDate* lastLookupDate = [FileUtilities modificationDate:self.hashFile];
  return lastLookupDate != nil &&
  (ABS(lastLookupDate.timeIntervalSinceNow) < THREE_DAYS);
}


- (void) updateIndexBackgroundEntryPoint {
  if (![self tooSoon]) {
    NSString* notification = [LocalizedString(@"Upcoming", nil) lowercaseString];
    [NotificationCenter addNotification:notification];
    {
      [self updateIndexBackgroundEntryPointWorker];
    }
    [NotificationCenter removeNotification:notification];
  }

  NSArray* movies = self.movieMap.allValues;
  [[CacheUpdater cacheUpdater] addMovies:movies];
}


- (void) update {
  if (self.model.userAddress.length == 0) {
    return;
  }

  if (!self.model.upcomingCacheEnabled) {
    return;
  }

  if (updated) {
    return;
  }
  self.updated = YES;

  [[OperationQueue operationQueue] performSelector:@selector(updateIndexBackgroundEntryPoint)
                                          onTarget:self
                                              gate:nil
                                          priority:Priority];
}


- (void) updateSynopsisAndCast:(Movie*) movie
                         force:(BOOL) force
                        studio:(NSString*) studio
                         title:(NSString*) title {
  if (studio.length == 0 || title.length == 0) {
    return;
  }

  NSString* synopsisFile = [self synopsisFile:movie];

  NSDate* lastLookupDate = [FileUtilities modificationDate:synopsisFile];

  if (lastLookupDate != nil) {
    if (ABS(lastLookupDate.timeIntervalSinceNow) < ONE_WEEK) {
      NSString* synopsis = [FileUtilities readObject:synopsisFile];
      if (synopsis.length > 0) {
        return;
      }

      if (!force) {
        return;
      }
    }
  }

  NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupUpcomingListings%@?studio=%@&name=%@",
                   [Application apiHost], [Application apiVersion], studio, title];
  XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:url pause:NO];

  if (element == nil) {
    return;
  }

  NSString* synopsis = [element attributeValue:@"synopsis"];
  if (synopsis.length == 0) {
    return;
  }

  NSArray* cast = [self processArray:[element element:@"Cast"] attribute:@"name"];

  [FileUtilities writeObject:cast toFile:[self castFile:movie]];
  [FileUtilities writeObject:synopsis toFile:synopsisFile];

  [MetasyntacticSharedApplication minorRefresh];
}


- (void) updateTrailers:(Movie*) movie
                  force:(BOOL) force
                 studio:(NSString*) studio
                  title:(NSString*) title {
  if (studio.length == 0 || title.length == 0) {
    return;
  }

  NSString* trailersFile = [self trailersFile:movie];

  NSDate* lastLookupDate = [FileUtilities modificationDate:trailersFile];
  if (lastLookupDate != nil) {
    if (ABS(lastLookupDate.timeIntervalSinceNow) < THREE_DAYS) {
      NSArray* trailers = [FileUtilities readObject:trailersFile];
      if (trailers.count > 0) {
        return;
      }

      if (!force) {
        return;
      }
    }
  }

  NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings%@?studio=%@&name=%@",
                   [Application apiHost], [Application apiVersion], studio, title];
  XmlElement* element = [NetworkUtilities xmlWithContentsOfAddress:url pause:NO];
  if (element == nil) {
    return;
  }

  NSMutableArray* final = [NSMutableArray array];
  for (XmlElement* urlElement in element.children) {
    NSString* trailer = [urlElement text];
    if (trailer.length > 0) {
      [final addObject:trailer];
    }
  }

  [FileUtilities writeObject:final toFile:trailersFile];
  [MetasyntacticSharedApplication minorRefresh];
}


- (void) updateMovieDetails:(Movie*) movie
                      force:(BOOL) force
                     studio:(NSString*) studio
                      title:(NSString*) title {
  [self updateSynopsisAndCast:movie force:force studio:studio title:title];
  [self updateTrailers:movie force:force studio:studio title:title];
}


- (void) updateMovieDetails:(Movie*) movie force:(BOOL) force {
  NSString* studio = [self.studioKeys objectForKey:movie.canonicalTitle];
  NSString* title = [self.titleKeys objectForKey:movie.canonicalTitle];

  [self updateMovieDetails:movie
                     force:force
                    studio:studio
                     title:title];
}


- (NSDate*) releaseDateForMovie:(Movie*) movie {
  return [[self.movieMap objectForKey:movie.canonicalTitle] releaseDate];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
  return [[self.movieMap objectForKey:movie.canonicalTitle] directors];
}


- (NSArray*) castForMovie:(Movie*) movie {
  NSArray* result = [[self.movieMap objectForKey:movie.canonicalTitle] cast];
  if (result.count > 0) {
    return result;
  }

  result = [FileUtilities readObject:[self castFile:movie]];
  if (result.count > 0) {
    return result;
  }

  return [NSArray array];
}


- (NSArray*) genresForMovie:(Movie*) movie {
  return [[self.movieMap objectForKey:movie.canonicalTitle] genres];
}


- (NSString*) synopsisForMovie:(Movie*) movie {
  return [FileUtilities readObject:[self synopsisFile:movie]];
}


- (NSArray*) trailersForMovie:(Movie*) movie {
  NSArray* array = [FileUtilities readObject:[self trailersFile:movie]];
  if (array == nil) {
    return [NSArray array];
  }

  return array;
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
