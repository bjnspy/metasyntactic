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

#import "BackgroundInvocation3.h"

@interface BackgroundInvocation2()
- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
           withObject:(id) argument1_
           withObject:(id) argument2_
                 gate:(id<NSLocking>) gate_
               daemon:(BOOL) daemon_;
@end

@interface BackgroundInvocation3()
@property (retain) id argument3;
@end


@implementation BackgroundInvocation3

@synthesize argument3;

- (void) dealloc {
  self.argument3 = nil;
  [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
           withObject:(id) argument1_
           withObject:(id) argument2_
           withObject:(id) argument3_
                 gate:(id<NSLocking>) gate_
               daemon:(BOOL) daemon_ {
  if ((self = [super initWithTarget:target_
                           selector:selector_
                         withObject:argument1_
                         withObject:argument2_
                               gate:gate_
                             daemon:daemon_])) {
    self.argument3 = argument3_;
  }

  return self;
}


+ (BackgroundInvocation3*) invocationWithTarget:(id) target
                                       selector:(SEL) selector
                                     withObject:(id) argument1
                                     withObject:(id) argument2
                                     withObject:(id) argument3
                                           gate:(id<NSLocking>) gate
                                         daemon:(BOOL) daemon {
  return [[[BackgroundInvocation3 alloc] initWithTarget:target
                                               selector:selector
                                             withObject:argument1
                                             withObject:argument2
                                             withObject:argument3
                                                   gate:gate
                                                 daemon:daemon] autorelease];
}


- (void) invokeSelector {
  IMP imp = [target methodForSelector:selector];
  imp(target, selector, argument, argument2, argument3);
}

@end
