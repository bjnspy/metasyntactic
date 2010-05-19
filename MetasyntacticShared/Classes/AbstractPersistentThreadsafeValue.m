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

#import "AbstractPersistentThreadsafeValue.h"

@interface AbstractPersistentThreadsafeValue()
@property (retain) NSString* file;
@end


@implementation AbstractPersistentThreadsafeValue

@synthesize file;

- (void) dealloc {
  self.file = nil;
  [super dealloc];
}


- (id) initWithGate:(id<NSLocking>) gate file:(NSString*) file_ {
  if ((self = [super initWithGate:gate
                         delegate:self
                     loadSelector:@selector(loadFromFile)
                     saveSelector:@selector(saveToFile:)])) {
    self.file = file_;
  }
  return self;
}

@end
