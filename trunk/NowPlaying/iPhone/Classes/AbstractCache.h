//
//  AbstractCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface AbstractCache : NSObject {
@protected
    NSLock* gate;
}

- (void) clearStaleData;

@end
