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

#import "Operation3.h"


@interface Operation3()
@property (retain) id argument3;
@end


@implementation Operation3

@synthesize argument3;

- (void) dealloc {
  self.argument3 = nil;
  [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id) argument1_
             argument:(id) argument2_
             argument:(id) argument3_
       operationQueue:(OperationQueue*) operationQueue_
            isBounded:(BOOL) isBounded_
                 gate:(id<NSLocking>) gate_
             priority:(NSOperationQueuePriority) priority_ {
  if ((self = [super initWithTarget:target_
                           selector:selector_
                           argument:argument1_
                           argument:argument2_
                     operationQueue:operationQueue_
                          isBounded:isBounded_
                               gate:gate_
                           priority:priority_])) {
    self.argument3 = argument3_;
  }

  return self;
}


+ (Operation3*) operationWithTarget:(id) target
                           selector:(SEL) selector
                           argument:(id) argument1
                           argument:(id) argument2
                           argument:(id) argument3
                     operationQueue:(OperationQueue*) operationQueue
                          isBounded:(BOOL) isBounded
                               gate:(id<NSLocking>) gate
                           priority:(NSOperationQueuePriority) priority {
  return [[[Operation3 alloc] initWithTarget:target
                                    selector:selector
                                    argument:argument1
                                    argument:argument2
                                    argument:argument3
                              operationQueue:operationQueue
                                   isBounded:isBounded
                                        gate:gate
                                    priority:priority] autorelease];
}


- (void) mainWorker {
  IMP imp = [target methodForSelector:selector];
  imp(target, selector, argument1, argument2, argument3);
}

@end
