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

#import "AbstractNetflixArguments.h"

@interface ModifyQueueArguments : AbstractNetflixArguments {
@private
  Queue* queue;
  NSSet* deletedMovies;
  NSSet* reorderedMovies;
  NSArray* moviesInOrder;
  id<NetflixModifyQueueDelegate> delegate;
}

@property (readonly, retain) Queue* queue;
@property (readonly, retain) NSSet* deletedMovies;
@property (readonly, retain) NSSet* reorderedMovies;
@property (readonly, retain) NSArray* moviesInOrder;
@property (readonly, retain) id<NetflixModifyQueueDelegate> delegate;

+ (ModifyQueueArguments*) argumentsWithQueue:(Queue*) queue
                             deletedMovies:(NSSet*) deletedMovies
                           reorderedMovies:(NSSet*) reorderedMovies
                                     moviesInOrder:(NSArray*) moviesInOrder
                                  delegate:(id<NetflixModifyQueueDelegate>) delegate
                                   account:(NetflixAccount*) account;

@end
