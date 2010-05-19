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

#import "UpcomingCache.h"

#import "Application.h"
#import "BookmarkCache.h"
#import "Model.h"
#import "MovieCacheUpdater.h"
#import "TrailerCache.h"

static NSString* studio_and_title_key = @"studio_and_title_key";

@interface UpcomingCache()
@property (retain) ThreadsafeValue* movieMapData;
@property (retain) ThreadsafeValue* bookmarksData;
@property BOOL updated;
@end


@implementation UpcomingCache

static UpcomingCache* cache;

static NSDictionary* massageMap;

+ (void) initialize {
  if (self == [UpcomingCache class]) {
    cache = [[UpcomingCache alloc] init];

    unichar ndash[] = { (unichar)226, (unichar)128, (unichar)147 };
    unichar mdash[] = { (unichar)226, (unichar)128, (unichar)148 };
    unichar lquote[] = { (unichar)226, (unichar)128, (unichar)152 };
    unichar rquote[] = { (unichar)226, (unichar)128, (unichar)153 };
    unichar openQuote[] = { (unichar)226, (unichar)128, (unichar)156 };
    unichar closeQuote[] = { (unichar)226, (unichar)128, (unichar)157 };
    unichar ellipsis[] = { (unichar)226, (unichar)128, (unichar)166 };

    massageMap = [[NSDictionary dictionaryWithObjectsAndKeys:
                   @"–", [NSString stringWithCharacters:ndash length:ArrayLength(ndash)],
                   @"—", [NSString stringWithCharacters:mdash length:ArrayLength(mdash)],
                   @"‘", [NSString stringWithCharacters:lquote length:ArrayLength(lquote)],
                   @"’", [NSString stringWithCharacters:rquote length:ArrayLength(rquote)],
                   @"“", [NSString stringWithCharacters:openQuote length:ArrayLength(openQuote)],
                   @"”", [NSString stringWithCharacters:closeQuote length:ArrayLength(closeQuote)],
                   @"…", [NSString stringWithCharacters:ellipsis length:ArrayLength(ellipsis)], nil] retain];
  }
}


+ (UpcomingCache*) cache {
  return cache;
}

@synthesize movieMapData;
@synthesize bookmarksData;
@synthesize updated;

- (void) dealloc {
  self.movieMapData = nil;
  self.bookmarksData = nil;
  self.updated = NO;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.movieMapData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadMovieMap) saveSelector:@selector(saveMovieMap:)];
    self.bookmarksData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadBookmarks) saveSelector:@selector(saveBookmarks:)];
  }

  return self;
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


+ (BOOL) isNilOrString:(id) obj {
  if (obj == nil) {
    return YES;
  }

  return [obj isKindOfClass:[NSString class]];
}


+ (BOOL) isNilOrStringArray:(id) obj {
  if (obj == nil) {
    return YES;
  }

  if (![obj isKindOfClass:[NSArray class]]) {
    return NO;
  }

  for (id child in obj) {
    if (![child isKindOfClass:[NSString class]]) {
      return NO;
    }
  }

  return YES;
}


+ (NSArray*) removeHtml:(NSArray*) array {
  if (array.count == 0) {
    return array;
  }

  NSMutableArray* result = [NSMutableArray array];
  for (NSString* val in array) {
    [result addObject:[HtmlUtilities removeHtml:val]];
  }
  return result;
}


