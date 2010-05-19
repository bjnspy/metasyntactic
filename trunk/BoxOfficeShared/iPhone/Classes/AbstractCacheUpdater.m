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

#import "AbstractCacheUpdater.h"

#import "AmazonCache.h"
#import "BlurayCache.h"
#import "DVDCache.h"
#import "IMDbCache.h"
#import "MetacriticCache.h"
#import "MoviePosterCache.h"
#import "RottenTomatoesCache.h"
#import "ScoreCache.h"
#import "TrailerCache.h"
#import "UpcomingCache.h"
#import "WikipediaCache.h"

@interface AbstractCacheUpdater()
@property (retain) NSCondition* gate;
@property (retain) NSArray* searchOperations;
@property (retain) AutoreleasingMutableArray* imageOperations;
@end


@implementation AbstractCacheUpdater

@synthesize gate;
@synthesize searchOperations;
@synthesize imageOperations;

- (void) dealloc {
  self.gate = nil;
  self.searchOperations = nil;
  self.imageOperations = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.gate = [[[NSCondition alloc] init] autorelease];
    self.imageOperations = [AutoreleasingMutableArray array];
    [ThreadingUtilities backgroundSelector:@selector(updateImagesBackgroundEntryPoint)
                                  onTarget:self
                                      gate:nil
                                    daemon:YES];
  }

  return self;
}


- (void) processObject:(id) object
                 force:(NSNumber*) forceNumber AbstractMethod;


- (void) updateImageWorker:(id) object AbstractMethod;


- (void) prioritizeObject:(id) object now:(BOOL) now {
  if (now) {
    [ThreadingUtilities backgroundSelector:@selector(processObject:force:)
                                  onTarget:self
                                withObject:object
                                withObject:[NSNumber numberWithBool:YES]
                                      gate:nil
                                    daemon:NO];
  } else {
    [gate lock];
    {
      [imageOperations addObject:object];
      if (imageOperations.count > 5) {
        [imageOperations removeFirstObject];
      }
      [gate broadcast];
    }
    [gate unlock];
    [[OperationQueue operationQueue] performBoundedSelector:@selector(processObject:force:)
                                                   onTarget:self
                                                 withObject:object
                                                 withObject:[NSNumber numberWithBool:NO]
                                                       gate:nil
                                                   priority:Priority];
  }
}


- (Operation2*) addSearchObject:(id) object {
  return [[OperationQueue operationQueue] performSelector:@selector(processObject:force:)
                                                 onTarget:self
                                               withObject:object
                                               withObject:[NSNumber numberWithBool:NO]
                                                     gate:nil
                                                 priority:Search];
}


- (void) addObject:(id) object {
  if (object == nil) {
    return;
  }

  [[OperationQueue operationQueue] performSelector:@selector(processObject:force:)
                                          onTarget:self
                                        withObject:object
                                        withObject:[NSNumber numberWithBool:NO]
                                              gate:nil
                                          priority:Low];
}


- (void) addSearchObjects:(NSArray*) objects {
  [gate lock];
  {
    for (Operation* operation in searchOperations) {
      [operation cancel];
    }

    NSMutableArray* operations = [NSMutableArray array];
    for (id object in objects) {
      [operations addObject:[self addSearchObject:object]];
    }

    self.searchOperations = operations;
  }
  [gate unlock];
}


- (void) addObjects:(NSArray*) objects {
  for (id object in [objects shuffledArray]) {
    [self addObject:object];
  }
}


- (void) updateImagesBackgroundEntryPointWorker {
  id object = nil;
  [gate lock];
  {
    while (imageOperations.count == 0) {
      [gate wait];
    }
    object = imageOperations.lastObject;
    [imageOperations removeLastObject];
  }
  [gate unlock];

  [self updateImageWorker:object];
}


- (void) updateImagesBackgroundEntryPoint {
  while (YES) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      [self updateImagesBackgroundEntryPointWorker];
    }
    [pool release];
  }
}

@end
