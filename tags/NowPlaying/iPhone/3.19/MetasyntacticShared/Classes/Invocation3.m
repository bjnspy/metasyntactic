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

#import "Invocation3.h"

@interface Invocation2()
- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
           withObject:(id) argument1_
           withObject:(id) argument2_;
@end

@interface Invocation3()
@property (retain) id argument3;
@end

@implementation Invocation3

@synthesize argument3;

- (void) dealloc {
  self.argument3 = nil;
  [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
           withObject:(id) argument1_
           withObject:(id) argument2_
           withObject:(id) argument3_ {
  if ((self = [super initWithTarget:target_ selector:selector_ withObject:argument1_ withObject:argument2_])) {
    self.argument3 = argument3_;
  }

  return self;
}


+ (Invocation3*) invocationWithTarget:(id) target
                             selector:(SEL) selector
                           withObject:(id) argument1
                           withObject:(id) argument2
                           withObject:(id) argument3 {
  return [[[Invocation3 alloc] initWithTarget:target
                                     selector:selector
                                   withObject:argument1
                                   withObject:argument2
                                   withObject:argument3] autorelease];
}


- (void) run {
  IMP imp = [target methodForSelector:selector];
  imp(target, selector, argument, argument2, argument3);
}

@end
