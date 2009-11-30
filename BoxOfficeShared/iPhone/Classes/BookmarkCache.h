//
//  BookmarkCache.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface BookmarkCache : AbstractCache {
@private
  ThreadsafeValue*/*NSSet*/ bookmarkedTitlesData;
}

+ (BookmarkCache*) cache;

- (NSSet*) bookmarkedTitles;
- (BOOL) isBookmarked:(Movie*) movie;
- (void) addBookmark:(Movie*) movie;
- (void) removeBookmark:(Movie*) movie;

- (NSArray*) bookmarkedMovies;
- (NSArray*) bookmarkedUpcoming;
- (NSArray*) bookmarkedDVD;
- (NSArray*) bookmarkedBluray;
- (void) setBookmarkedMovies:(NSArray*) array;
- (void) setBookmarkedUpcoming:(NSArray*) array;
- (void) setBookmarkedDVD:(NSArray*) array;
- (void) setBookmarkedBluray:(NSArray*) array;

@end
