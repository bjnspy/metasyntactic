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

#import "InternationalDataCache.h"

#import "Application.h"
#import "Model.h"

@interface InternationalDataCache()
@property (retain) DifferenceEngine* engine;
@property (retain) ThreadsafeValue* indexData;
@property (retain) NSMutableDictionary* movieMap;
@property (retain) NSMutableDictionary* ratingAndRuntimeCache;
@property BOOL updated;
@end


@implementation InternationalDataCache

static NSString* trailers_key = @"trailers";

static NSDictionary* countryToCode = nil;

+ (void) initialize {
  if (self == [InternationalDataCache class]) {
    countryToCode = [[NSDictionary dictionaryWithObjectsAndKeys:
                      @"331100091-1" , @"FR",
                      @"4501100140-1", @"DK",
                      @"391100099-1" , @"NL",
                      @"4601100171-1", @"SE",
                      @"491100208-1" , @"DE",
                      @"391100099-1" , @"IT",
                      @"341100082-1" , @"ES",
                      @"391100099-1" , @"CH",
                      @"3581100147-1", @"FI", nil] retain];
  }
}

@synthesize engine;
@synthesize indexData;
@synthesize movieMap;
@synthesize updated;
@synthesize ratingAndRuntimeCache;

- (void) dealloc {
  self.engine = nil;
  self.indexData = nil;
  self.movieMap = nil;
  self.updated = NO;
  self.ratingAndRuntimeCache = nil;

  [super dealloc];
}


+ (BOOL) isAllowableCountry {
  return [countryToCode objectForKey:[LocaleUtilities isoCountry]] != nil;
}


- (id) init {
  if ((self = [super init])) {
    self.indexData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadIndex) saveSelector:@selector(saveIndex:)];
    self.engine = [DifferenceEngine engine];
    self.ratingAndRuntimeCache = [NSMutableDictionary dictionary];
  }

  return self;
}


+ (InternationalDataCache*) cache {
  return [[[InternationalDataCache alloc] init] autorelease];
}


- (NSString*) indexFile {
  NSString* name = [NSString stringWithFormat:@"%@.plist", [LocaleUtilities isoCountry]];
  return [[Application internationalDirectory] stringByAppendingPathComponent:name];
}


- (NSDictionary*) loadIndex {
  NSDictionary* dictionary = [FileUtilities readObject:[self indexFile]];
  if (dictionary == nil) {
    return [NSDictionary dictionary];
  }

  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  for (NSString* title in dictionary) {
    [result setObject:[Movie createWithDictionary:[dictionary objectForKey:title]] forKey:title];
  }
  return result;
}


- (void) saveIndex:(NSDictionary*) value {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  for (NSString* title in value) {
    [dictionary setObject:[[value objectForKey:title] dictionary] forKey:title];
  }

  [FileUtilities writeObject:dictionary toFile:self.indexFile];
}


- (NSDictionary*) index {
  return indexData.value;
}


- (Model*) model {
  return [Model model];
}


- (void) update {
  if (!self.model.internationalDataCacheEnabled) {
    return;
  }

  if (updated) {
    return;
  }
  self.updated = YES;

  [[OperationQueue operationQueue] performSelector:@selector(updateBackgroundEntryPoint)
                                          onTarget:self
                                              gate:nil
                                          priority:Priority];
}


- (NSArray*) extractArray:(XmlElement*) element {
  NSMutableArray* array = [NSMutableArray array];
  for (XmlElement* child in element.children) {
    [array addObject:child.text];
  }
  return array;
}


- (NSString*) mapRating_FR:(NSString*) value {
  NSInteger i = value.intValue;
  if (i == 99) {
    return @"U";
  }

  if (i == 0) {
    return @"";
  }

  return value;
}


- (NSString*) mapRating_DK:(NSString*) value {
  NSInteger i = value.intValue;
  if (i == 99) {
    return @"A";
  }

  if (i == 0) {
    return @"";
  }

  return value;
}


- (NSString*) mapRating_NL:(NSString*) value {
  NSInteger i = value.intValue;
  if (i == 99) {
    return @"AL";
  }

  if (i == 0) {
    return @"";
  }

  return value;
}


- (NSString*) mapRating_SE:(NSString*) value {
  NSInteger i = value.intValue;
  if (i == 99) {
    return @"Btl";
  }

  if (i == 0) {
    return @"";
  }

  return value;
}


- (NSString*) mapRating_DE:(NSString*) value {
  NSInteger i = value.intValue;
  if (i == 99) {
    return @"FSK 0";
  }

  if (i == 0) {
    return @"";
  }

  return [NSString stringWithFormat:@"FSK %@", value];
}


