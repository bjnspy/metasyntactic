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

#import "Operation2.h"


@interface Operation2()
@property (retain) id argument2;
@end


@implementation Operation2

@synthesize argument2;

- (void) dealloc {
  self.argument2 = nil;
  [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id) argument1_
             argument:(id) argument2_
       operationQueue:(OperationQueue*) operationQueue_
            isBounded:(BOOL) isBounded_
                 gate:(id<NSLocking>) gate_
             priority:(NSOperationQueuePriority) priority_ {
  if ((self = [super initWithTarget:target_
                           selector:selector_
                           argument:argument1_
                     operationQueue:operationQueue_
                          isBounded:isBounded_
                               gate:gate_
                           priority:priority_])) {
    self.argument2 = argument2_;
  }

  return self;
}


+ (Operation2*) operationWithTarget:(id) target
                           selector:(SEL) selector
                           argument:(id) argument1
                           argument:(id) argument2
                     operationQueue:(OperationQueue*) operationQueue
                          isBounded:(BOOL) isBounded
                               gate:(id<NSLocking>) gate
                           priority:(NSOperationQueuePriority) priority {
  return [[[Operation2 alloc] initWithTarget:target
                                    selector:selector
                                    argument:argument1
                                    argument:argument2
                              operationQueue:operationQueue
                                   isBounded:isBounded
                                        gate:gate
                                    priority:priority] autorelease];
}


- (void) mainWorker {
  [target performSelector:selector withObject:argument1 withObject:argument2];
}

@end
