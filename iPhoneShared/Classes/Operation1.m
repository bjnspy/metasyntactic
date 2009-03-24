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
                 gate:(id<NSLocking>) gate_ {
    if (self = [super initWithTarget:target_
                            selector:selector_
                      operationQueue:operationQueue_
                           isBounded:isBounded_
                                gate:gate_]) {
        self.argument1 = argument1_;
    }

    return self;
}


+ (Operation1*) operationWithTarget:(id) target
                           selector:(SEL) selector
                           argument:(id) argument1
                     operationQueue:(OperationQueue*) operationQueue
                          isBounded:(BOOL) isBounded
                               gate:(id<NSLocking>) gate {
    return [[[Operation1 alloc] initWithTarget:target
                                      selector:selector
                                      argument:argument1
                                operationQueue:operationQueue
                                     isBounded:isBounded
                                          gate:gate] autorelease];
}


- (void) mainWorker {
    [target performSelector:selector withObject:argument1];
}


@end