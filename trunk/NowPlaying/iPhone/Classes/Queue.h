//
//  Queue.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface Queue : NSObject {
@private
    NSString* etag;
    NSArray* movies;
}

@property (readonly, copy) NSString* etag;
@property (readonly, retain) NSArray* movies;

+ (Queue*) queueWithDictionary:(NSDictionary*) dictionary;
+ (Queue*) queueWithETag:(NSString*) etag
                  movies:(NSArray*) movies;

- (NSDictionary*) dictionary;

@end
