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

#import "MoveMovieArguments.h"

@interface MoveMovieArguments()
@property (retain) Queue* queue;
@property (retain) Movie* movie;
@property (retain) id<NetflixMoveMovieDelegate> delegate;
@end


@implementation MoveMovieArguments

@synthesize queue;
@synthesize movie;
@synthesize delegate;

- (void) dealloc {
  self.queue = nil;
  self.movie = nil;
  self.delegate = nil;
  [super dealloc];
}


- (id) initWithQueue:(Queue*) queue_
               movie:(Movie*) movie_
            delegate:(id<NetflixMoveMovieDelegate>) delegate_
             account:(NetflixAccount*) account_ {
  if ((self = [super initWithAccount:account_])) {
    self.queue = queue_;
    self.movie = movie_;
    self.delegate = delegate_;
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
