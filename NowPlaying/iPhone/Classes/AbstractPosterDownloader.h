//
//  AbstractPosterDownloader.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 4/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AbstractPosterDownloader : NSObject {
@private
    NSDictionary* movieNameToPosterMap;
    NSLock* gate;
}

- (NSData*) download:(Movie*) movie;

@end
