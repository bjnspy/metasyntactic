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

#import "ThreadingUtilities.h"

#import "BackgroundInvocation.h"
#import "BackgroundInvocation2.h"
#import "Invocation2.h"
#import "PriorityMutex.h"

@implementation ThreadingUtilities

#if 0
static PriorityMutex* mutex;
static NSCondition* condition;
static NSMutableArray* highPriorityOperations;
static NSMutableArray* lowPriorityOperations;

+ (void) initialize {
    if (self == [ThreadingUtilities class]) {
        mutex = [[PriorityMutex mutex] retain];
        condition = [[NSCondition alloc] init];
        highPriorityOperations = [[NSMutableArray alloc] init];
        lowPriorityOperations = [[NSMutableArray alloc] init];
        
        NSThread* highPriorityThread = [[NSThread alloc] initWithTarget:[ThreadingUtilities class]
                                                               selector:@selector(run:)
                                                                 object:highPriorityOperations];
        
        NSThread* lowPriorityThread = [[NSThread alloc] initWithTarget:[ThreadingUtilities class]
                                                              selector:@selector(run:)
                                                                object:lowPriorityOperations];
        
        [highPriorityThread start];
        [lowPriorityThread start];
    }
}


+ (BackgroundInvocation*) extractNextOperation:(NSMutableArray*) operations {
    BackgroundInvocation* invocation = nil;
    
    [condition lock];
    {
        while (operations.count == 0) {
            [condition wait];
        }
        
        invocation = [[[operations objectAtIndex:0] retain] autorelease];
        [operations removeObjectAtIndex:0];
    }
    [condition unlock];
    
    return invocation;
}


+ (void) lock:(NSArray*) operations {
    if (operations == highPriorityOperations) {
        [mutex lockHigh];
    } else {
        [mutex lockLow];
    }
}


+ (void) unlock:(NSArray*) operations {
    if (operations == highPriorityOperations) {
        [mutex unlockHigh];
    } else {
        [mutex unlockLow];
    }
}


+ (void) runWorker:(NSMutableArray*) operations {
    while (YES) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            BackgroundInvocation* invocation = [self extractNextOperation:operations];
            
            [self lock:operations];
            {
                [invocation run];
            }
            [self unlock:operations];
        }
        [pool release];
    }
}

+ (void) run:(NSMutableArray*) operations {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
        [self runWorker:operations];
    }
    [pool release];
}


+ (void)       performSelector:(SEL) selector
                      onTarget:(id) target
      inBackgroundWithArgument:(id) argument
                          gate:(NSLock*) gate
                       visible:(BOOL) visible {
    BackgroundInvocation* invocation = [BackgroundInvocation invocationWithTarget:target
                                                                         selector:selector
                                                                         argument:argument
                                                                             gate:gate
                                                                          visible:visible];
    [condition lock];
    {
        if (visible) {
            [highPriorityOperations addObject:invocation];
        } else {
            [lowPriorityOperations addObject:invocation];
        }
        
        [condition broadcast];
    }
    [condition unlock];
}
#endif

+ (void)       performSelector:(SEL) selector
                      onTarget:(id) target
      inBackgroundWithArgument:(id) argument1
                      argument:(id) argument2
                          gate:(id<NSLocking>) gate
                       visible:(BOOL) visible {
    BackgroundInvocation2* invocation = [BackgroundInvocation2 invocationWithTarget:target
                                                                           selector:selector
                                                                           argument:argument1
                                                                           argument:argument2
                                                                               gate:gate
                                                                            visible:visible];
    [invocation performSelectorInBackground:@selector(run) withObject:nil];
}


+ (void)       performSelector:(SEL) selector
                      onTarget:(id) target
      inBackgroundWithArgument:(id) argument
                          gate:(id<NSLocking>) gate
                       visible:(BOOL) visible {
    BackgroundInvocation* invocation = [BackgroundInvocation invocationWithTarget:target
                                                                         selector:selector
                                                                         argument:argument
                                                                             gate:gate
                                                                          visible:visible];
    [invocation performSelectorInBackground:@selector(run) withObject:nil];
}


+ (void) performSelector:(SEL) selector
                onTarget:(id) target
    inBackgroundWithGate:(id<NSLocking>) gate
                 visible:(BOOL) visible {
    [self performSelector:selector
                 onTarget:target
 inBackgroundWithArgument:nil
                     gate:gate
                  visible:visible];
}


+ (void) performSelector:(SEL) selector
                onTarget:(id) target
onMainThreadWithArgument:(id) argument {
    [target performSelectorOnMainThread:selector withObject:argument waitUntilDone:NO];
}


+ (void) performSelector:(SEL) selector
                onTarget:(id) target
onMainThreadWithArgument:(id) argument1
                argument:(id) argument2 {
    Invocation2* invocation = [Invocation2 invocationWithTarget:target selector:selector argument:argument1 argument:argument2];
    [invocation performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:NO];
}

@end