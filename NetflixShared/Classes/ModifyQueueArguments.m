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

#import "ModifyQueueArguments.h"

@interface ModifyQueueArguments()
@property (retain) Queue* queue;
@property (retain) NSSet* deletedMovies;
@property (retain) NSSet* reorderedMovies;
@property (retain) NSArray* moviesInOrder;
@property (retain) id<NetflixModifyQueueDelegate> delegate;
@end


@implementation ModifyQueueArguments

@synthesize queue;
@synthesize deletedMovies;
@synthesize reorderedMovies;
@synthesize moviesInOrder;
@synthesize delegate;

- (void) dealloc {
  self.queue = nil;
  self.deletedMovies = nil;
  self.reorderedMovies = nil;
  self.moviesInOrder = nil;
  self.delegate = nil;
  [super dealloc];
}


- (id) initWithQueue:(Queue*) queue_
       deletedMovies:(NSSet*) deletedMovies_
     reorderedMovies:(NSSet*) reorderedMovies_
               moviesInOrder:(NSArray*) moviesInOrder_
            delegate:(id<NetflixModifyQueueDelegate>) delegate_
             account:(NetflixAccount*) account_ {
  if ((self = [super initWithAccount:account_])) {
    self.queue = queue_;
    self.deletedMovies = deletedMovies_;
    self.reorderedMovies = reorderedMovies_;
    self.moviesInOrder = moviesInOrder_;
    self.delegate = delegate_;
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
