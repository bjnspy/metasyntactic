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

#import "Feed.h"
#import "Movie.h"
#import "NetflixCache.h"
#import "StringUtilities.h"
#import "Utilities.h"

@interface Queue()
@property (retain) Feed* feed;
@property (copy) NSString* etag;
@property (retain) NSArray* movies;
@property (retain) NSArray* saved;
@end


@implementation Queue

property_definition(feed);
property_definition(etag);
property_definition(movies);
property_definition(saved);

- (void) dealloc {
    self.feed = nil;
    self.etag = nil;
    self.movies = nil;
    self.saved = nil;

    [super dealloc];
}


- (id) initWithFeed:(Feed*) feed_
               etag:(NSString*) etag_
             movies:(NSArray*) movies_
              saved:(NSArray*) saved_{
    if (self = [super init]) {
        self.feed = feed_;
        self.etag = [StringUtilities nonNilString:etag_];
        self.movies = movies_;
        self.saved = saved_;
    }

    return self;
}


- (id) initWithCoder:(NSCoder*) coder {
    return [self initWithFeed:[coder decodeObjectForKey:feed_key]
                         etag:[coder decodeObjectForKey:etag_key]
                       movies:[coder decodeObjectForKey:movies_key]
                        saved:[coder decodeObjectForKey:saved_key]];
}


+ (Queue*) queueWithFeed:(Feed*) feed
                    etag:(NSString*) etag
                  movies:(NSArray*) movies
                   saved:(NSArray*) saved {
    return [[[Queue alloc] initWithFeed:feed
                                   etag:etag
                                 movies:movies
                                  saved:saved] autorelease];
}


+ (Queue*) queueWithDictionary:(NSDictionary*) dictionary {
    return [Queue queueWithFeed:[Feed feedWithDictionary:[dictionary objectForKey:feed_key]]
                           etag:[dictionary objectForKey:etag_key]
                         movies:[Movie decodeArray:[dictionary objectForKey:movies_key]]
                          saved:[Movie decodeArray:[dictionary objectForKey:saved_key]]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:feed.dictionary forKey:feed_key];
    [result setObject:etag forKey:etag_key];
    [result setObject:[Movie encodeArray:movies] forKey:movies_key];
    [result setObject:[Movie encodeArray:saved] forKey:saved_key];
    return result;
}


- (void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeObject:feed forKey:feed_key];
    [coder encodeObject:etag forKey:etag_key];
    [coder encodeObject:movies forKey:movies_key];
    [coder encodeObject:saved forKey:saved_key];
}


- (BOOL) isDVDQueue {
    return [[NetflixCache dvdQueueKey] isEqual:feed.key];
}


- (BOOL) isInstantQueue {
    return [[NetflixCache instantQueueKey] isEqual:feed.key];
}


- (BOOL) isAtHomeQueue {
    return [[NetflixCache atHomeKey] isEqual:feed.key];
}


@end