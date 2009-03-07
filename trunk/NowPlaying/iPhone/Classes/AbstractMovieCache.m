//
//  AbstractMovieCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractMovieCache.h"

#import "LinkedSet.h"
#import "ThreadingUtilities.h"

@interface AbstractMovieCache()
@property (retain) LinkedSet* prioritizedMovies;
@property (retain) LinkedSet* primaryMovies;
@property (retain) LinkedSet* secondaryMovies;
@property (retain) NSMutableSet* updateMovies;
@end


@implementation AbstractMovieCache

@synthesize prioritizedMovies;
@synthesize primaryMovies;
@synthesize secondaryMovies;
@synthesize updateMovies;

- (void) dealloc {
    self.prioritizedMovies = nil;
    self.primaryMovies = nil;
    self.secondaryMovies = nil;
    self.updateMovies = nil;

    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
        self.primaryMovies = [LinkedSet set];
        self.secondaryMovies = [LinkedSet set];
        self.updateMovies = [NSMutableSet set];

        [ThreadingUtilities backgroundSelector:@selector(updateDetailsBackgroundEntryPoint)
                                      onTarget:self
                                          gate:nil
                                       visible:NO];
    }

    return self;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clearUpdatedMovies];
}


- (void) updateMovieDetails:(Movie*) movie {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) updateMoviesContainsNoLock:(Movie*) movie {
    return [updatedMovies containsObject:movie];
}


- (BOOL) updateMoviesContains:(Movie*) movie {
    BOOL value;
    [gate lock];
    {
        value = [self updateMoviesContainsNoLock:movie];
    }
    [gate unlock];
    return value;
}


- (void) addUpdatedMovie:(Movie*) movie {
    [gate lock];
    {
        [updatedMovies addObject:movie];
    }
    [gate unlock];
}


- (void) clearUpdatedMovies {
    [gate lock];
    {
        [updatedMovies removeAllObjects];
    }
    [gate unlock];
}


- (void) updateDetailsBackgroundEntryPoint {
    while (YES) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            Movie* movie = nil;
            [gate lock];
            {
                while ((movie = [prioritizedMovies removeLastObjectAdded]) == nil &&
                       (movie = [primaryMovies removeLastObjectAdded]) == nil &&
                       (movie = [secondaryMovies removeLastObjectAdded]) == nil) {
                    [gate wait];
                }
            }
            [gate unlock];

            if (movie != nil) {
                if (![self updateMoviesContains:movie]) {
                    [self addUpdatedMovie:movie];
                    [self updateMovieDetails:movie];
                }
            }

            [NSThread sleepForTimeInterval:1];
        }
        [pool release];
    }
}


- (void) addMovie:(Movie*) movie
              set:(LinkedSet*) set {
    [gate lock];
    {
        if (![self updateMoviesContainsNoLock:movie]) {
            [set addObject:movie];
            [gate broadcast];
        }
    }
    [gate unlock];
}


- (void) addMovies:(NSArray*) movies
               set:(LinkedSet*) set {
    [gate lock];
    {
        [set addObjectsFromArray:movies];
        [gate broadcast];
    }
    [gate unlock];
}


- (void) prioritizeMovie:(Movie*) movie {
    [self addMovie:movie set:prioritizedMovies];
}


- (void) addPrimaryMovie:(Movie*) movie {
    [self addMovie:movie set:primaryMovies];
}


- (void) addSecondaryMovie:(Movie*) movie {
    [self addMovie:movie set:secondaryMovies];
}


- (void) addPrimaryMovies:(NSArray*) movies {
    [self addMovies:movies set:primaryMovies];
}


- (void) addSecondaryMovies:(NSArray*) movies {
    [self addMovies:movies set:secondaryMovies];
}

@end