- (NSString*) mapRating_IT:(NSString*) value {
  NSInteger i = value.intValue;
  if (i == 99) {
    return @"T";
  }

  if (i == 0) {
    return @"";
  }

  return [NSString stringWithFormat:@"VM %@", value];
}


- (NSString*) mapRating_ES:(NSString*) value {
  NSInteger i = value.intValue;
  if (i == 99) {
    return @"Todos los publicos";
  }

  if (i == 0) {
    return @"";
  }

  return value;
}


- (NSString*) mapRating_CH:(NSString*) value {
  NSInteger i = value.intValue;
  if (i == 99) {
    return @"0";
  }

  if (i == 0) {
    return @"";
  }

  return value;
}


- (NSString*) mapRating_FI:(NSString*) value {
  NSInteger i = value.intValue;
  if (i == 99) {
    return @"K-3";
  }

  return [NSString stringWithFormat:@"K-%@", value];
}


- (NSString*) mapRating:(NSString*) value
            ratingCache:(NSMutableDictionary*) ratingCache
        mapRatingWorker:(SEL) mapRatingWorker  {
  if (value.length == 0) {
    return nil;
  }

  NSString* result = [ratingCache objectForKey:value];
  if (result == nil) {
    if (mapRatingWorker != nil) {
      result = [self performSelector:mapRatingWorker withObject:value];
    } else {
      result = @"";
    }

    [ratingCache setObject:result forKey:value];
  }
  return result;
}


- (NSDate*) parseDate:(NSString*) string {
  if (string.length == 10 && [string characterAtIndex:2] == '/' && [string characterAtIndex:5] == '/') {
    NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
    components.year = [[string substringWithRange:NSMakeRange(6, 4)] intValue];
    components.month = [[string substringWithRange:NSMakeRange(3, 2)] intValue];
    components.day = [[string substringWithRange:NSMakeRange(0, 2)] intValue];

    return [[NSCalendar currentCalendar] dateFromComponents:components];
  }

  return nil;
}


- (Movie*) processMovieElement:(XmlElement*) element
                   ratingCache:(NSMutableDictionary*) ratingCache
               mapRatingWorker:(SEL) mapRatingWorker {
  static NSInteger identifier = 1;

  NSString* imdbId = [element attributeValue:@"imdb"];
  NSString* imdbAddress = imdbId.length == 0 ? @"" : [NSString stringWithFormat:@"http://www.imdb.com/title/%@", imdbId];

  NSString* title = [[element element:@"title"] text];
  if (title.length == 0) {
    return nil;
  }

  NSString* synopsis = [[element element:@"description"] text];
  //NSString* poster = [[element element:@"poster"] text];

  NSMutableArray* trailers = [NSMutableArray array];
  for (XmlElement* trailerElement in [element elements:@"trailer"]) {
    [trailers addObject:[trailerElement.text stringByReplacingOccurrencesOfString:@"|" withString:@"%7C"]];
  }

  NSArray* directors = [self extractArray:[element element:@"directors"]];
  NSArray* cast = [self extractArray:[element element:@"actors"]];
  NSArray* genres = [self extractArray:[element element:@"categories"]];

  NSInteger length = [[[element element:@"duration"] text] intValue];
  NSDate* releaseDate = [self parseDate:[[element element:@"release"] text]];
  NSString* rating = [self mapRating:[[element element:@"rating"] text] ratingCache:ratingCache mapRatingWorker:mapRatingWorker];

  NSMutableDictionary* additionalFields = [NSMutableDictionary dictionary];
  [additionalFields setObject:trailers forKey:trailers_key];

  return [Movie movieWithIdentifier:[NSString stringWithFormat:@"%d", identifier++]
                              title:title
                             rating:rating
                             length:length
                        releaseDate:releaseDate
                        imdbAddress:imdbAddress
                             poster:nil
                           synopsis:synopsis
                             studio:nil
                          directors:directors
                               cast:cast
                             genres:genres
                   additionalFields:additionalFields];
}


- (void) processElement:(XmlElement*) element {
  NSMutableDictionary* ratingCache = [NSMutableDictionary dictionary];
  SEL mapRatingWorker = NSSelectorFromString([NSString stringWithFormat:@"mapRating_%@:", [LocaleUtilities isoCountry]]);
  if (![self respondsToSelector:mapRatingWorker]) {
    mapRatingWorker = nil;
  }

  NSMutableArray* movies = [NSMutableArray array];
  for (XmlElement* child in element.children) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      Movie* movie = [self processMovieElement:child ratingCache:ratingCache mapRatingWorker:mapRatingWorker];
      if (movie != nil) {
        [movies addObject:movie];
      }
    }
    [pool release];
  }

  if (movies.count == 0) {
    return;
  }

  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  for (Movie* movie in movies) {
    [dictionary setObject:movie forKey:movie.canonicalTitle.lowercaseString];
  }

  [dataGate lock];
  {
    indexData.value = dictionary;
    self.movieMap = [NSMutableDictionary dictionary];
    self.ratingAndRuntimeCache = [NSMutableDictionary dictionary];
  }
  [dataGate unlock];
}


