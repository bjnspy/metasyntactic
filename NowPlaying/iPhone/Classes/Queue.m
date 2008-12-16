//
//  Queue.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Queue.h"

#import "Movie.h"

@interface Queue()
@property (copy) NSString* etag;
@property (retain) NSArray* movies;
@end


@implementation Queue

property_definition(etag);
property_definition(movies);

- (void) dealloc {
    self.etag = nil;
    self.movies = nil;

    [super dealloc];
}


- (id) initWithETag:(NSString*) etag_
                  movies:(NSArray*) movies_ {
    if (self = [super init]) {
        self.etag = etag_;
        self.movies = movies_;
    }
    
    return self;
}


+ (Queue*) queueWithETag:(NSString*) etag
                  movies:(NSArray*) movies {
    return [[[Queue alloc] initWithETag:etag movies:movies] autorelease];
}


+ (Queue*) queueWithDictionary:(NSDictionary*) dictionary {
    return [Queue queueWithETag:[dictionary objectForKey:etag_key]
                         movies:[Movie decodeArray:[dictionary objectForKey:movies_key]]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:etag forKey:etag_key];
    [result setObject:[Movie encodeArray:movies] forKey:movies_key];
    return result;
}


@end
