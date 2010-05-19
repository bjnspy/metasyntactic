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

#import "BackgroundInvocation.h"

@interface Invocation()
- (id) initWithTarget:(id) target
             selector:(SEL) selector
           withObject:(id) argument;
@end

@interface BackgroundInvocation()
@property (retain) id<NSLocking> gate;
@property BOOL daemon;
@end


@implementation BackgroundInvocation

static NSLock* dataGate = nil;
static NSInteger nonDaemonBackgroundTaskCount = 0;

+ (void) initialize {
  if (self == [BackgroundInvocation class]) {
    dataGate = [[NSLock alloc] init];
  }
}

@synthesize gate;
@synthesize daemon;

- (void) dealloc {
  self.gate = nil;
  self.daemon = NO;

  [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
           withObject:(id) argument_
                 gate:(id<NSLocking>) gate_
               daemon:(BOOL) daemon_ {
  if ((self = [super initWithTarget:target_ selector:selector_ withObject:argument_])) {
    self.gate = gate_;
    self.daemon = daemon_;
  }

  return self;
}


+ (BackgroundInvocation*) invocationWithTarget:(id) target
                                      selector:(SEL) selector
                                    withObject:(id) argument
                                          gate:(id<NSLocking>) gate
                                        daemon:(BOOL) daemon {
  return [[[BackgroundInvocation alloc] initWithTarget:target
                                              selector:selector
                                            withObject:argument
                                                  gate:gate
                                                daemon:daemon] autorelease];
}


- (void) invokeSelector {
  [target performSelector:selector withObject:argument];
}


- (void) runWorker {
  NSString* className = NSStringFromClass([target class]);
  NSString* selectorName = NSStringFromSelector(selector);
  NSString* name = [NSString stringWithFormat:@"%@-%@", className, selectorName];
  [[NSThread currentThread] setName:name];

  [NSThread setThreadPriority:0.0];

  if (!daemon) {
    [dataGate lock];
    {
      nonDaemonBackgroundTaskCount++;
    }
    [dataGate unlock];
  }

  [gate lock];
  {
    [self invokeSelector];
  }
  [gate unlock];

  if (!daemon) {
    [dataGate lock];
    {
      nonDaemonBackgroundTaskCount--;
    }
    [dataGate unlock];
  }
}


- (void) run {
  NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
  {
    [self runWorker];
  }
  [autoreleasePool release];
}


+ (BOOL) hasNonDaemonBackgroundTasks {
  BOOL result;
  [dataGate lock];
  {
    result = nonDaemonBackgroundTaskCount != 0;
  }
  [dataGate unlock];
  return result;
}

@end
