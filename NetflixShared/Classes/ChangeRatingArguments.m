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

#import "ChangeRatingArguments.h"

@interface ChangeRatingArguments()
@property (copy) NSString* rating;
@property (retain) Movie* movie;
@property (retain) id<NetflixChangeRatingDelegate> delegate;
@end


@implementation ChangeRatingArguments

@synthesize rating;
@synthesize movie;
@synthesize delegate;

- (void) dealloc {
  self.rating = nil;
  self.movie = nil;
  self.delegate = nil;
  [super dealloc];
}


- (id) initWithRating:(NSString*) rating_
               movie:(Movie*) movie_
            delegate:(id<NetflixChangeRatingDelegate>) delegate_
             account:(NetflixAccount*) account_ {
  if ((self = [super initWithAccount:account_])) {
    self.rating = rating_;
    self.movie = movie_;
    self.delegate = delegate_;
  }
  return self;
}


+ (ChangeRatingArguments*) argumentsWithRating:(NSString*) rating
                                     movie:(Movie*) movie
                                  delegate:(id<NetflixChangeRatingDelegate>) delegate
                                   account:(NetflixAccount*) account {
  return [[[ChangeRatingArguments alloc] initWithRating:rating movie:movie delegate:delegate account:account] autorelease];
}

@end
