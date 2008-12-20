// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "Queue.h"

#import "Movie.h"
#import "Utilities.h"

@interface Queue()
@property (copy) NSString* feedKey;
@property (copy) NSString* etag;
@property (retain) NSArray* movies;
@property (retain) NSArray* saved;
@end


@implementation Queue

property_definition(feedKey);
property_definition(etag);
property_definition(movies);
property_definition(saved);

- (void) dealloc {
    self.feedKey = nil;
    self.etag = nil;
    self.movies = nil;
    self.saved = nil;

    [super dealloc];
}


- (id) initWithFeedKey:(NSString*) feedKey_
                  etag:(NSString*) etag_
                  movies:(NSArray*) movies_
                 saved:(NSArray*) saved_{
    if (self = [super init]) {
        self.feedKey = feedKey_;
        self.etag = [Utilities nonNilString:etag_];
        self.movies = movies_;
        self.saved = saved_;
    }

    return self;
}


+ (Queue*) queueWithFeedKey:(NSString*) feedKey
                       etag:(NSString*) etag
                     movies:(NSArray*) movies
                      saved:(NSArray*) saved {
    return [[[Queue alloc] initWithFeedKey:feedKey
                                      etag:etag
                                    movies:movies
                                     saved:saved] autorelease];
}


+ (Queue*) queueWithDictionary:(NSDictionary*) dictionary {
    return [Queue queueWithFeedKey:[dictionary objectForKey:feedKey_key]
                              etag:[dictionary objectForKey:etag_key]
                            movies:[Movie decodeArray:[dictionary objectForKey:movies_key]]
                             saved:[Movie decodeArray:[dictionary objectForKey:saved_key]]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:feedKey forKey:feedKey_key];
    [result setObject:etag forKey:etag_key];
    [result setObject:[Movie encodeArray:movies] forKey:movies_key];
    [result setObject:[Movie encodeArray:saved] forKey:saved_key];
    return result;
}


- (BOOL) isDVDQueue {
    return [@"http://schemas.netflix.com/feed.queues.disc" isEqual:feedKey];
}


- (BOOL) isInstantQueue {
    return [@"http://schemas.netflix.com/feed.queues.instant" isEqual:feedKey];
}


@end