//
//  AbstractSearchEngine.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface AbstractSearchEngine : NSObject {
@protected
    // only accessed from the main thread.  needs no lock.
    NowPlayingModel* model;
    id<SearchEngineDelegate> delegate;
    
    // accessed from both threads.  needs lock
    NSInteger currentRequestId;
    SearchRequest* nextSearchRequest;
    
    // only accessed from the background thread.  needs no lock
    SearchRequest* currentlyExecutingRequest;
    
    NSCondition* gate;
}

- (void) submitRequest:(NSString*) string;

- (void) invalidateExistingRequests;

/* @protected */
- (id) initWithModel:(NowPlayingModel*) model
            delegate:(id<SearchEngineDelegate>) delegate;

- (BOOL) abortEarly;

- (void) reportResult:(NSArray*) movies
             theaters:(NSArray*) theaters
       upcomingMovies:(NSArray*) upcomingMovies
                 dvds:(NSArray*) dvds
               bluray:(NSArray*) bluray;

@end