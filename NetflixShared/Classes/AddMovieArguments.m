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

#import "AddMovieArguments.h"

@interface AddMovieArguments()
@property (retain) Queue* queue;
@property (retain) Movie* movie;
@property (copy) NSString* format;
@property NSInteger position;
@property (retain) id<NetflixAddMovieDelegate> delegate;
@end


@implementation AddMovieArguments

@synthesize queue;
@synthesize movie;
@synthesize format;
@synthesize position;
@synthesize delegate;

- (void) dealloc {
  self.queue = nil;
  self.movie = nil;
  self.format = nil;
  self.position = 0;
  self.delegate = nil;
  [super dealloc];
}


- (id) initWithQueue:(Queue*) queue_
               movie:(Movie*) movie_
              format:(NSString*) format_
            position:(NSInteger) position_
            delegate:(id<NetflixAddMovieDelegate>) delegate_
             account:(NetflixAccount*) account_ {
  if ((self = [super initWithAccount:account_])) {
    self.queue = queue_;
    self.movie = movie_;
    self.format = format_;
    self.position = position_;
    self.delegate = delegate_;
  }
  return self;
}


+ (AddMovieArguments*) argumentsWithQueue:(Queue*) queue
                                     movie:(Movie*) movie
                                   format:(NSString*) format
                                  position:(NSInteger) position
                                  delegate:(id<NetflixAddMovieDelegate>) delegate
                                   account:(NetflixAccount*) account {
  return [[[AddMovieArguments alloc] initWithQueue:queue movie:movie format:format position:position delegate:delegate account:account] autorelease];
}

@end
