//
//  NetflixSearchEngine.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractSearchEngine.h"

@interface NetflixSearchEngine : AbstractSearchEngine {
@private
}

+ (NetflixSearchEngine*) engineWithModel:(NowPlayingModel*) model delegate:(id<SearchEngineDelegate>) delegate;

@end