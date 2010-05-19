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

#import "Operation1.h"

@interface Operation1()
@property (retain) id argument1;
@end


@implementation Operation1

@synthesize argument1;

- (void) dealloc {
  self.argument1 = nil;
  [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id)argument1_
       operationQueue:(OperationQueue*) operationQueue_
            isBounded:(BOOL) isBounded_
                 gate:(id<NSLocking>) gate_
             priority:(NSOperationQueuePriority) priority_ {
  if ((self = [super initWithTarget:target_
                           selector:selector_
                     operationQueue:operationQueue_
                          isBounded:isBounded_
                               gate:gate_
                           priority:priority_])) {
    self.argument1 = argument1_;
  }

  return self;
}


+ (Operation1*) operationWithTarget:(id) target
                           selector:(SEL) selector
                           argument:(id) argument1
                     operationQueue:(OperationQueue*) operationQueue
                          isBounded:(BOOL) isBounded
                               gate:(id<NSLocking>) gate
                           priority:(NSOperationQueuePriority) priority {
  return [[[Operation1 alloc] initWithTarget:target
                                    selector:selector
                                    argument:argument1
                              operationQueue:operationQueue
                                   isBounded:isBounded
                                        gate:gate
                                    priority:priority] autorelease];
}


- (void) mainWorker {
  [target performSelector:selector withObject:argument1];
}


@end
