//
//  Feed.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

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


- (NSString*) title {
    if ([key isEqual:@"http://schemas.netflix.com/feed.queues.disc"]) {
        return NSLocalizedString(@"DVDs (%@)", nil);
    } else if ([key isEqual:@"http://schemas.netflix.com/feed.queues.disc.recent"]) {
        return NSLocalizedString(@"DVDs - Recently Added (%@)", nil);
    } else if ([key isEqual:@"http://schemas.netflix.com/feed.queues.instant"]) {
        return NSLocalizedString(@"Instant (%@)", nil);
    } else if ([key isEqual:@"http://schemas.netflix.com/feed.queues.instant.recent"]) {
        return NSLocalizedString(@"Instant - Recently Added (%@)", nil);
    } else if ([key isEqual:@"http://schemas.netflix.com/feed.at_home"]) {
        return NSLocalizedString(@"At Home (%@)", nil);
    } else if ([key isEqual:@"http://schemas.netflix.com/feed.rental_history.watched"]) {
        return NSLocalizedString(@"Recently Watched (%@)", nil);
    } else if ([key isEqual:@"http://schemas.netflix.com/feed.rental_history.returned"]) {
        return NSLocalizedString(@"Recently Returned (%@)", nil);
    } else if ([key isEqual:@"http://schemas.netflix.com/feed.recommendations"]) {
        return NSLocalizedString(@"Recommendations (%@)", nil);
    }
    
    return name;
}


- (NSDictionary*) dictionary {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [result setObject:url   forKey:url_key];
    [result setObject:key   forKey:key_key];
    [result setObject:name  forKey:name_key];
    return result;
}


- (BOOL) isRecommendationFeed {
    return [key isEqual:@"http://schemas.netflix.com/feed.recommendations"];
}

@end