+ (Movie*) processMovieElement:(id) movieElement
                          keys:(NSDictionary*) keys {
  if (![movieElement isKindOfClass:[NSDictionary class]]) {
    return nil;
  }

  id releaseDateString = [movieElement objectForKey:@"releasedate"];
  id poster = [movieElement objectForKey:@"poster"];
  id rating = [movieElement objectForKey:@"rating"];
  id studio = [movieElement objectForKey:@"studio"];
  id title = [movieElement objectForKey:@"title"];
  id directors = [movieElement objectForKey:@"directors"];
  id cast = [movieElement objectForKey:@"actors"];
  id genres = [movieElement objectForKey:@"genre"];

  if ([directors isKindOfClass:[NSString class]]) {
    directors = [NSArray arrayWithObject:directors];
  }
  if ([cast isKindOfClass:[NSString class]]) {
    cast = [NSArray arrayWithObject:cast];
  }
  if ([genres isKindOfClass:[NSString class]]) {
    genres = [NSArray arrayWithObject:genres];
  }

  if (![self isNilOrString:releaseDateString] ||
      ![self isNilOrString:poster] ||
      ![self isNilOrString:rating] ||
      ![self isNilOrString:studio] ||
      ![self isNilOrString:title] ||
      ![self isNilOrStringArray:directors] ||
      ![self isNilOrStringArray:cast] ||
      ![self isNilOrStringArray:genres]) {
    return nil;
  }

  studio = [HtmlUtilities removeHtml:studio];
  title = [HtmlUtilities removeHtml:title];
  directors = [self removeHtml:directors];
  cast = [self removeHtml:cast];
  genres = [self removeHtml:genres];

  NSArray* studioAndTitleKey = [keys objectForKey:[title lowercaseString]];
  if (studioAndTitleKey.count != 2) {
    return nil;
  }
  NSString* studioKey = [studioAndTitleKey objectAtIndex:0];
  NSString* titleKey = [studioAndTitleKey objectAtIndex:1];
  if (studioKey.length == 0 || titleKey.length == 0) {
    return nil;
  }

  NSDate* releaseDate = [DateUtilities dateWithNaturalLanguageString:releaseDateString];
  NSDictionary* additionalFields = [NSDictionary dictionaryWithObject:studioAndTitleKey
                                                               forKey:studio_and_title_key];

  title = [title stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
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
                                     genres:genres
                           additionalFields:additionalFields];

  return movie;
}


