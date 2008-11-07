//
//  AbstractDVDBlurayCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface AbstractDVDBlurayCache : NSObject {
    NowPlayingModel* model;
    
    NSLock* gate;
    
    PointerSet* moviesSetData;
    NSArray* moviesData;
    
    LinkedSet* prioritizedMovies;
}

@property (assign) NowPlayingModel* model;

@property (retain) NSLock* gate;
@property (retain) PointerSet* moviesSetData;
@property (retain) NSArray* moviesData;
@property (retain) LinkedSet* prioritizedMovies;

- (id) initWithModel:(NowPlayingModel*) model;

- (void) update;
- (void) prioritizeMovie:(Movie*) movie;

- (NSArray*) movies;

- (DVD*) detailsForMovie:(Movie*) movie;
- (UIImage*) posterForMovie:(Movie*) movie;
- (NSString*) imdbAddressForMovie:(Movie*) movie;

@end