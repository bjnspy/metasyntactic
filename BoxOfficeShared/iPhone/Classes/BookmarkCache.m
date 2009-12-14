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

  [[Model model].dataProvider addBookmark:movie.canonicalTitle];
  [self.upcomingCache addBookmark:movie.canonicalTitle];
  [self.dvdCache addBookmark:movie.canonicalTitle];
  [self.blurayCache addBookmark:movie.canonicalTitle];
}


- (void) removeBookmark:(Movie*) movie {
  NSMutableSet* set = [NSMutableSet setWithSet:self.bookmarkedTitles];
  [set removeObject:movie.canonicalTitle];
  bookmarkedTitlesData.value = set;

  [[Model model].dataProvider removeBookmark:movie.canonicalTitle];
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
