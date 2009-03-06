//
//  AbstractMovieCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface AbstractMovieCache : AbstractCache {
@private
    LinkedSet* prioritizedMovies;
    LinkedSet* primaryMovies;
    LinkedSet* secondaryMovies;
    
    NSMutableSet* successfullyUpdatedMovies;
}

- (void) prioritizeMovie:(Movie*) movie;

/* @protected */
- (id) initWithModel:(Model*) model;
- (void) addPrimaryMovie:(Movie*) movie;
- (void) addSecondaryMovie:(Movie*) movie;
- (void) addPrimaryMovies:(NSArray*) movies;
- (void) addSecondaryMovies:(NSArray*) movies;

- (BOOL) successfullyUpdatedMoviesContains:(Movie*) movie;
- (void) addSuccessfullyUpdatedMovie:(Movie*) movie;
- (void) clearSuccessfullyUpdatedMovies;

@end