+ (NSMutableArray*) processResultElement:(id) jsonIndex
                                    keys:(NSDictionary*) keys {
  NSMutableArray* result = [NSMutableArray array];
  NSDate* cutoff = [NSDate dateWithTimeIntervalSinceNow:-2 * ONE_WEEK];

  if ([jsonIndex isKindOfClass:[NSArray class]]) {
    for (id child in jsonIndex) {
      NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
      {
        Movie* movie = [self processMovieElement:child keys:keys];

        if (movie != nil) {
          if([cutoff compare:movie.releaseDate] != NSOrderedDescending) {
            [result addObject:movie];
          }
        }
      }
      [pool release];
    }
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


- (NSDictionary*) bookmarks {
  return bookmarksData.value;
}


- (NSMutableDictionary*) loadBookmarks {
  NSArray* movies = [[BookmarkCache cache] bookmarkedUpcoming];
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
  [[BookmarkCache cache] setBookmarkedUpcoming:bookmarks.allValues];
}


- (NSString*) synopsisFile:(Movie*) movie {
  return [[[Application upcomingSynopsesDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) trailersFile:(Movie*) movie {
  return [[[Application upcomingTrailersDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) updateIndexBackgroundEntryPointWorker {
  NSString* index = [TrailerCache downloadIndexString];

  id jsonIndex = [index JSONValue];
  NSDictionary* keys = [TrailerCache processJSONIndex:jsonIndex];

  NSMutableArray* movies = [UpcomingCache processResultElement:jsonIndex keys:keys];
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
    if ([[BookmarkCache cache] isBookmarked:movie]) {
      [dictionary setObject:movie forKey:movie.canonicalTitle];
    }
  }

  NSMutableDictionary* movieMap = [NSMutableDictionary dictionary];
  for (Movie* movie in movies) {
    [movieMap setObject:movie forKey:movie.canonicalTitle];
  }

  [dataGate lock];
  {
    bookmarksData.value = dictionary;
    movieMapData.value = movieMap;

    // do this last, it signifies that we're done.
    [self clearUpdatedMovies];
  }
  [dataGate unlock];

  [MetasyntacticSharedApplication majorRefresh];
}


- (BOOL) tooSoon {
  NSDate* lastLookupDate = [FileUtilities modificationDate:self.moviesFile];
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
  [[MovieCacheUpdater updater] addMovies:movies];
}


- (void) update {
  if ([Model model].userAddress.length == 0) {
    return;
  }

  if (![Model model].upcomingCacheEnabled) {
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


- (NSString*) massageSynopsis:(NSString*) value {
  //static NSString* s1 = [[StringUtilities stringFromUnichar:(unichar)221] retain];

  if (value.length == 0) {
    return value;
  }

  for (NSString* key in massageMap) {
    value = [value stringByReplacingOccurrencesOfString:key withString:[massageMap objectForKey:key]];
  }

  while (YES) {
    int oldLength = value.length;
    value = [value stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    if (value.length == oldLength) {
      break;
    }
  }

  return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

  //return [value stringByReplacingOccurrencesOfString:s1 withString:@"'"];
}


- (void) updateSynopsis:(Movie*) movie
                  force:(BOOL) force
              studioKey:(NSString*) studioKey
               titleKey:(NSString*) titleKey {
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

  NSString* xmlString = [TrailerCache downloadXmlStringForStudioKey:studioKey
                                                     titleKey:titleKey];
  if (xmlString == nil) {
    return;
  }

  NSRange descriptionRange = [xmlString rangeOfString:@"<!--DESCRIPTION-->"];
  if (descriptionRange.length == 0) {
    return;
  }
  NSRange textViewRange = [xmlString rangeOfString:@"</TextView>"
                                                options:0
                                                  range:NSMakeRange(descriptionRange.location, xmlString.length - descriptionRange.location)];
  if (textViewRange.length == 0) {
    return;
  }

  NSInteger start = descriptionRange.location;
  NSInteger end = textViewRange.location + textViewRange.length;

  NSString* substring =
  [xmlString substringWithRange:NSMakeRange(start, end - start)];

  XmlElement* element = [XmlParser parse:[substring dataUsingEncoding:NSUTF8StringEncoding]];
  NSString* synopsis = [[element element:@"SetFontStyle"] text];

  synopsis = [self massageSynopsis:synopsis];
  if (synopsis.length == 0) {
    return;
  }

  [FileUtilities writeObject:synopsis toFile:synopsisFile];
  [MetasyntacticSharedApplication minorRefresh];
}


- (void) updateTrailers:(Movie*) movie
                  force:(BOOL) force
              studioKey:(NSString*) studioKey
               titleKey:(NSString*) titleKey {
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

  NSArray* trailers = [TrailerCache downloadTrailersForStudioKey:studioKey titleKey:titleKey];
  if (trailers == nil) {
    return;
  }

  [FileUtilities writeObject:trailers toFile:trailersFile];
  if (trailers.count > 0) {
    [MetasyntacticSharedApplication minorRefresh];
  }
}


- (void) updateMovieDetails:(Movie*) movie
                      force:(BOOL) force
                  studioKey:(NSString*) studioKey
                   titleKey:(NSString*) titleKey {
  [self updateSynopsis:movie force:force studioKey:studioKey titleKey:titleKey];
  [self updateTrailers:movie force:force studioKey:studioKey titleKey:titleKey];
}


- (void) updateMovieDetails:(Movie*) movie force:(BOOL) force {
  NSArray* studioAndTitle = [movie.additionalFields objectForKey:studio_and_title_key];
  if (studioAndTitle.count != 2) {
    return;
  }

  NSString* studioKey = [studioAndTitle objectAtIndex:0];
  NSString* titleKey = [studioAndTitle objectAtIndex:1];

  if (studioKey.length == 0 || titleKey.length == 0) {
    return;
  }

  [self updateMovieDetails:movie
                     force:force
                 studioKey:studioKey
                  titleKey:titleKey];
}


- (NSDate*) releaseDateForMovie:(Movie*) movie {
  return [[self.movieMap objectForKey:movie.canonicalTitle] releaseDate];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
  return [[self.movieMap objectForKey:movie.canonicalTitle] directors];
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