- (void) downloadIndex {
  NSString* code = [countryToCode objectForKey:[LocaleUtilities isoCountry]];
  NSString* address = [NSString stringWithFormat:@"http://%@.iphone.filmtrailer.com/v2.0/cinema/AllCinemaMovies/?channel_user_id=%@&format=mov&size=xlarge", [[LocaleUtilities isoCountry] lowercaseString], code];
  NSString* fullAddress = [NSString stringWithFormat:@"http://%@.appspot.com/LookupCachedResource%@?q=%@",
                           [Application apiHost], [Application apiVersion],
                           [StringUtilities stringByAddingPercentEscapes:address]];

  XmlElement* element;
  if ((element = [NetworkUtilities xmlWithContentsOfAddress:fullAddress pause:NO]) == nil &&
      (element = [NetworkUtilities xmlWithContentsOfAddress:address pause:NO]) == nil) {
    return;
  }

  [self processElement:element];
}


- (void) updateBackgroundEntryPoint {
  if (![InternationalDataCache isAllowableCountry]) {
    return;
  }

  NSDate* modificationDate = [FileUtilities modificationDate:[self indexFile]];
  if (modificationDate != nil) {
    if (ABS(modificationDate.timeIntervalSinceNow) < THREE_DAYS) {
      return;
    }
  }

  NSString* notification = [LocalizedString(@"International Data", nil) lowercaseString];
  [NotificationCenter addNotification:notification];
  {
    [self downloadIndex];
  }
  [NotificationCenter removeNotification:notification];
}


- (Movie*) findMovieWorker:(NSString*) title {
  NSDictionary* index = self.index;

  Movie* result;
  if ((result = [index objectForKey:title]) != nil) {
    return result;
  }

  NSString* closestTitle = [engine findClosestMatch:title inArray:index.allKeys];
  if (closestTitle.length == 0) {
    return nil;
  }

  return [index objectForKey:closestTitle];
}


- (Movie*) findInternationalMovie:(Movie*) movie {
  id result;
  [dataGate lock];
  {
    NSString* title = movie.canonicalTitle.lowercaseString;
    result = [movieMap objectForKey:title];
    if (result == nil) {
      result = [self findMovieWorker:title];
      if (result == nil) {
        [movieMap setObject:[NSNull null] forKey:title];
      }
    }
  }
  [dataGate unlock];
  if ([result isKindOfClass:[Movie class]]) {
    return result;
  }

  return nil;
}


- (NSString*) synopsisForMovie:(Movie*) movie {
  return [[self findInternationalMovie:movie] synopsis];
}


- (NSArray*) trailersForMovie:(Movie*) movie {
  return [[[self findInternationalMovie:movie] additionalFields] objectForKey:trailers_key];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
  return [[self findInternationalMovie:movie] directors];
}


- (NSArray*) castForMovie:(Movie*) movie {
  return [[self findInternationalMovie:movie] cast];
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
  return [[self findInternationalMovie:movie] imdbAddress];
}


- (NSDate*) releaseDateForMovie:(Movie*) movie {
  return [[self findInternationalMovie:movie] releaseDate];
}


- (NSString*) ratingForMovie:(Movie*) movie {
  return [[self findInternationalMovie:movie] rating];
}


- (NSInteger) lengthForMovie:(Movie*) movie {
  return [[self findInternationalMovie:movie] length];
}


- (NSString*) ratingAndRuntimeForMovieWorker:(Movie*) movie {
  NSString* rating = [self.model ratingForMovie:movie];
  NSString* ratingString;
  if (rating.length == 0) {
    ratingString = LocalizedString(@"Unrated", nil);
  } else {
    ratingString = [NSString stringWithFormat:LocalizedString(@"Rated %@", @"%@ will be replaced with a movie rating.  i.e.: Rated PG-13"), rating];
  }

  NSString* runtimeString = @"";
  NSInteger length = [self.model lengthForMovie:movie];
  if (length > 0) {
    runtimeString = [Movie runtimeString:length];
  }

  return [NSString stringWithFormat:LocalizedString(@"%@. %@", "Rated R. 2 hours 34 minutes"), ratingString, runtimeString];
}


- (NSString*) ratingAndRuntimeForMovie:(Movie*) movie {
  NSString* result;
  [dataGate lock];
  {
    result = [ratingAndRuntimeCache objectForKey:movie];
    if (result == nil) {
      result = [self ratingAndRuntimeForMovieWorker:movie];
      [ratingAndRuntimeCache setObject:result forKey:movie];
    }
  }
  [dataGate unlock];
  return result;
}

@end
