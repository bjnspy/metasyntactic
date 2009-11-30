//
//  FavoriteTheaterCache.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface FavoriteTheaterCache : AbstractCache {
@private
  ThreadsafeValue*/*NSDictionary*/ favoriteTheatersData;
}

+ (FavoriteTheaterCache*) cache;

- (NSArray*) favoriteTheatersArray;

- (BOOL) isFavoriteTheater:(Theater*) theater;
- (void) addFavoriteTheater:(Theater*) theater;
- (void) removeFavoriteTheater:(Theater*) theater;

@end
