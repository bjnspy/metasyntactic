// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
