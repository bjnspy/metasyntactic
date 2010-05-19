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

#import "Operation.h"

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
  if ((self = [super init])) {
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
  [target performSelector:selector];
}


- (void) main {
  [NSThread setThreadPriority:0];

  [gate lock];
  {
    if (!self.isCancelled) {
      [self mainWorker];
    }
  }
  [gate unlock];

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
