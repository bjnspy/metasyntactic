//
//  ForeignDataCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 4/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface InternationalDataCache : AbstractCache {
@private
    BOOL updated;
    
    NSDictionary* indexData;
}

+ (InternationalDataCache*) cache;

- (void) update;

- (NSString*) synopsisForMovie:(Movie*) movie;
- (NSArray*) trailersForMovie:(Movie*) movie;
- (NSArray*) directorsForMovie:(Movie*) movie;
- (NSArray*) castForMovie:(Movie*) movie;
- (NSString*) imdbAddressForMovie:(Movie*) movie;

@end