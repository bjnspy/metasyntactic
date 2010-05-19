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

#import "BookmarkCache.h"

#import "BlurayCache.h"
#import "DataProvider.h"
#import "DVDCache.h"
#import "Model.h"
#import "UpcomingCache.h"

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

  [[Model model].dataProvider addBookmark:movie.canonicalTitle];
  [[UpcomingCache cache] addBookmark:movie.canonicalTitle];
  [[DVDCache cache] addBookmark:movie.canonicalTitle];
  [[BlurayCache cache] addBookmark:movie.canonicalTitle];
}


- (void) removeBookmark:(Movie*) movie {
  NSMutableSet* set = [NSMutableSet setWithSet:self.bookmarkedTitles];
  [set removeObject:movie.canonicalTitle];
  bookmarkedTitlesData.value = set;

  [[Model model].dataProvider removeBookmark:movie.canonicalTitle];
  [[UpcomingCache cache] removeBookmark:movie.canonicalTitle];
  [[DVDCache cache] removeBookmark:movie.canonicalTitle];
  [[BlurayCache cache] removeBookmark:movie.canonicalTitle];
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
