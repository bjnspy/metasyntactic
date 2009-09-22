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

#import "ModifyQueueArguments.h"

@interface ModifyQueueArguments()
@property (retain) Queue* queue;
@property (retain) NSSet* deletedMovies;
@property (retain) NSSet* reorderedMovies;
@property (retain) NSArray* moviesInOrder;
@property (retain) id<NetflixModifyQueueDelegate> delegate;
@property (retain) NetflixAccount* account;
@end


@implementation ModifyQueueArguments

@synthesize queue;
@synthesize deletedMovies;
@synthesize reorderedMovies;
@synthesize moviesInOrder;
@synthesize delegate;
@synthesize account;

- (void) dealloc {
  self.queue = nil;
  self.deletedMovies = nil;
  self.reorderedMovies = nil;
  self.moviesInOrder = nil;
  self.delegate = nil;
  self.account = nil;
  [super dealloc];
}


- (id) initWithQueue:(Queue*) queue_
       deletedMovies:(NSSet*) deletedMovies_
     reorderedMovies:(NSSet*) reorderedMovies_
               moviesInOrder:(NSArray*) moviesInOrder_
            delegate:(id<NetflixModifyQueueDelegate>) delegate_
             account:(NetflixAccount*) account_ {
  if ((self = [super init])) {
    self.queue = queue_;
    self.deletedMovies = deletedMovies_;
    self.reorderedMovies = reorderedMovies_;
    self.moviesInOrder = moviesInOrder_;
    self.delegate = delegate_;
    self.account = account_;
  }
  return self;
}


+ (ModifyQueueArguments*) argumentsWithQueue:(Queue*) queue
                             deletedMovies:(NSSet*) deletedMovies
                           reorderedMovies:(NSSet*) reorderedMovies
                                     moviesInOrder:(NSArray*) moviesInOrder
                                  delegate:(id<NetflixModifyQueueDelegate>) delegate
                                   account:(NetflixAccount*) account {
  return [[[ModifyQueueArguments alloc] initWithQueue:queue
                                      deletedMovies:deletedMovies
                                    reorderedMovies:reorderedMovies
                                              moviesInOrder:moviesInOrder
                                           delegate:delegate
                                            account:account] autorelease];
}

@end
