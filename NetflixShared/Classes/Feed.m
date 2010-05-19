// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "Feed.h"

@interface Feed()
@property (copy) NSString* url;
@property (copy) NSString* key;
@property (copy) NSString* name;
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
  if ((self = [super init])) {
    self.url = url_;
    self.key = key_;
    self.name = name_;
  }

  return self;
}


- (id) initWithCoder:(NSCoder*) coder {
  return [self initWithUrl:[coder decodeObjectForKey:url_key]
                       key:[coder decodeObjectForKey:key_key]
                      name:[coder decodeObjectForKey:name_key]];
}


+ (Feed*) feedWithUrl:(NSString*) url key:(NSString*) key name:(NSString*) name {
  return [[[Feed alloc] initWithUrl:url key:key name:name] autorelease];
}


+ (Feed*) createWithDictionaryWorker:(NSDictionary*) dictionary {
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


- (void) encodeWithCoder:(NSCoder*) coder {
  [coder encodeObject:url   forKey:url_key];
  [coder encodeObject:key   forKey:key_key];
  [coder encodeObject:name  forKey:name_key];
}


- (id) copyWithZone:(NSZone*) zone {
  return [self retain];
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
