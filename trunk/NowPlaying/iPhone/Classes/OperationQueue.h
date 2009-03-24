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
    Now      = NSOperationQueuePriorityVeryHigh,
    Priority = NSOperationQueuePriorityVeryHigh - 1,
    Search   = NSOperationQueuePriorityHigh,
    High     = NSOperationQueuePriorityNormal,
    Normal   = NSOperationQueuePriorityLow,
    Low      = NSOperationQueuePriorityVeryLow,
} QueuePriority;

@interface OperationQueue : NSObject {
@private
    NSOperationQueue* queue_;
    NSMutableArray* boundedOperations_;
    NSLock* boundedOperationsGate_;
}

+ (OperationQueue*) operationQueue;

- (Operation*) performSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation*) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation*) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate priority:(QueuePriority) priority;

- (Operation*) performBoundedSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation*) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation*) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate priority:(QueuePriority) priority;

/* @package */
- (void) onAfterBoundedOperationCompleted:(Operation*) operation;

@end