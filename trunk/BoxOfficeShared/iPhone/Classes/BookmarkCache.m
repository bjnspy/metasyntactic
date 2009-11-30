//
//  BookmarkCache.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookmarkCache.h"

#import "DataProvider.h"
#import "Model.h"
#import "UpcomingCache.h"
#import "DVDCache.h"
#import "BlurayCache.h"

static NSString* BOOKMARKED_BLURAY                          = @"bookmarkedBluray";
static NSString* BOOKMARKED_DVD                             = @"bookmarkedDVD";
static NSString* BOOKMARKED_MOVIES                          = @"bookmarkedMovies";
static NSString* BOOKMARKED_TITLES                          = @"bookmarkedTitles";
static NSString* BOOKMARKED_UPCOMING                        = @"bookmarkedUpcoming";

@interface BookmarkCache()
@property (retain) ThreadsafeValue*/*NSSet*/ bookmarkedTitlesData;
@end

@implementation BookmarkCache

static BookmarkCache* cache;

+ (void) initialize {
  if (self == [BookmarkCache class]) {
    cache = [[BookmarkCache alloc] init];
  }
}


+ (BookmarkCache*) cache {
  return cache;
}

@synthesize bookmarkedTitlesData;

- (void) dealloc {
  self.bookmarkedTitlesData = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.bookmarkedTitlesData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadBookmarkedTitles) saveSelector:@selector(saveBookmarkedTitles:)];
  }
  return self;
}


- (Model*) model {
  return [Model model];
}


- (UpcomingCache*) upcomingCache {
  return [UpcomingCache cache];
}


- (DVDCache*) dvdCache {
  return [DVDCache cache];
}


- (BlurayCache*) blurayCache {
  return [BlurayCache cache];
}


- (NSSet*) loadBookmarkedTitles {
  NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:BOOKMARKED_TITLES];
  if (array.count == 0) {
    return [NSMutableSet set];
  }
  
  return [NSSet setWithArray:array];
}


- (void) saveBookmarkedTitles:(NSSet*) bookmarkedTitles {
  [[NSUserDefaults standardUserDefaults] setObject:bookmarkedTitles.allObjects forKey:BOOKMARKED_TITLES];
}


- (NSSet*) bookmarkedTitles {
  return bookmarkedTitlesData.value;
}


- (BOOL) isBookmarked:(Movie*) movie {
  return [self.bookmarkedTitles containsObject:movie.canonicalTitle];
}


- (void) addBookmark:(Movie*) movie {
  NSMutableSet* set = [NSMutableSet setWithSet:self.bookmarkedTitles];
  [set addObject:movie.canonicalTitle];
  bookmarkedTitlesData.value = set;
  
  [self.model.dataProvider addBookmark:movie.canonicalTitle];
  [self.upcomingCache addBookmark:movie.canonicalTitle];
  [self.dvdCache addBookmark:movie.canonicalTitle];
  [self.blurayCache addBookmark:movie.canonicalTitle];
}


- (void) removeBookmark:(Movie*) movie {
  NSMutableSet* set = [NSMutableSet setWithSet:self.bookmarkedTitles];
  [set removeObject:movie.canonicalTitle];
  bookmarkedTitlesData.value = set;
  
  [self.model.dataProvider removeBookmark:movie.canonicalTitle];
  [self.upcomingCache removeBookmark:movie.canonicalTitle];
  [self.dvdCache removeBookmark:movie.canonicalTitle];
  [self.blurayCache removeBookmark:movie.canonicalTitle];
}


- (NSArray*) bookmarkedItems:(NSString*) key {
  NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:key];
  if (array.count == 0) {
    return [NSArray array];
  }
  
  NSMutableArray* result = [NSMutableArray array];
  for (NSDictionary* dictionary in array) {
    [result addObject:[Movie createWithDictionary:dictionary]];
  }
  return result;
}


- (NSArray*) bookmarkedMovies {
  return [self bookmarkedItems:BOOKMARKED_MOVIES];
}


- (NSArray*) bookmarkedUpcoming {
  return [self bookmarkedItems:BOOKMARKED_UPCOMING];
}


- (NSArray*) bookmarkedDVD {
  return [self bookmarkedItems:BOOKMARKED_DVD];
}


- (NSArray*) bookmarkedBluray {
  return [self bookmarkedItems:BOOKMARKED_BLURAY];
}


- (void) saveMovies:(NSArray*) movies key:(NSString*) key {
  [[NSUserDefaults standardUserDefaults] setObject:[Movie encodeArray:movies] forKey:key];
}


- (void) setBookmarkedMovies:(NSArray*) array {
  [self saveMovies:array key:BOOKMARKED_MOVIES];
}


- (void) setBookmarkedUpcoming:(NSArray*) array {
  [self saveMovies:array key:BOOKMARKED_UPCOMING];
}


- (void) setBookmarkedDVD:(NSArray*) array {
  [self saveMovies:array key:BOOKMARKED_DVD];
}


- (void) setBookmarkedBluray:(NSArray*) array {
  [self saveMovies:array key:BOOKMARKED_BLURAY];
}

@end
