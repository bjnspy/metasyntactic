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
    [operationQueue notifyOperationDestroyed:self withPriority:priority];

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
                 gate:(id<NSLocking>) gate_
             priority:(NSOperationQueuePriority) priority_ {
    if (self = [super init]) {
        self.target = target_;
        self.selector = selector_;
        self.operationQueue = operationQueue_;
        self.isBounded = isBounded_;
        self.gate = gate_;
        priority = priority_;
        self.queuePriority = priority_;
    }

    return self;
}


+ (Operation*) operationWithTarget:(id) target
                          selector:(SEL) selector
                    operationQueue:(OperationQueue*) operationQueue
                         isBounded:(BOOL) isBounded
                              gate:(id<NSLocking>) gate
                          priority:(NSOperationQueuePriority) priority {
    return [[[Operation alloc] initWithTarget:target
                                     selector:selector
                               operationQueue:operationQueue
                                    isBounded:isBounded
                                         gate:gate
                                     priority:priority] autorelease];
}


- (void) mainWorker {
    if (self.isCancelled) {
        return;
    }

    [target performSelector:selector];
}


- (void) main {
    [NSThread setThreadPriority:0];

    NSString* className = NSStringFromClass([target class]);
    NSString* selectorName = NSStringFromSelector(selector);
    NSString* name = [NSString stringWithFormat:@"%@:%@", className, selectorName];
    [[NSThread currentThread] setName:name];

    NSLog(@"Starting: %@", name);

    BOOL visible = (self.queuePriority >= Priority);

    [gate lock];
    {
        if (visible) {
            [GlobalActivityIndicator addVisibleBackgroundTask];
        }
        [self mainWorker];
        if (visible) {
            [GlobalActivityIndicator removeVisibleBackgroundTask];
        }
    }
    [gate unlock];

    NSLog(@"Stopping: %@", name);

    if (isBounded) {
        [operationQueue onAfterBoundedOperationCompleted:self];
    }
}


- (void) start {
    @try {
        [super start];
    } @catch (NSException* exception) {
        NSLog(@"******** Received exception ******** : %@", exception);
        [operationQueue restart:self];
    } @catch (id exception) {
        NSLog(@"******** Received unknown exception ********");
        [operationQueue restart:self];
    }
}


- (NSString*) description {
    NSString* className = NSStringFromClass([target class]);
    NSString* selectorName = NSStringFromSelector(selector);
    NSString* name = [NSString stringWithFormat:@"%d-%@-%@", self.queuePriority, className, selectorName];
    return name;
}

@end