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
  id<NSLocking> dataGate;

  NSMutableArray* boundedOperations;
  NSInteger priorityOperationsCount;

  NSInteger maxBoundedOperations;
}

+ (OperationQueue*) operationQueue;

- (void) restart:(Operation*) operationToKill;

- (Operation*) performSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation1*) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation2*) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation3*) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 withObject:(id) object3 gate:(id<NSLocking>) gate priority:(QueuePriority) priority;

- (Operation*) performBoundedSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation1*) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate priority:(QueuePriority) priority;
- (Operation2*) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate priority:(QueuePriority) priority;

- (void) temporarilySuspend:(NSTimeInterval) interval;
- (void) temporarilySuspend;
- (void) resume;

- (BOOL) hasPriorityOperations;

/* @package */
- (void) notifyOperationDestroyed:(Operation*) operation
                     withPriority:(QueuePriority) priority;
- (void) onAfterBoundedOperationCompleted:(Operation*) operation;

@end
