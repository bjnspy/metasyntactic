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
@property (retain) NSMutableSet* successfullyUpdatedMovies;
@end


@implementation AbstractMovieCache

@synthesize prioritizedMovies;
@synthesize primaryMovies;
@synthesize secondaryMovies;
@synthesize successfullyUpdatedMovies;

- (void) dealloc {
    self.prioritizedMovies = nil;
    self.primaryMovies = nil;
    self.secondaryMovies = nil;
    self.successfullyUpdatedMovies = nil;

    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
        self.primaryMovies = [LinkedSet set];
        self.secondaryMovies = [LinkedSet set];
        self.successfullyUpdatedMovies = [NSMutableSet set];

        [ThreadingUtilities backgroundSelector:@selector(updateDetailsBackgroundEntryPoint)
                                      onTarget:self
                                          gate:nil
                                       visible:NO];
    }

    return self;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clearSuccessfullyUpdatedMovies];
}


- (void) updateMovieDetails:(Movie*) movie {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) updateMovieDetails:(Movie*) movie isPriority:(BOOL) isPriority {
    [self updateMovieDetails:movie];
}


- (void) updateDetailsBackgroundEntryPoint {
    while (YES) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            Movie* movie = nil;
            BOOL isPriority = NO;
            [gate lock];
            {
                NSInteger count = prioritizedMovies.count;
                while ((movie = [prioritizedMovies removeLastObjectAdded]) == nil &&
                       (movie = [primaryMovies removeLastObjectAdded]) == nil &&
                       (movie = [secondaryMovies removeLastObjectAdded]) == nil) {
                    [gate wait];
                }
                isPriority = count != prioritizedMovies.count;
            }
            [gate unlock];

            if (movie != nil) {
                if (![self successfullyUpdatedMoviesContains:movie]) {
                    [self updateMovieDetails:movie isPriority:isPriority];
                    [self addSuccessfullyUpdatedMovie:movie];
                }
            }

            [NSThread sleepForTimeInterval:1];
        }
        [pool release];
    }
}


- (BOOL) successfullyUpdatedMoviesContains:(Movie*) movie {
    BOOL value;
    [gate lock];
    {
        value = [successfullyUpdatedMovies containsObject:movie];
    }
    [gate unlock];
    return value;
}


- (void) addSuccessfullyUpdatedMovie:(Movie*) movie {
    [gate lock];
    {
        [successfullyUpdatedMovies addObject:movie];
    }
    [gate unlock];
}


- (void) clearSuccessfullyUpdatedMovies {
    [gate lock];
    {
        [successfullyUpdatedMovies removeAllObjects];
    }
    [gate unlock];
}


- (void) addMovie:(Movie*) movie set:(LinkedSet*) set {
    if ([self successfullyUpdatedMoviesContains:movie]) {
        return;
    }

    [gate lock];
    {
        [set addObject:movie];
        [gate broadcast];
    }
    [gate unlock];
}


- (void) addMovies:(NSArray*) movies set:(LinkedSet*) set {
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
