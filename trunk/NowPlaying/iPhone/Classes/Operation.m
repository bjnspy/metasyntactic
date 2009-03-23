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

#import "Operation.h"

#import "GlobalActivityIndicator.h"
#import "OperationQueue.h"


@interface Operation()
@property (assign) OperationQueue* operationQueue;
@property (retain) id target;
@property SEL selector;
@property BOOL isBounded;
@property (retain) id<NSLocking> gate;
@end


@implementation Operation

@synthesize operationQueue;
@synthesize target;
@synthesize selector;
@synthesize isBounded;
@synthesize gate;

- (void) dealloc {
    self.operationQueue = nil;
    self.target = nil;
    self.selector = nil;
    self.isBounded = NO;
    self.gate = nil;

    [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
       operationQueue:(OperationQueue*) operationQueue_
            isBounded:(BOOL) isBounded_
                 gate:(id<NSLocking>) gate_ {
    if (self = [super init]) {
        self.target = target_;
        self.selector = selector_;
        self.operationQueue = operationQueue_;
        self.isBounded = isBounded_;
        self.gate = gate_;
    }

    return self;
}


+ (Operation*) operationWithTarget:(id) target
                          selector:(SEL) selector
                    operationQueue:(OperationQueue*) operationQueue
                         isBounded:(BOOL) isBounded
                              gate:(id<NSLocking>) gate {
    return [[[Operation alloc] initWithTarget:target
                                     selector:selector
                               operationQueue:operationQueue
                                    isBounded:isBounded
                                         gate:gate] autorelease];
}

/*
- (BOOL)isEqual:(id)anObject {
    if (![anObject isKindOfClass:[Operation class]]) {
        return NO;
    }

    Operation* other = anObject;
    return target == other.target && selector == other.selector;
}
 */


- (void) mainWorker {
    if (self.isCancelled) {
        return;
    }

    [target performSelector:selector];
}


- (void) main {
    NSString* className = NSStringFromClass([target class]);
    NSString* selectorName = NSStringFromSelector(selector);
    NSString* name = [NSString stringWithFormat:@"%@-%@", className, selectorName];
    [[NSThread currentThread] setName:name];

    BOOL visible =  (self.queuePriority >= NSOperationQueuePriorityLow);

    [gate lock];
    [GlobalActivityIndicator addBackgroundTask:visible];
    {
        [self mainWorker];
    }
    [GlobalActivityIndicator removeBackgroundTask:visible];
    [gate unlock];

    if (isBounded) {
        [operationQueue onAfterBoundedOperationCompleted:self];
    }
}

@end