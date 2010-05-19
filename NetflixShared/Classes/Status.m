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

#import "Status.h"

@interface Status()
@property (retain) Queue* queue;
@property (retain) Movie* movie;
@property (copy) NSString* description;
@property BOOL saved;
@property NSInteger position;
@end

@implementation Status

@synthesize queue;
@synthesize movie;
@synthesize description;
@synthesize saved;
@synthesize position;

- (void) dealloc {
  self.queue = nil;
  self.movie = nil;
  self.description = nil;
  self.saved = NO;
  self.position = 0;

  [super dealloc];
}


- (id) initWithWithQueue:(Queue*) queue__
                   movie:(Movie*) movie__
             description:(NSString*) description__
                   saved:(BOOL) saved__
                position:(NSInteger) position__ {
  if ((self = [super init])) {
    self.queue = queue__;
    self.movie = movie__;
    self.description = description__;
    self.saved = saved__;
    self.position = position__;
  }

  return self;
}


+ (Status*) statusWithQueue:(Queue*) queue
                      movie:(Movie*) movie
                description:(NSString*) description
                      saved:(BOOL) saved
                   position:(NSInteger) position {
  return [[[Status alloc] initWithWithQueue:queue
                                      movie:movie
                                description:description
                                      saved:saved
                                   position:position] autorelease];
}

@end
