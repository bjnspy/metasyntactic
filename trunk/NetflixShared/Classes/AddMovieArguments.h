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

@interface AddMovieArguments : AbstractNetflixArguments {
@private
  Queue* queue;
  Movie* movie;
  NSString* format;
  NSInteger position;
  id<NetflixAddMovieDelegate> delegate;
}

@property (readonly, retain) Queue* queue;
@property (readonly, retain) Movie* movie;
@property (readonly, copy) NSString* format;
@property (readonly) NSInteger position;
@property (readonly, retain) id<NetflixAddMovieDelegate> delegate;

+ (AddMovieArguments*) argumentsWithQueue:(Queue*) queue
                                    movie:(Movie*) movie
                                   format:(NSString*) format
                                 position:(NSInteger) position
                                 delegate:(id<NetflixAddMovieDelegate>) delegate
                                  account:(NetflixAccount*) account;

@end
