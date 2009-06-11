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

#import "BackgroundInvocation.h"

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
  
  if (daemon) {
    [NSThread setThreadPriority:0.0];
  } else {
    [NSThread setThreadPriority:0.25];
  }
  
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
