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

#import "AbstractController.h"

#import "AbstractModel.h"

@interface AbstractController()
@property (retain) AbstractModel* abstractModel;
@end

@implementation AbstractController

@synthesize abstractModel;

- (void) dealloc {
  self.abstractModel = nil;
  [super dealloc];
}


- (id) initWithModel:(AbstractModel*) abstractModel_ {
  if ((self = [super init])) {
    self.abstractModel = abstractModel_;
  }
  return self;
}


- (id) init {
  @throw [NSException exceptionWithName:@"UnsupportedOperation" reason:@"" userInfo:nil];
}


- (void) startWorker:(BOOL) force AbstractMethod;

- (void) start:(BOOL) force {
  [abstractModel tryShowWriteReviewRequest];

  [self startWorker:force];
}


- (void) start {
  [self start:NO];
}

@end
