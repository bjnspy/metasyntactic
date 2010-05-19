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

#import "PriorityMutex.h"

@interface PriorityMutex()
@property (retain) NSCondition* gate;
@end

@implementation PriorityMutex

@synthesize gate;


- (void) dealloc {
  self.gate = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.gate = [[[NSCondition alloc] init] autorelease];

    highTaskRunningCount = 0;
  }

  return self;
}


+ (PriorityMutex*) mutex {
  return [[[PriorityMutex alloc] init] autorelease];
}


- (void) lockHigh {
  [gate lock];
  {
    highTaskRunningCount++;
  }
  [gate unlock];
}


- (void) unlockHigh {
  [gate lock];
  {
    highTaskRunningCount--;
    if (highTaskRunningCount == 0) {
      // wake up a low pri thread that is waiting
      // don't wake them all up as we don't want to
      // move right back into a condition where all the
      // low pri threads are consuming all the resources
      [gate signal];
    }
  }
  [gate unlock];
}


- (void) lockLow {
  [gate lock];
  {
    while (highTaskRunningCount > 0) {
      [gate wait];
    }
  }
  [gate unlock];
}


- (void) unlockLow {
  [gate lock];
  {
    // wake up another low pri thread that might have been waiting.
    [gate signal];
  }
  [gate unlock];
}

@end
