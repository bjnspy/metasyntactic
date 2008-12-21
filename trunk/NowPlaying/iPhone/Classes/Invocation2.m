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

#import "Invocation2.h"

@interface Invocation2()
@property (retain) id argument2;
@end

@implementation Invocation2

@synthesize argument2;

- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id) argument1_
             argument:(id) argument2_ {
    if (self = [super initWithTarget:target_ selector:selector_ argument:argument1_]) {
        self.argument2 = argument2_;
    }
    
    return self;
}


+ (Invocation2*) invocationWithTarget:(id) target
                             selector:(SEL) selector
                             argument:(id) argument1
                             argument:(id) argument2 {
    return [[[Invocation2 alloc] initWithTarget:target
                                      selector:selector
                                      argument:argument1
                                      argument:argument2] autorelease];
}


- (void) run {
    [target performSelector:selector withObject:argument withObject:argument2];
}

@end