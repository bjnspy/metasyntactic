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

#import "Queue.h"

#import "Feed.h"
#import "Movie.h"
#import "NetflixCache.h"
#import "NetflixConstants.h"

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
  if ((self = [super init])) {
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
  return [Queue queueWithFeed:[Feed createWithDictionary:[dictionary objectForKey:feed_key]]
                         etag:[dictionary objectForKey:etag_key]
                       movies:[Movie decodeArray:[dictionary objectForKey:movies_key]]
                        saved:[Movie decodeArray:[dictionary objectForKey:saved_key]]];
}


- (NSDictionary*) dictionary {
  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  [result setObject:feed.dictionary               forKey:feed_key];
  [result setObject:etag                          forKey:etag_key];
  [result setObject:[Movie encodeArray:movies]    forKey:movies_key];
  [result setObject:[Movie encodeArray:saved]     forKey:saved_key];
  return result;
}


- (void) encodeWithCoder:(NSCoder*) coder {
  [coder encodeObject:feed    forKey:feed_key];
  [coder encodeObject:etag    forKey:etag_key];
  [coder encodeObject:movies  forKey:movies_key];
  [coder encodeObject:saved   forKey:saved_key];
}


- (BOOL) isDVDQueue {
  return [[NetflixConstants discQueueKey] isEqual:feed.key];
}


- (BOOL) isInstantQueue {
  return [[NetflixConstants instantQueueKey] isEqual:feed.key];
}


- (BOOL) isAtHomeQueue {
  return [[NetflixConstants atHomeKey] isEqual:feed.key];
}


@end
