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

#import "AddMovieArguments.h"

@interface AddMovieArguments()
@property (retain) Queue* queue;
@property (retain) Movie* movie;
@property NSInteger position;
@property (retain) id<NetflixAddMovieDelegate> delegate;
@property (retain) NetflixAccount* account;
@end


@implementation AddMovieArguments

@synthesize queue;
@synthesize movie;
@synthesize position;
@synthesize delegate;
@synthesize account;

- (void) dealloc {
  self.queue = nil;
  self.movie = nil;
  self.position = 0;
  self.delegate = nil;
  self.account = nil;
  [super dealloc];
}


- (id) initWithQueue:(Queue*) queue_
               movie:(Movie*) movie_
            position:(NSInteger) position_
            delegate:(id<NetflixAddMovieDelegate>) delegate_
             account:(NetflixAccount*) account_ {
  if ((self = [super init])) {
    self.queue = queue_;
    self.movie = movie_;
    self.position = position_;
    self.delegate = delegate_;
    self.account = account_;
  }
  return self;
}


+ (AddMovieArguments*) argumentsWithQueue:(Queue*) queue
                                     movie:(Movie*) movie
                                  position:(NSInteger) position
                                  delegate:(id<NetflixAddMovieDelegate>) delegate
                                   account:(NetflixAccount*) account {
  return [[[AddMovieArguments alloc] initWithQueue:queue movie:movie position:position delegate:delegate account:account] autorelease];
}

@end
