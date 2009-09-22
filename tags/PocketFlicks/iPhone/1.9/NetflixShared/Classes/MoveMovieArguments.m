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

#import "MoveMovieArguments.h"

@interface MoveMovieArguments()
@property (retain) Queue* queue;
@property (retain) Movie* movie;
@property (retain) id<NetflixMoveMovieDelegate> delegate;
@property (retain) NetflixAccount* account;
@end


@implementation MoveMovieArguments

@synthesize queue;
@synthesize movie;
@synthesize delegate;
@synthesize account;

- (void) dealloc {
  self.queue = nil;
  self.movie = nil;
  self.delegate = nil;
  self.account = nil;
  [super dealloc];
}


- (id) initWithQueue:(Queue*) queue_
               movie:(Movie*) movie_
            delegate:(id<NetflixMoveMovieDelegate>) delegate_
             account:(NetflixAccount*) account_ {
  if ((self = [super init])) {
    self.queue = queue_;
    self.movie = movie_;
    self.delegate = delegate_;
    self.account = account_;
  }
  return self;
}


+ (MoveMovieArguments*) argumentsWithQueue:(Queue*) queue
                                     movie:(Movie*) movie
                                  delegate:(id<NetflixMoveMovieDelegate>) delegate
                                    account:(NetflixAccount*) account {
  return [[[MoveMovieArguments alloc] initWithQueue:queue movie:movie delegate:delegate account:account] autorelease];
}

@end
