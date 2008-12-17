//
//  Queue.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Queue.h"

#import "Movie.h"
#import "Utilities.h"

@interface Queue()
@property (copy) NSString* feedKey;
@property (copy) NSString* etag;
@property (retain) NSArray* movies;
@property (retain) NSArray* saved;
@property (retain) NSDictionary* identifierToDetails;
@end


@implementation Queue

property_definition(feedKey);
property_definition(etag);
property_definition(movies);
property_definition(saved);
property_definition(identifierToDetails);

- (void) dealloc {
    self.feedKey = nil;
    self.etag = nil;
    self.movies = nil;
    self.saved = nil;
    self.identifierToDetails = nil;

    [super dealloc];
}


- (id) initWithFeedKey:(NSString*) feedKey_
                  etag:(NSString*) etag_
                  movies:(NSArray*) movies_ 
                 saved:(NSArray*) saved_
   identifierToDetails:(NSDictionary*) identifierToDetails_ {
    if (self = [super init]) {
        self.feedKey = feedKey_;
        self.etag = [Utilities nonNilString:etag_];
        self.movies = movies_;
        self.saved = saved_;
        self.identifierToDetails = identifierToDetails_;
    }
    
    return self;
}


+ (Queue*) queueWithFeedKey:(NSString*) feedKey
                       etag:(NSString*) etag
                     movies:(NSArray*) movies
                      saved:(NSArray*) saved
        identifierToDetails:(NSDictionary*) identifierToDetails {
    return [[[Queue alloc] initWithFeedKey:feedKey
                                      etag:etag
                                    movies:movies
                                     saved:saved
                       identifierToDetails:identifierToDetails] autorelease];
}


+ (Queue*) queueWithDictionary:(NSDictionary*) dictionary {
    return [Queue queueWithFeedKey:[dictionary objectForKey:feedKey_key]
                              etag:[dictionary objectForKey:etag_key]
                            movies:[Movie decodeArray:[dictionary objectForKey:movies_key]]
                             saved:[Movie decodeArray:[dictionary objectForKey:saved_key]]
               identifierToDetails:[dictionary objectForKey:identifierToDetails_key]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:feedKey forKey:feedKey_key];
    [result setObject:etag forKey:etag_key];
    [result setObject:[Movie encodeArray:movies] forKey:movies_key];
    [result setObject:[Movie encodeArray:saved] forKey:saved_key];
    [result setObject:identifierToDetails forKey:identifierToDetails_key];
    return result;
}


- (BOOL) isDVDQueue {
    return [@"http://schemas.netflix.com/feed.queues.disc" isEqual:feedKey];
}


- (BOOL) isInstantQueue {
    return [@"http://schemas.netflix.com/feed.queues.instant" isEqual:feedKey];
}


@end
