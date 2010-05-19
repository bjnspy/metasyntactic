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

#import "NetflixFeedCache.h"

#import "Feed.h"
#import "NetflixAccount.h"
#import "NetflixPaths.h"
#import "Queue.h"

@interface NetflixFeedCache()
@property (retain) AutoreleasingMutableDictionary* accountToFeeds;
@property (retain) AutoreleasingMutableDictionary* accountToFeedKeyToQueues;
@end

@implementation NetflixFeedCache

static NetflixFeedCache* cache;

+ (void) initialize {
  if (self == [NetflixFeedCache class]) {
    cache = [[NetflixFeedCache alloc] init];
  }
}


+ (NetflixFeedCache*) cache {
  return cache;
}

@synthesize accountToFeeds;
@synthesize accountToFeedKeyToQueues;

- (void) dealloc {
  self.accountToFeeds = nil;
  self.accountToFeedKeyToQueues = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.accountToFeeds = [AutoreleasingMutableDictionary dictionary];
    self.accountToFeedKeyToQueues = [AutoreleasingMutableDictionary dictionary];
  }

  return self;
}


- (NSArray*) loadAccountToFeeds:(NetflixAccount*) account {
  NSArray* array = [FileUtilities readObject:[NetflixPaths feedsFile:account]];
  return [Feed decodeArray:array];
}


- (NSArray*) feedsForAccountNoLock:(NetflixAccount*) account {
  NSArray* feeds = [self.accountToFeeds objectForKey:account.userId];
  if (feeds != nil) {
    return feeds;
  }

  NSArray* array = [self loadAccountToFeeds:account];
  if (array != nil) {
    [self.accountToFeeds setObject:array forKey:account.userId];
  }
  return array;
}


- (NSArray*) feedsForAccount:(NetflixAccount*) account {
  NSArray* result;
  [dataGate lock];
  {
    result = [self feedsForAccountNoLock:account];
  }
  [dataGate unlock];
  return result;
}


- (void) addQueue:(Queue*) queue account:(NetflixAccount*) account {
  [dataGate lock];
  {
    NSMutableDictionary* feedKeyToQueues = [self.accountToFeedKeyToQueues objectForKey:account.userId];
    if (feedKeyToQueues == nil) {
      feedKeyToQueues = [NSMutableDictionary dictionary];
      [self.accountToFeedKeyToQueues setObject:feedKeyToQueues forKey:account.userId];
    }
    [feedKeyToQueues setObject:queue forKey:queue.feed.key];
  }
  [dataGate unlock];
}


- (void) saveQueue:(Queue*) queue account:(NetflixAccount*) account {
  NSLog(@"Saving queue '%@' with etag '%@'", queue.feed.name, queue.etag);
  [FileUtilities writeObject:queue.dictionary toFile:[NetflixPaths queueFile:queue.feed account:account]];
  [FileUtilities writeObject:queue.etag toFile:[NetflixPaths queueEtagFile:queue.feed account:account]];
  [self addQueue:queue account:account];
}


- (Queue*) loadQueue:(Feed*) feed account:(NetflixAccount*) account {
  NSLog(@"Loading queue: %@", feed.name);
  NSDictionary* dictionary = [FileUtilities readObject:[NetflixPaths queueFile:feed account:account]];
  if (dictionary.count == 0) {
    return nil;
  }

  return [Queue queueWithDictionary:dictionary];
}


- (Queue*) queueForFeedNoLock:(Feed*) feed account:(NetflixAccount*) account {
  if (feed == nil) {
    return nil;
  }

  Queue* queue = [[self.accountToFeedKeyToQueues objectForKey:account.userId] objectForKey:feed.key];
  if (queue == nil) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      queue = [self loadQueue:feed account:account];
      if (queue != nil) {
        [self addQueue:queue account:account];
      }
    }
    [pool release];
  }

  return queue;
}


- (Queue*) queueForFeed:(Feed*) feed account:(NetflixAccount*) account {
  Queue* queue = nil;
  [dataGate lock];
  {
    queue = [self queueForFeedNoLock:feed account:account];
  }
  [dataGate unlock];
  return queue;
}


- (Feed*) feedForKey:(NSString*) key account:(NetflixAccount*) account {
  for (Feed* feed in [self feedsForAccount:account]) {
    if ([key isEqual:feed.key]) {
      return feed;
    }
  }

  return nil;
}


- (Queue*) queueForKey:(NSString*) key account:(NetflixAccount*) account {
  return [self queueForFeed:[self feedForKey:key account:account] account:account];
}


- (void) saveFeeds:(NSArray*) feeds account:(NetflixAccount*) account {
  if (feeds.count == 0) {
    return;
  }

  [FileUtilities writeObject:[Feed encodeArray:feeds]
                      toFile:[NetflixPaths feedsFile:account]];

  [dataGate lock];
  {
    [self.accountToFeeds setObject:feeds forKey:account.userId];
  }
  [dataGate unlock];
}

@end
