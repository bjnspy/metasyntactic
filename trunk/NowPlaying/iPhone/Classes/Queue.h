//
//  Queue.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface Queue : NSObject {
@private
    NSString* feedKey;
    NSString* etag;
    NSArray* movies;
    NSArray* saved;
    NSDictionary* identifierToDetails;
}

@property (readonly, copy) NSString* feedKey;
@property (readonly, copy) NSString* etag;
@property (readonly, retain) NSArray* movies;
@property (readonly, retain) NSArray* saved;
@property (readonly, retain) NSDictionary* identifierToDetails;

+ (Queue*) queueWithDictionary:(NSDictionary*) dictionary;
+ (Queue*) queueWithFeedKey:(NSString*) feedKey
                       etag:(NSString*) etag
                     movies:(NSArray*) movies
                      saved:(NSArray*) saved
        identifierToDetails:(NSDictionary*) identifierToDetails;

- (NSDictionary*) dictionary;

- (BOOL) isDVDQueue;
- (BOOL) isInstantQueue;

@end
