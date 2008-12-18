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

#import "Feed.h"

@interface Feed()
@property (retain) NSString* url;
@property (retain) NSString* key;
@property (retain) NSString* name;
@end


@implementation Feed

property_definition(url);
property_definition(key);
property_definition(name);

- (void) dealloc {
    self.url = nil;
    self.key = nil;
    self.name = nil;
    
    [super dealloc];
}


- (id) initWithUrl:(NSString*) url_
                 key:(NSString*) key_
                name:(NSString*) name_ {
    if (self = [super init]) {
        self.url = url_;
        self.key = key_;
        self.name = name_;
    }
    
    return self;
}


+ (Feed*) feedWithUrl:(NSString*) url key:(NSString*) key name:(NSString*) name {
    return [[[Feed alloc] initWithUrl:url key:key name:name] autorelease];
}


+ (Feed*) feedWithDictionary:(NSDictionary*) dictionary {
    return [Feed feedWithUrl:[dictionary objectForKey:url_key]
                         key:[dictionary objectForKey:key_key]
                        name:[dictionary objectForKey:name_key]];
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:url   forKey:url_key];
    [result setObject:key   forKey:key_key];
    [result setObject:name  forKey:name_key];
    return result;
}


- (BOOL) isRecommendationsFeed {
    return [key isEqual:@"http://schemas.netflix.com/feed.recommendations"];
}


- (BOOL) isDVDQueueFeed {
    return [key isEqual:@"http://schemas.netflix.com/feed.queues.disc"];
}


- (BOOL) isInstantQueueFeed {
    return [key isEqual:@"http://schemas.netflix.com/feed.queues.instant"];
}


- (BOOL) isAtHomeFeed {
    return [key isEqual:@"http://schemas.netflix.com/feed.at_home"];
}

//@"http://schemas.netflix.com/feed.rental_history",
//@"http://schemas.netflix.com/feed.rental_history.watched",
//@"http://schemas.netflix.com/feed.rental_history.returned",

@end