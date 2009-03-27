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

typedef enum {
    // A 'Now' request must happen immediately.  i.e. when the user is actually
    // looking at a movie, or when we need to get up to date data.
    Now      = NSOperationQueuePriorityVeryHigh,

    // Prioritized requests are for things the user can see, but hasn't drilled
    // into yet.  Each priority request is dependent on the the next one.  That
    // way as we add new priority requests they'll be more likely to process
    // than any previous ones.
    Priority = NSOperationQueuePriorityHigh,

    // Search results are in the middle.  Top priority requests will supercede
    // them, but standard cache operations will happen afterwards.
    Search   = NSOperationQueuePriorityNormal,

    // Two levels of priorities for updating cache values.
    Normal   = NSOperationQueuePriorityLow,
    Low      = NSOperationQueuePriorityVeryLow,
} QueuePriority;

@interface OperationQueue : NSObject {
@private
    NSOperationQueue* queue;
    NSLock* dataGate;

    NSMutableArray* boundedOperations;
    NSInteger priorityOperationsCount;
}

+ (OperationQueue*) operationQueue;

- (Operation*) performSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation1*) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation2*) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate priority:(QueuePriority) priority;

- (Operation*) performBoundedSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation1*) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation2*) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate priority:(QueuePriority) priority;

- (void) temporarilySuspend;

- (BOOL) hasPriorityOperations;

/* @package */
- (void) notifyOperationCreated:(QueuePriority) priority;
- (void) notifyOperationDestroyed:(QueuePriority) priority;
- (void) onAfterBoundedOperationCompleted:(Operation*) operation;

@end